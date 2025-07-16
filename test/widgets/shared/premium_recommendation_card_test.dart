import 'package:caredify/shared/widgets/premium_recommendation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PremiumRecommendationCard', () {
    testWidgets('renders with given title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PremiumRecommendationCard(
            title: 'Upgrade to Premium',
            description: 'Get advanced analytics and more.',
            icon: Icons.star,
            priority: 'High',
            priorityColor: Colors.amber,
          ),
        ),
      );
      expect(find.text('Upgrade to Premium'), findsOneWidget);
      expect(find.byType(PremiumRecommendationCard), findsOneWidget);
    });
  });
}
