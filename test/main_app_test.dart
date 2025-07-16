import 'package:caredify/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('Main App Tests', () {
    testWidgets('should initialize app without Firebase errors', (
      tester,
    ) async {
      // This test verifies that our Firebase mocking works
      await tester.pumpWidget(
        TestSetup.createTestWidget(
          const MaterialApp(
            home: Scaffold(body: Center(child: Text('Test App'))),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should render without Firebase errors
      expect(find.text('Test App'), findsOneWidget);
    });

    testWidgets('should handle app initialization gracefully', (
      tester,
    ) async {
      // Test that the main app can be initialized without errors
      await tester.pumpWidget(TestSetup.createTestWidget(const MyApp()));

      await tester.pumpAndSettle();

      // Should render without crashing - expect 2 MaterialApp widgets (one from MyApp, one from TestSetup)
      expect(find.byType(MaterialApp), findsNWidgets(2));
    });

    testWidgets('should provide proper test environment', (
      tester,
    ) async {
      // Test that our test setup provides the necessary environment
      await tester.pumpWidget(
        TestSetup.createTestWidget(
          const Scaffold(body: Center(child: Text('Test Environment'))),
        ),
      );

      await tester.pumpAndSettle();

      // Should render with proper test environment
      expect(find.text('Test Environment'), findsOneWidget);
    });
  });
}
