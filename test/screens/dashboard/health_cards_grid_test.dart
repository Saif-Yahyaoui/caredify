import 'package:caredify/features/dashboard/widgets/health_cards_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../test_helpers.dart';

// Mock SvgPicture widget for testing
class MockSvgPicture extends StatelessWidget {
  final String assetName;
  final double? width;
  final double? height;
  final ColorFilter? colorFilter;

  const MockSvgPicture({
    super.key,
    required this.assetName,
    this.width,
    this.height,
    this.colorFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      width: width,
      height: height,
      color: Colors.grey, // Use a simple grey color for mock
    );
  }
}

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('HealthCardsGrid Widget Tests', () {
    Widget createResponsiveTestWidget(Widget child) {
      return localizedTestableWidget(
        Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              width: 400,
              // Remove height constraint to prevent overflow
              child: child,
            ),
          ),
        ),
      );
    }

    testWidgets('renders all cards', (tester) async {
      await tester.pumpWidget(
        createResponsiveTestWidget(
          const HealthCardsGrid(
            heartRate: 70,
            heartRateMax: 100,
            waterIntake: 1000,
            waterGoal: 1500,
            sleepHours: 7,
            sleepGoal: 9,
            workoutMinutes: 30,
            workoutGoal: 60,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check that the widget renders without crashing
      expect(find.byType(HealthCardsGrid), findsOneWidget);

      // Check for basic structure
      expect(find.byType(Column), findsAtLeast(1));
      expect(find.byType(Card), findsAtLeast(4)); // Should have multiple cards
    });

    testWidgets('displays health metrics with correct values', (tester) async {
      await tester.pumpWidget(
        createResponsiveTestWidget(
          const HealthCardsGrid(
            heartRate: 72,
            heartRateMax: 100,
            waterIntake: 1200,
            waterGoal: 1500,
            sleepHours: 8.5,
            sleepGoal: 9,
            workoutMinutes: 45,
            workoutGoal: 60,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check for health cards
      expect(find.byType(HealthCardsGrid), findsOneWidget);

      // Check for the actual values that should be displayed
      // Use more flexible text finding since the widget might format text differently
      expect(find.textContaining('72'), findsAtLeast(1)); // Heart rate value
      expect(
        find.textContaining('1200'),
        findsAtLeast(1),
      ); // Water intake value
      expect(find.textContaining('8.5'), findsAtLeast(1)); // Sleep hours value
      expect(
        find.textContaining('45'),
        findsAtLeast(1),
      ); // Workout minutes value
    });

    testWidgets('has proper layout structure', (tester) async {
      await tester.pumpWidget(
        createResponsiveTestWidget(
          const HealthCardsGrid(
            heartRate: 70,
            heartRateMax: 100,
            waterIntake: 1000,
            waterGoal: 1500,
            sleepHours: 7,
            sleepGoal: 9,
            workoutMinutes: 30,
            workoutGoal: 60,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check for basic layout elements
      expect(find.byType(HealthCardsGrid), findsOneWidget);
      expect(find.byType(Column), findsAtLeast(1));
      expect(find.byType(Card), findsAtLeast(4));
      expect(
        find.byType(Row),
        findsAtLeast(2),
      ); // Should have rows for card layout
    });

    testWidgets('handles tap callbacks', (tester) async {
      bool heartTapped = false;
      bool waterTapped = false;

      await tester.pumpWidget(
        createResponsiveTestWidget(
          HealthCardsGrid(
            heartRate: 70,
            heartRateMax: 100,
            waterIntake: 1000,
            waterGoal: 1500,
            sleepHours: 7,
            sleepGoal: 9,
            workoutMinutes: 30,
            workoutGoal: 60,
            onHeartTap: () => heartTapped = true,
            onWaterTap: () => waterTapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap the heart card (first card)
      final heartCard = find.byType(Card).first;
      await tester.tap(heartCard);
      expect(heartTapped, isTrue);

      // Reset and test water card
      heartTapped = false;
      waterTapped = false;

      // Find and tap the water card (second card)
      final waterCard = find.byType(Card).at(1);
      await tester.tap(waterCard);
      expect(waterTapped, isTrue);
    });

    testWidgets('displays progress indicators', (tester) async {
      await tester.pumpWidget(
        createResponsiveTestWidget(
          const HealthCardsGrid(
            heartRate: 70,
            heartRateMax: 100,
            waterIntake: 1000,
            waterGoal: 1500,
            sleepHours: 7,
            sleepGoal: 9,
            workoutMinutes: 30,
            workoutGoal: 60,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check for progress indicators
      expect(find.byType(LinearProgressIndicator), findsAtLeast(1));
    });

    testWidgets('renders without layout overflow', (tester) async {
      await tester.pumpWidget(
        createResponsiveTestWidget(
          const HealthCardsGrid(
            heartRate: 70,
            heartRateMax: 100,
            waterIntake: 1000,
            waterGoal: 1500,
            sleepHours: 7,
            sleepGoal: 9,
            workoutMinutes: 30,
            workoutGoal: 60,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify no overflow exceptions
      expect(tester.takeException(), isNull);
    });
  });
}
