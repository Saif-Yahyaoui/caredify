import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ecg_analysis_result.dart';
import '../services/ecg_analysis_service.dart';

/// Provider for ECG Analysis Service
final ecgAnalysisServiceProvider = Provider<EcgAnalysisService>((ref) {
  return EcgAnalysisService();
});

/// Provider for ECG analysis results
final ecgAnalysisResultProvider =
    StateNotifierProvider<EcgAnalysisNotifier, AsyncValue<EcgAnalysisResult?>>((
      ref,
    ) {
      final service = ref.watch(ecgAnalysisServiceProvider);
      return EcgAnalysisNotifier(service);
    });

/// Provider for ECG analysis history
final ecgAnalysisHistoryProvider =
    StateNotifierProvider<EcgAnalysisHistoryNotifier, List<EcgAnalysisResult>>((
      ref,
    ) {
      return EcgAnalysisHistoryNotifier();
    });

/// Provider for ECG signal data
final ecgSignalDataProvider =
    StateNotifierProvider<EcgSignalDataNotifier, List<double>>((ref) {
      return EcgSignalDataNotifier();
    });

/// Notifier for ECG analysis results
class EcgAnalysisNotifier
    extends StateNotifier<AsyncValue<EcgAnalysisResult?>> {
  final EcgAnalysisService _service;

  EcgAnalysisNotifier(this._service) : super(const AsyncValue.loading());

  /// Initialize the service
  Future<void> initialize() async {
    state = const AsyncValue.loading();
    try {
      await _service.initialize();
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Analyze ECG signal
  Future<void> analyzeEcgSignal(
    List<double> ecgData, {
    DateTime? startTime,
    DateTime? endTime,
  }) async {
    state = const AsyncValue.loading();
    try {
      final result = await _service.analyzeEcgSignal(
        ecgData,
        startTime: startTime,
        endTime: endTime,
      );
      state = AsyncValue.data(result);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Clear current analysis result
  void clearResult() {
    state = const AsyncValue.data(null);
  }

  /// Get the current analysis result
  EcgAnalysisResult? get currentResult {
    return state.when(
      data: (data) => data,
      loading: () => null,
      error: (_, __) => null,
    );
  }

  /// Check if analysis is in progress
  bool get isAnalyzing {
    return state.isLoading;
  }

  /// Check if there's an error
  bool get hasError {
    return state.hasError;
  }
}

/// Notifier for ECG analysis history
class EcgAnalysisHistoryNotifier
    extends StateNotifier<List<EcgAnalysisResult>> {
  EcgAnalysisHistoryNotifier() : super([]);

  /// Add a new analysis result to history
  void addResult(EcgAnalysisResult result) {
    state = [result, ...state];
  }

  /// Clear history
  void clearHistory() {
    state = [];
  }

  /// Get recent results (last 10)
  List<EcgAnalysisResult> get recentResults {
    return state.take(10).toList();
  }

  /// Get abnormal results
  List<EcgAnalysisResult> get abnormalResults {
    return state.where((result) => result.isAbnormal).toList();
  }

  /// Get high confidence results
  List<EcgAnalysisResult> get highConfidenceResults {
    return state.where((result) => result.isHighConfidence).toList();
  }

  /// Get average confidence
  double get averageConfidence {
    if (state.isEmpty) return 0.0;
    final total = state.fold(0.0, (sum, result) => sum + result.confidence);
    return total / state.length;
  }

  /// Get abnormality rate
  double get abnormalityRate {
    if (state.isEmpty) return 0.0;
    final abnormalCount = state.where((result) => result.isAbnormal).length;
    return abnormalCount / state.length;
  }
}

/// Notifier for ECG signal data
class EcgSignalDataNotifier extends StateNotifier<List<double>> {
  EcgSignalDataNotifier() : super([]);

  /// Set ECG signal data
  void setSignalData(List<double> data) {
    state = data;
  }

  /// Add data point to signal
  void addDataPoint(double value) {
    state = [...state, value];
  }

  /// Clear signal data
  void clearData() {
    state = [];
  }

  /// Get signal length
  int get length => state.length;

  /// Check if signal is empty
  bool get isEmpty => state.isEmpty;

  /// Get signal statistics
  Map<String, double> get statistics {
    if (state.isEmpty) {
      return {'mean': 0.0, 'min': 0.0, 'max': 0.0, 'std': 0.0};
    }

    final mean = state.reduce((a, b) => a + b) / state.length;
    final min = state.reduce((a, b) => a < b ? a : b);
    final max = state.reduce((a, b) => a > b ? a : b);
    final variance =
        state.map((x) => (x - mean) * (x - mean)).reduce((a, b) => a + b) /
        state.length;
    final std = sqrt(variance);

    return {'mean': mean, 'min': min, 'max': max, 'std': std};
  }
}

/// Provider for ECG analysis statistics
final ecgAnalysisStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final history = ref.watch(ecgAnalysisHistoryProvider);
  final historyNotifier = ref.watch(ecgAnalysisHistoryProvider.notifier);
  ref.watch(ecgSignalDataProvider);
  final signalDataNotifier = ref.watch(ecgSignalDataProvider.notifier);

  return {
    'totalAnalyses': history.length,
    'abnormalRate': historyNotifier.abnormalityRate,
    'averageConfidence': historyNotifier.averageConfidence,
    'recentAbnormal': historyNotifier.abnormalResults.take(5).length,
    'signalLength': signalDataNotifier.length,
    'signalStats': signalDataNotifier.statistics,
  };
});

/// Provider for ECG alerts
final ecgAlertsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final currentResult = ref.watch(ecgAnalysisResultProvider).value;
  final historyNotifier = ref.watch(ecgAnalysisHistoryProvider.notifier);

  final alerts = <Map<String, dynamic>>[];

  // Check current result for alerts
  if (currentResult != null) {
    if (currentResult.isAbnormal && currentResult.isHighConfidence) {
      alerts.add({
        'type': 'high_priority',
        'title': 'ECG Anomaly Detected',
        'message':
            'High confidence abnormal ECG detected. Please consult your healthcare provider.',
        'timestamp': currentResult.timestamp,
        'priority': 'high',
      });
    } else if (currentResult.isAbnormal) {
      alerts.add({
        'type': 'medium_priority',
        'title': 'Potential ECG Issue',
        'message':
            'Abnormal ECG pattern detected. Monitor symptoms and consider medical consultation.',
        'timestamp': currentResult.timestamp,
        'priority': 'medium',
      });
    }
  }

  // Check history for trends
  final recentAbnormal = historyNotifier.abnormalResults.take(3).length;
  if (recentAbnormal >= 2) {
    alerts.add({
      'type': 'trend_alert',
      'title': 'Multiple Abnormal Readings',
      'message':
          'Multiple abnormal ECG readings detected recently. Consider medical evaluation.',
      'timestamp': DateTime.now(),
      'priority': 'medium',
    });
  }

  return alerts;
});
