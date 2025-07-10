import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caredify/features/dashboard/sleep_rating_screen.dart';
import 'test_helpers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  testWidgets('SleepRatingScreen renders and shows sleep', (tester) async {
    await tester.pumpWidget(
      ProviderScope(child: localizedTestableWidget(const SleepRatingScreen())),
    );
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(SleepRatingScreen));
    final sleep = AppLocalizations.of(context)!.sleepRatingTitle;
    expect(find.textContaining(sleep, findRichText: true), findsWidgets);
  });
}
