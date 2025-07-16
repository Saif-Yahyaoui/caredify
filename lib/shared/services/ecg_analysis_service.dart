import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/ecg_analysis_result.dart';

/// Service for ECG signal analysis using the AI model
class EcgAnalysisService {
  static final EcgAnalysisService _instance = EcgAnalysisService._internal();
  factory EcgAnalysisService() => _instance;
  EcgAnalysisService._internal();

  bool _isInitialized = false;
  static const int _inputSize =
      1000; // Adjust based on your model's expected input size

  /// Initialize the ECG analysis service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // For now, we'll use mock analysis until TensorFlow Lite is properly integrated
      _isInitialized = true;

      if (kDebugMode) {
        debugPrint('ECG Analysis Service initialized successfully');
        debugPrint('Using mock analysis mode');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error initializing ECG Analysis Service: $e');
      }
      _isInitialized = true;
    }
  }

  /// Analyze ECG signal data
  Future<EcgAnalysisResult> analyzeEcgSignal(List<double> ecgData) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Preprocess the ECG signal
      final processedData = _preprocessEcgSignal(ecgData);

      // Use mock analysis for now
      return _mockAnalysis(processedData);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error analyzing ECG signal: $e');
      }
      // Return a safe default result
      return EcgAnalysisResult(
        classification: 'Normal',
        confidence: 0.5,
        recommendations: ['Unable to analyze ECG signal', 'Please try again'],
        timestamp: DateTime.now(),
        modelVersion: 'mock-1.0',
      );
    }
  }

  /// Preprocess ECG signal for model input
  List<double> _preprocessEcgSignal(List<double> rawEcg) {
    // 1. Normalize the signal
    final normalized = _normalizeSignal(rawEcg);

    // 2. Apply bandpass filter (simplified)
    final filtered = _applyBandpassFilter(normalized);

    // 3. Resample to model input size
    final resampled = _resampleSignal(filtered, _inputSize);

    return resampled;
  }

  /// Normalize signal to zero mean and unit variance
  List<double> _normalizeSignal(List<double> signal) {
    final mean = signal.reduce((a, b) => a + b) / signal.length;
    final variance =
        signal.map((x) => pow(x - mean, 2)).reduce((a, b) => a + b) /
        signal.length;
    final std = sqrt(variance);

    return signal.map((x) => (x - mean) / std).toList();
  }

  /// Apply simplified bandpass filter (0.5-40 Hz for ECG)
  List<double> _applyBandpassFilter(List<double> signal) {
    // Simplified moving average filter
    const windowSize = 5;
    final filtered = <double>[];

    for (int i = 0; i < signal.length; i++) {
      final start = max(0, i - windowSize ~/ 2);
      final end = min(signal.length, i + windowSize ~/ 2 + 1);
      final window = signal.sublist(start, end);
      final average = window.reduce((a, b) => a + b) / window.length;
      filtered.add(average);
    }

    return filtered;
  }

  /// Resample signal to target length
  List<double> _resampleSignal(List<double> signal, int targetLength) {
    if (signal.length == targetLength) return signal;

    final resampled = <double>[];
    for (int i = 0; i < targetLength; i++) {
      final index = (i * signal.length / targetLength).floor();
      resampled.add(signal[index]);
    }

    return resampled;
  }

  /// Mock analysis for development/testing
  EcgAnalysisResult _mockAnalysis(List<double> processedData) {
    // Simulate model analysis with realistic probabilities
    final random = Random();
    final normalProb = 0.7 + random.nextDouble() * 0.25; // 70-95% normal
    final abnormalProb = 1.0 - normalProb;

    final classification = normalProb > abnormalProb ? 'Normal' : 'Abnormal';
    final confidence = max(normalProb, abnormalProb);

    return EcgAnalysisResult(
      classification: classification,
      confidence: confidence,
      recommendations: _generateRecommendations(classification, confidence),
      additionalMetrics: {
        'normal_probability': normalProb,
        'abnormal_probability': abnormalProb,
        'signal_quality': _calculateSignalQuality(processedData),
        'mock_analysis': true,
      },
      timestamp: DateTime.now(),
      modelVersion: 'mock-1.0',
    );
  }

  /// Generate health recommendations based on analysis
  List<String> _generateRecommendations(
    String classification,
    double confidence,
  ) {
    final recommendations = <String>[];

    if (classification == 'Normal') {
      recommendations.add('Continue regular monitoring');
      if (confidence < 0.8) {
        recommendations.add('Consider lifestyle improvements');
      }
    } else {
      recommendations.add('Consult your healthcare provider');
      recommendations.add('Monitor symptoms closely');
      if (confidence > 0.8) {
        recommendations.add(
          'Seek immediate medical attention if symptoms worsen',
        );
      }
    }

    recommendations.add('Maintain healthy lifestyle habits');
    return recommendations;
  }

  /// Calculate signal quality score
  double _calculateSignalQuality(List<double> signal) {
    // Calculate signal-to-noise ratio (simplified)
    final mean = signal.reduce((a, b) => a + b) / signal.length;
    final variance =
        signal.map((x) => pow(x - mean, 2)).reduce((a, b) => a + b) /
        signal.length;
    final snr =
        20 * log(sqrt(variance) / 0.1) / ln10; // Assuming noise floor of 0.1

    // Normalize to 0-1 range
    return max(0.0, min(1.0, (snr + 20) / 40));
  }

  /// Check if the service is initialized
  bool get isInitialized => _isInitialized;

  /// Dispose resources
  void dispose() {
    _isInitialized = false;
  }
}
