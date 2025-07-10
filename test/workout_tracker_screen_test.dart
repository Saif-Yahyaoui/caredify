import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caredify/features/dashboard/workout_tracker_screen.dart';
import 'test_helpers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  testWidgets('WorkoutTrackerScreen renders and shows steps', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: localizedTestableWidget(const WorkoutTrackerScreen()),
      ),
    );
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(WorkoutTrackerScreen));
    final steps = AppLocalizations.of(context)!.workoutTrackerTitle;
    expect(find.textContaining(steps, findRichText: true), findsWidgets);
  });
}
