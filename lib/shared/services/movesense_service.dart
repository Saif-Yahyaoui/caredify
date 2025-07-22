import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/ecg_sample.dart';

class MovesenseService {
  final FlutterReactiveBle _ble = FlutterReactiveBle();
  // JonasPrimbs firmware UUIDs
  final String _activityServiceUuid = '00001859-0000-1000-8000-00805F9B34FB';
  final String _ecgVoltageCharUuid = '00002BDD-0000-1000-8000-00805F9B34FB';

  Stream<BleStatus>? _bleStatus;
  StreamSubscription<BleStatus>? _bleStatusSubscription;
  StreamSubscription<DiscoveredDevice>? _scanSubscription;
  StreamSubscription<ConnectionStateUpdate>? _connectionSubscription;

  // Stream controllers
  final _deviceController = StreamController<DiscoveredDevice>.broadcast();
  final _connectionStateController =
      StreamController<ConnectionStateUpdate>.broadcast();

  Stream<DiscoveredDevice> get deviceStream => _deviceController.stream;
  Stream<ConnectionStateUpdate> get connectionStateStream =>
      _connectionStateController.stream;

  final EcgSampleBuffer _ecgBuffer = EcgSampleBuffer();
  final _ecgSampleController = StreamController<EcgSample>.broadcast();
  Stream<EcgSample> get ecgSampleStream => _ecgSampleController.stream;

  StreamSubscription<List<int>>? _ecgNotificationSubscription;

  Future<void> initialize() async {
    // Request permissions
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.location.request();

    // Monitor BLE status
    _bleStatus = _ble.statusStream;
    _bleStatusSubscription = _bleStatus?.listen((status) {
      debugPrint('BLE Status: $status');
    });
  }

  void startScan() {
    _scanSubscription = _ble
        .scanForDevices(
          withServices: [Uuid.parse(_activityServiceUuid)],
          scanMode: ScanMode.lowLatency,
        )
        .listen(
          (device) => _deviceController.add(device),
          onError: (error) => debugPrint('Error scanning: $error'),
        );
  }

  void stopScan() {
    _scanSubscription?.cancel();
  }

  Future<void> connectToDevice(DiscoveredDevice device) async {
    _connectionSubscription = _ble
        .connectToDevice(
          id: device.id,
          connectionTimeout: const Duration(seconds: 10),
        )
        .listen(
          (update) => _connectionStateController.add(update),
          onError: (error) => debugPrint('Error connecting: $error'),
        );
  }

  Future<void> disconnect() async {
    await _connectionSubscription?.cancel();
  }

  Future<void> subscribeToEcgData(String deviceId) async {
    _ecgNotificationSubscription = _ble
        .subscribeToCharacteristic(
          QualifiedCharacteristic(
            serviceId: Uuid.parse(_activityServiceUuid),
            characteristicId: Uuid.parse(_ecgVoltageCharUuid),
            deviceId: deviceId,
          ),
        )
        .listen(
          (data) {
            final now = DateTime.now();
            for (int i = 0; i < data.length; i += 2) {
              if (i + 1 < data.length) {
                int value = data[i] | (data[i + 1] << 8);
                if (value & 0x8000 != 0) {
                  value = value - 0x10000; // signed 16-bit
                }
                if (value != -32768) {
                  final sample = EcgSample(value: value, timestamp: now);
                  _ecgBuffer.addSample(sample);
                  _ecgSampleController.add(sample);
                }
              }
            }
          },
          onError: (e) {
            debugPrint('ECG notification error: $e');
          },
        );
  }

  Future<void> unsubscribeFromEcgData() async {
    await _ecgNotificationSubscription?.cancel();
  }

  List<EcgSample> get bufferedSamples => _ecgBuffer.samples;

  Future<void> dispose() async {
    await _bleStatusSubscription?.cancel();
    await _scanSubscription?.cancel();
    await _connectionSubscription?.cancel();
    await _deviceController.close();
    await _connectionStateController.close();
  }
}
