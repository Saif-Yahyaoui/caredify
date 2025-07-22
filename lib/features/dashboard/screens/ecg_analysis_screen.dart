// ignore_for_file: unused_field

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:caredify/features/dashboard/widgets/ecg_waveform_pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/models/ecg_sample.dart';
import '../../../shared/providers/ecg_analysis_provider.dart';
import '../../../shared/services/movesense_service.dart';
import '../../../shared/widgets/cards/ecg_ai_analysis_card.dart';
import '../../../shared/widgets/cards/premium_recommendation_card.dart';
import '../../../shared/widgets/charts/ecg_waveform_chart.dart';
import '../../../shared/widgets/navigation/premium_tabbar.dart';
import '../../../shared/widgets/sections/section_header.dart';

class EcgAnalysisScreen extends ConsumerStatefulWidget {
  final int initialTab;
  const EcgAnalysisScreen({super.key, this.initialTab = 0});

  @override
  ConsumerState<EcgAnalysisScreen> createState() => _EcgAnalysisScreenState();
}

class _EcgAnalysisScreenState extends ConsumerState<EcgAnalysisScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;
  late final MovesenseService _movesenseService;
  List<EcgSample> ecgSamples = [];
  Stream? _ecgStream;
  Stream? _connectionStream;
  Stream? _deviceStream;
  DiscoveredDevice? _selectedDevice;
  bool _isConnecting = false;
  bool _isConnected = false;
  String? _connectionError;
  bool _isRecording = false;
  final List<EcgSample> _recordedSamples = [];
  int _battery = 0;
  int _samplingRate = 125;
  final List<Map<String, dynamic>> _sessionHistory = [];

  Timer? _mockEcgTimer;
  int _mockSampleIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedTab = index;
      _tabController.animateTo(index);
    });
  }

  final List<_PremiumTabData> _tabs = const [
    _PremiumTabData('Overview', Icons.insights),
    _PremiumTabData('History', Icons.history),
    _PremiumTabData('Trends', Icons.show_chart),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTab,
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() {
        _selectedTab = _tabController.index;
      });
    });
    _movesenseService = MovesenseService();
    _movesenseService.initialize();
    _connectionStream = _movesenseService.connectionStateStream;
    _ecgStream = _movesenseService.ecgSampleStream;
    _deviceStream = _movesenseService.deviceStream;
    _movesenseService.startScan();
    _connectionStream?.listen(
      (event) {
        setState(() {
          if (event.connectionState == DeviceConnectionState.connected) {
            _isConnecting = false;
            _isConnected = true;
            _connectionError = null;
          } else if (event.connectionState ==
              DeviceConnectionState.connecting) {
            _isConnecting = true;
            _isConnected = false;
            _connectionError = null;
          } else if (event.connectionState ==
              DeviceConnectionState.disconnected) {
            _isConnecting = false;
            _isConnected = false;
            _connectionError = 'Disconnected from device.';
          } else if (event.connectionState ==
              DeviceConnectionState.disconnecting) {
            _isConnecting = true;
            _isConnected = false;
            _connectionError = null;
          }
        });
      },
      onError: (e) {
        setState(() {
          _isConnecting = false;
          _isConnected = false;
          _connectionError = 'Connection error: $e';
        });
      },
    );
    _deviceStream?.listen((device) {
      setState(() {
        // If battery and sampling rate are in device.advertisementData or similar, extract here
        if (device.manufacturerData != null &&
            device.manufacturerData.isNotEmpty) {
          // Example: parse battery from manufacturerData (customize as needed)
          final data = device.manufacturerData.values.first;
          if (data.length > 0) _battery = data[0];
          if (data.length > 1) _samplingRate = data[1];
        }
      });
    });
    // Buffer ECG samples for chart and export
    _ecgStream?.listen((sample) {
      setState(() {
        ecgSamples.add(sample);
        if (_isRecording) {
          _recordedSamples.add(sample);
        }
      });
    });
    // In a real app, handle device selection and connection here
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ecgAnalysisResultProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _movesenseService.dispose();
    super.dispose();
  }

  void _showDeviceSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Select Movesense Device'),
          content: SizedBox(
            width: 300,
            height: 300,
            child: StreamBuilder<DiscoveredDevice>(
              stream: _deviceStream as Stream<DiscoveredDevice>,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final device = snapshot.data!;
                return ListView(
                  children: [
                    ListTile(
                      title: Text(
                        device.name.isNotEmpty ? device.name : device.id,
                      ),
                      subtitle: Text(device.id),
                      onTap: () {
                        setState(() {
                          _selectedDevice = device;
                          _isConnecting = true;
                        });
                        Navigator.of(context).pop();
                        _movesenseService.connectToDevice(device);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _recordedSamples.clear();
      _mockSampleIndex = 0;
    });
    // Simulate ECG data at 125Hz
    _mockEcgTimer = Timer.periodic(const Duration(milliseconds: 8), (timer) {
      if (!_isRecording) {
        timer.cancel();
        return;
      }
      final t = _mockSampleIndex / 125.0;
      final value =
          (1000 *
                  (0.5 * sin(2 * pi * 1.2 * t) +
                      0.1 * sin(2 * pi * 2.4 * t) +
                      0.05 * Random().nextDouble()))
              .toInt();
      final sample = EcgSample(value: value, timestamp: DateTime.now());
      setState(() {
        ecgSamples.add(sample);
        _recordedSamples.add(sample);
      });
      _mockSampleIndex++;
    });
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
    });
    _mockEcgTimer?.cancel();
  }

  void _exportCsv() async {
    if (_recordedSamples.isEmpty) return;
    final buffer = StringBuffer();
    buffer.writeln('timestamp,value');
    for (final sample in _recordedSamples) {
      buffer.writeln('${sample.timestamp.toIso8601String()},${sample.value}');
    }
    final directory = await getApplicationDocumentsDirectory();
    final filePath =
        '${directory.path}/ecg_session_${DateTime.now().millisecondsSinceEpoch}.csv';
    final file = await File(filePath).writeAsString(buffer.toString());
    await Share.shareXFiles([XFile(file.path)], text: 'ECG Session Data');
    setState(() {
      _sessionHistory.insert(0, {
        'type': 'CSV',
        'date': DateTime.now(),
        'file': filePath,
        'samples': _recordedSamples.length,
      });
    });
  }

  void _exportPdf() async {
    if (_recordedSamples.isEmpty) return;
    final pdf = pw.Document();
    const width = 500.0;
    const height = 200.0;
    final values = _recordedSamples.map((e) => e.value).toList();

    pdf.addPage(
      pw.Page(
        build:
            (context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'ECG Session Report',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text('Samples: ${_recordedSamples.length}'),
                pw.Text('Start: ${_recordedSamples.first.timestamp}'),
                pw.Text('End: ${_recordedSamples.last.timestamp}'),
                pw.SizedBox(height: 16),
                pw.Container(
                  width: width,
                  height: height,
                  child: buildEcgWaveformPdfPaint(
                    values: values,
                    width: width,
                    height: height,
                  ),
                ),
              ],
            ),
      ),
    );
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
    setState(() {
      _sessionHistory.insert(0, {
        'type': 'PDF',
        'date': DateTime.now(),
        'file': pdf, // PDF is not saved to file, just printed
        'samples': _recordedSamples.length,
      });
    });
  }

  Widget _buildSessionHistory() {
    if (_sessionHistory.isEmpty) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Session Export History',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ..._sessionHistory.map(
          (entry) => ListTile(
            leading: Icon(
              entry['type'] == 'PDF' ? Icons.picture_as_pdf : Icons.table_chart,
            ),
            title: Text('${entry['type']} export'),
            subtitle: Text(
              'Samples: ${entry['samples']} | ${entry['date'].toString().substring(0, 16)}',
            ),
            trailing:
                entry['file'] != null
                    ? IconButton(
                      icon: const Icon(Icons.open_in_new),
                      onPressed: () {
                        Share.shareXFiles([
                          XFile(entry['file']),
                        ], text: 'ECG Session Data');
                      },
                    )
                    : null,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ECG Analysis'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: PremiumTabBar(
            tabs: _tabs.map((t) => TabData(t.label, t.icon)).toList(),
            selectedIndex: _selectedTab,
            onTabSelected: _onTabSelected,
            isDark: isDark,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.devices, color: AppColors.primaryBlue),

            tooltip: 'Select Device',
            onPressed: () => _showDeviceSelectionDialog(context),
          ),
          Icon(
            _isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
            color: _isConnected ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(context, theme, isDark),
          _buildHistoryTab(context, theme, isDark),
          _buildTrendsTab(context, theme, isDark),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, ThemeData theme, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPremiumSignalCard(context, theme, isDark),
          const SizedBox(height: 16),
          EcgAiAnalysisCard(
            onAnalyzeTap: _performEcgAnalysis,
            showAnalyzeButton: true,
          ),
          const SizedBox(height: 16),
          _buildSessionHistory(),
        ],
      ),
    );
  }

  String _formatDuration(num? seconds) {
    if (seconds == null) return '—';
    final min = (seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  Widget _buildPremiumSignalCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    final analysisResult = ref.watch(ecgAnalysisResultProvider).value;
    final metrics = analysisResult?.additionalMetrics;
    final String heartRate =
        metrics?['heart_rate'] != null
            ? '${metrics!['heart_rate'].toStringAsFixed(1)} BPM'
            : '—';
    final String duration =
        metrics?['duration'] != null
            ? _formatDuration(metrics!['duration'])
            : '—';
    final String signalQuality =
        metrics?['signal_quality'] != null
            ? '${(metrics!['signal_quality'] * 100).toStringAsFixed(0)}%'
            : '—';
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                isDark
                    ? [
                      const Color(0xFF1E293B).withAlpha((0.8 * 255).toInt()),
                      const Color(0xFF334155).withAlpha((0.6 * 255).toInt()),
                    ]
                    : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.show_chart,
                  color: AppColors.primaryBlue,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'ECG Signal',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'PREMIUM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(height: 200, child: _buildEcgChart(context, theme)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSignalMetric(
                    'Heart Rate',
                    heartRate,
                    Icons.favorite,
                  ),
                ),
                Expanded(
                  child: _buildSignalMetric(
                    'Signal Quality',
                    signalQuality,
                    Icons.signal_cellular_alt,
                  ),
                ),
                Expanded(
                  child: _buildSignalMetric('Duration', duration, Icons.timer),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Improved button layout
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            _isRecording ? _stopRecording : _startRecording,
                        child: Text(
                          _isRecording ? 'Stop Recording' : 'Start Recording',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            _isRecording || _recordedSamples.isEmpty
                                ? null
                                : _exportCsv,
                        child: const Text('Export CSV'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            _isRecording || _recordedSamples.isEmpty
                                ? null
                                : _exportPdf,
                        child: const Text('Export PDF'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEcgChart(BuildContext context, ThemeData theme) {
    return EcgWaveformChart(
      samples: ecgSamples,
      maxSamples: 512,
      lineColor: Colors.red,
      anomalyColor: Colors.orange,
      anomalyThreshold: 2000,
      onAnomalyDetected: _handleAnomaly,
    );
  }

  Widget _buildSignalMetric(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryBlue, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildHistoryTab(BuildContext context, ThemeData theme, bool isDark) {
    final history = ref.watch(ecgAnalysisHistoryProvider);
    if (history.isEmpty) {
      return Center(
        child: Text(
          'No analysis history yet.',
          style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final result = history[index];
        final isAbnormal = result.isAbnormal;
        final confidence = result.confidence;
        final recommendations = result.recommendations;
        final metrics = result.additionalMetrics;
        final modelVersion = result.modelVersion;
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isAbnormal ? Icons.warning : Icons.check_circle,
                      color: isAbnormal ? Colors.red : Colors.green,
                      size: 28,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      isAbnormal ? 'Abnormal ECG' : 'Normal ECG',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isAbnormal ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      result.timestamp.toString().substring(0, 16),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text('Confidence:', style: theme.textTheme.bodyMedium),
                    const SizedBox(width: 8),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: confidence,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isAbnormal ? Colors.red : Colors.green,
                        ),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(confidence * 100).toStringAsFixed(1)}%',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                if (recommendations.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Recommendations:',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  ...recommendations.map(
                    (rec) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_right,
                            size: 18,
                            color: AppColors.primaryBlue,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(rec, style: theme.textTheme.bodySmall),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                if (metrics != null && metrics.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Additional Metrics:',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  ...metrics.entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.analytics,
                            size: 16,
                            color: AppColors.primaryBlue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${entry.key}: ',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${entry.value}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                if (modelVersion != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Model Version: $modelVersion',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrendsTab(BuildContext context, ThemeData theme, bool isDark) {
    final stats = ref.watch(ecgAnalysisStatsProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.analytics,
                        color: AppColors.primaryBlue,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Analysis Statistics',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          'Total Analyses',
                          '${stats['totalAnalyses']}',
                          Icons.assessment,
                        ),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          'Abnormal Rate',
                          '${(stats['abnormalRate'] * 100).round()}%',
                          Icons.warning,
                        ),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          'Avg Confidence',
                          '${(stats['averageConfidence'] * 100).round()}%',
                          Icons.verified,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Personalized AI Advice Section
          const SectionHeader(
            title: 'Personalized AI Advice',
            icon: Icons.psychology,
            iconColor: Colors.deepPurple,
          ),
          const SizedBox(height: 8),
          PremiumRecommendationCard(
            icon: Icons.favorite,
            title: 'Monitor Irregularities',
            description:
                'Your abnormal ECG rate is slightly elevated. Consider consulting a cardiologist if you notice symptoms.',
            priority: 'High',
            priorityColor: Colors.orange,
            actionText: 'Find a Specialist',
            onAction: () {},
          ),
          PremiumRecommendationCard(
            icon: Icons.directions_walk,
            title: 'Stay Active',
            description:
                'Regular physical activity can help maintain a healthy heart rhythm.',
            priority: 'Medium',
            priorityColor: Colors.green,
            actionText: 'View Activity Tips',
            onAction: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryBlue, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Future<void> _performEcgAnalysis() async {
    if (_recordedSamples.isEmpty) return;
    final data = _recordedSamples.map((e) => e.value.toDouble()).toList();
    final startTime = _recordedSamples.first.timestamp;
    final endTime = _recordedSamples.last.timestamp;
    ref.read(ecgSignalDataProvider.notifier).setSignalData(data);
    await ref
        .read(ecgAnalysisResultProvider.notifier)
        .analyzeEcgSignal(data, startTime: startTime, endTime: endTime);
    final result = ref.read(ecgAnalysisResultProvider).value;
    if (result != null) {
      ref.read(ecgAnalysisHistoryProvider.notifier).addResult(result);
    }
  }

  void _handleAnomaly(int index, EcgSample sample) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Suspicious ECG pattern detected at sample $index (value: ${sample.value})',
        ),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _PremiumTabData {
  final String label;
  final IconData icon;
  const _PremiumTabData(this.label, this.icon);
}
