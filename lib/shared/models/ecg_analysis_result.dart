/// Model representing the result of ECG analysis from the AI model
class EcgAnalysisResult {
  final String classification; // 'Normal' or 'Abnormal'
  final double confidence; // Confidence score between 0.0 and 1.0
  final List<String> recommendations; // Health recommendations
  final Map<String, dynamic>? additionalMetrics; // Additional ECG metrics
  final DateTime timestamp; // When the analysis was performed
  final String? modelVersion; // Version of the model used

  const EcgAnalysisResult({
    required this.classification,
    required this.confidence,
    required this.recommendations,
    this.additionalMetrics,
    required this.timestamp,
    this.modelVersion,
  });

  /// Create from JSON
  factory EcgAnalysisResult.fromJson(Map<String, dynamic> json) {
    return EcgAnalysisResult(
      classification: json['classification'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      recommendations: List<String>.from(json['recommendations'] ?? []),
      additionalMetrics: json['additionalMetrics'] as Map<String, dynamic>?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      modelVersion: json['modelVersion'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'classification': classification,
      'confidence': confidence,
      'recommendations': recommendations,
      'additionalMetrics': additionalMetrics,
      'timestamp': timestamp.toIso8601String(),
      'modelVersion': modelVersion,
    };
  }

  /// Check if the result indicates an abnormal ECG
  bool get isAbnormal => classification.toLowerCase() == 'abnormal';

  /// Check if the result has high confidence
  bool get isHighConfidence => confidence >= 0.8;

  /// Get the confidence percentage
  int get confidencePercentage => (confidence * 100).round();

  /// Get priority level for alerts
  String get priorityLevel {
    if (isAbnormal && isHighConfidence) return 'high';
    if (isAbnormal && !isHighConfidence) return 'medium';
    return 'low';
  }

  /// Copy with modifications
  EcgAnalysisResult copyWith({
    String? classification,
    double? confidence,
    List<String>? recommendations,
    Map<String, dynamic>? additionalMetrics,
    DateTime? timestamp,
    String? modelVersion,
  }) {
    return EcgAnalysisResult(
      classification: classification ?? this.classification,
      confidence: confidence ?? this.confidence,
      recommendations: recommendations ?? this.recommendations,
      additionalMetrics: additionalMetrics ?? this.additionalMetrics,
      timestamp: timestamp ?? this.timestamp,
      modelVersion: modelVersion ?? this.modelVersion,
    );
  }

  @override
  String toString() {
    return 'EcgAnalysisResult(classification: $classification, confidence: $confidence, recommendations: $recommendations)';
  }
}
