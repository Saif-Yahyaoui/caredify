import 'package:caredify/features/auth/widgets/auth_onboarding_card.dart';
import 'package:caredify/shared/models/auth_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthOnboardingCard Widget Tests', () {
    testWidgets('renders with image asset', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AuthOnboardingCard(
            data: const OnboardingCardData(
              imageAsset: 'assets/images/logo.png',
              title: 'Welcome',
              subtitle: 'Your health space',
            ),
          ),
        ),
      );
      expect(find.text('Welcome'), findsOneWidget);
      expect(find.text('Your health space'), findsOneWidget);
      expect(
        find.byType(Image),
        findsOneWidget,
      ); // AuthLogoHeader renders an image
      expect(find.byType(AuthOnboardingCard), findsOneWidget);
    });

    testWidgets('renders with icon and features', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AuthOnboardingCard(
            data: const OnboardingCardData(
              icon: Icons.star,
              iconColor: Colors.amber,
              title: 'Features',
              subtitle: 'Subtitle',
              features: ['Feature 1', 'Feature 2'],
              featuresTitle: 'Features List',
            ),
          ),
        ),
      );
      expect(find.text('Features'), findsOneWidget);
      expect(find.text('Subtitle'), findsOneWidget);
      expect(find.text('Features List'), findsOneWidget);
      expect(find.text('Feature 1'), findsOneWidget);
      expect(find.text('Feature 2'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('renders with bottom text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AuthOnboardingCard(
            data: const OnboardingCardData(
              title: 'Bottom',
              subtitle: 'Subtitle',
              bottomText: 'Bottom text',
            ),
          ),
        ),
      );
      expect(find.text('Bottom'), findsOneWidget);
      expect(find.text('Subtitle'), findsOneWidget);
      expect(find.text('Bottom text'), findsOneWidget);
    });
  });
}
