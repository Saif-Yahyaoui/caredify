import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:caredify/widgets/custom_text_field.dart';

void main() {
  testWidgets('CustomTextField renders and accepts input', (tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomTextField(label: 'Label', controller: controller),
        ),
      ),
    );
    await tester.enterText(find.byType(TextFormField), 'Hello');
    expect(controller.text, 'Hello');
  });
}
