import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:caredify/shared/widgets/ecg_ai_analysis_card.dart';
import 'package:caredify/shared/models/ecg_analysis_result.dart';

void main() {
  group('EcgAiAnalysisCard', () {
    testWidgets('renders with classification label', (tester) async {
      final result = EcgAnalysisResult(
        classification: 'Normal',
        confidence: 0.92,
        recommendations: ['Keep up the good work!'],
        timestamp: DateTime.now(),
        modelVersion: 'mock-1.0',
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EcgAiAnalysisCard(result: result, showAnalyzeButton: false),
          ),
        ),
      );
      expect(find.byType(EcgAiAnalysisCard), findsOneWidget);
      expect(find.text('Normal'), findsAtLeastNWidgets(1));
    });
  });
}
