import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:caredify/widgets/custom_button.dart';

void main() {
  testWidgets('CustomButton calls onPressed', (tester) async {
    bool pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: CustomButton.primary(
          text: 'Test',
          onPressed: () => pressed = true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Test'));
    await tester.pumpAndSettle();
    expect(pressed, true);
  });
}
