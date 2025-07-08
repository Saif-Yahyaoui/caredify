import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caredify/features/dashboard/healthy_habits_screen.dart';
import 'test_helpers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  testWidgets('HealthyHabitsScreen renders and shows habits', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: localizedTestableWidget(const HealthyHabitsScreen()),
      ),
    );
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(HealthyHabitsScreen));
    final habits = AppLocalizations.of(context)!.healthyHabitsTitle;
    expect(find.textContaining(habits, findRichText: true), findsWidgets);
  });
}
