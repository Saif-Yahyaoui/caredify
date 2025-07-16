import 'package:flutter_test/flutter_test.dart';
import 'package:caredify/shared/services/ecg_analysis_service.dart';
import 'package:caredify/shared/models/ecg_analysis_result.dart';

void main() {
  group('EcgAnalysisService', () {
    late EcgAnalysisService service;

    setUp(() {
      service = EcgAnalysisService();
    });

    test('should initialize without error', () async {
      await service.initialize();
      expect(service, isA<EcgAnalysisService>());
    });

    test('should return a valid EcgAnalysisResult for mock data', () async {
      final mockData = List.generate(1000, (i) => i * 0.01);
      final result = await service.analyzeEcgSignal(mockData);
      expect(result, isA<EcgAnalysisResult>());
      expect(result.classification, isNotEmpty);
      expect(result.confidence, inInclusiveRange(0.0, 1.0));
    });
  });
}
