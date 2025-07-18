import 'package:caredify/features/auth/widgets/auth_biometric_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthBiometricButton Widget Tests', () {
    testWidgets('renders label and icon in light mode', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: AuthBiometricButton(
            iconAsset: 'assets/icons/fingerprint.png',
            label: 'Fingerprint',
            onPressed: () => tapped = true,
            isDark: false,
          ),
        ),
      );
      expect(find.text('Fingerprint'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      await tester.tap(find.byType(InkWell));
      expect(tapped, isTrue);
    });

    testWidgets('renders label and icon in dark mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: AuthBiometricButton(
            iconAsset: 'assets/icons/fingerprint.png',
            label: 'Face ID',
            onPressed: () {},
            isDark: true,
          ),
        ),
      );
      expect(find.text('Face ID'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });
  });
}
