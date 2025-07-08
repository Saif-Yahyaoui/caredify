import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:caredify/features/dashboard/ecg_card.dart';
import 'test_helpers.dart';

void main() {
  testWidgets('ECGCard renders and see more button exists', (tester) async {
    await tester.pumpWidget(localizedTestableWidget(const ECGCard()));
    expect(find.textContaining('ECG'), findsOneWidget);
    expect(find.byType(TextButton), findsOneWidget);
  });
}
