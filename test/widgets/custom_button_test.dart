import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:caredify/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('CustomButton calls onPressed', (WidgetTester tester) async {
    bool pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: 'Test',
            onPressed: () {
              pressed = true;
            },
          ),
        ),
      ),
    );

    final buttonFinder = find.text('Test');
    await tester.ensureVisible(buttonFinder);
    await tester.tap(buttonFinder);
    await tester.pump();
    expect(pressed, isTrue);
  });
}
