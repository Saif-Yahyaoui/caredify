import 'package:caredify/features/auth/widgets/auth_social_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthSocialButton Widget Tests', () {
    testWidgets('renders label and icon, and responds to tap', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: AuthSocialButton(
            iconPath: 'assets/icons/google.svg',
            label: 'Google',
            backgroundColor: Colors.white,
            textColor: Colors.black,
            borderColor: Colors.grey,
            onPressed: () => tapped = true,
          ),
        ),
      );
      expect(find.text('Google'), findsOneWidget);
      expect(find.byType(AuthSocialButton), findsOneWidget);
      // The SVG asset won't render in test, but the widget should still build
      await tester.tap(find.byType(InkWell));
      expect(tapped, isTrue);
    });

    testWidgets('disables tap when loading', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: AuthSocialButton(
            iconPath: 'assets/icons/google.svg',
            label: 'Google',
            backgroundColor: Colors.white,
            textColor: Colors.black,
            borderColor: Colors.grey,
            onPressed: () => tapped = true,
            isLoading: true,
          ),
        ),
      );
      await tester.tap(find.byType(InkWell));
      expect(tapped, isFalse);
    });
  });
}
