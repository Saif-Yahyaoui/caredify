import 'package:caredify/features/dashboard/screens/ecg_analysis_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget testableWidget(Widget child) {
  return ProviderScope(child: MaterialApp(home: child));
}

void main() {
  group('EcgAnalysisScreen Widget Tests', () {
    testWidgets('renders and displays all tabs', (tester) async {
      await tester.pumpWidget(testableWidget(const EcgAnalysisScreen()));
      await tester.pumpAndSettle();

      // Check Overview tab label
      expect(find.text('Overview'), findsOneWidget);
      // Switch to History tab
      await tester.tap(find.byIcon(Icons.history));
      await tester.pumpAndSettle();
      expect(find.text('History'), findsOneWidget);
      // Switch to Trends tab
      await tester.tap(find.byIcon(Icons.show_chart));
      await tester.pumpAndSettle();
      expect(find.text('Trends'), findsOneWidget);
    });

    testWidgets('switches between tabs and displays content', (tester) async {
      await tester.pumpWidget(testableWidget(const EcgAnalysisScreen()));
      await tester.pumpAndSettle();

      // Overview tab
      expect(find.text('Overview'), findsOneWidget);
      // Switch to History tab
      await tester.tap(find.byIcon(Icons.history));
      await tester.pumpAndSettle();
      expect(find.text('History'), findsOneWidget);
      // Switch to Trends tab
      await tester.tap(find.byIcon(Icons.show_chart));
      await tester.pumpAndSettle();
      expect(find.text('Trends'), findsOneWidget);
    });
  });
}
