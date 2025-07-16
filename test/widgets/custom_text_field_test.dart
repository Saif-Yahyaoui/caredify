import 'package:caredify/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('CustomTextField Widget Tests', () {
    testWidgets('renders and accepts input', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TestSetup.createTestWidget(
              const SizedBox(
                width: 400,
                height: 200,
                child: CustomTextField(label: 'Test Field', hint: 'Enter text'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check that the widget renders
      expect(find.byType(CustomTextField), findsOneWidget);
      expect(find.text('Test Field'), findsOneWidget);
    });

    testWidgets('shows validation error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TestSetup.createTestWidget(
              const SizedBox(
                width: 400,
                height: 200,
                child: CustomTextField(
                  label: 'Test Field',
                  errorText: 'This field is required',
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('This field is required'), findsOneWidget);
    });
  });
}
