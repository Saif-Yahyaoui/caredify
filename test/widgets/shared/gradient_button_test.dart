import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:caredify/shared/widgets/gradient_button.dart';

void main() {
  group('GradientButton', () {
    testWidgets('renders and responds to tap', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GradientButton(
              text: 'Continue',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );
      expect(find.text('Continue'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      expect(tapped, isTrue);
    });
  });
}
