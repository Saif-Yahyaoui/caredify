import 'package:flutter_test/flutter_test.dart';
import 'package:caredify/shared/models/ecg_analysis_result.dart';

void main() {
  group('EcgAnalysisResult', () {
    test('should create a valid instance', () {
      final result = EcgAnalysisResult(
        classification: 'Normal',
        confidence: 0.85,
        recommendations: ['Stay healthy'],
        timestamp: DateTime.now(),
        modelVersion: 'mock-1.0',
      );
      expect(result.classification, 'Normal');
      expect(result.confidence, 0.85);
      expect(result.recommendations, contains('Stay healthy'));
      expect(result.modelVersion, 'mock-1.0');
    });

    test('should serialize and deserialize from JSON', () {
      final now = DateTime.now();
      final result = EcgAnalysisResult(
        classification: 'Abnormal',
        confidence: 0.2,
        recommendations: ['Consult a doctor'],
        timestamp: now,
        modelVersion: 'mock-1.0',
      );
      final json = result.toJson();
      final fromJson = EcgAnalysisResult.fromJson(json);
      expect(fromJson.classification, 'Abnormal');
      expect(fromJson.confidence, 0.2);
      expect(fromJson.recommendations, contains('Consult a doctor'));
      expect(fromJson.modelVersion, 'mock-1.0');
    });
  });
}
