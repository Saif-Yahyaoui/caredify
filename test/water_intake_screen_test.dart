import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caredify/features/dashboard/water_intake_screen.dart';
import 'test_helpers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  testWidgets('WaterIntakeScreen renders and shows water', (tester) async {
    await tester.pumpWidget(
      ProviderScope(child: localizedTestableWidget(const WaterIntakeScreen())),
    );
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(WaterIntakeScreen));
    final water = AppLocalizations.of(context)!.waterIntakeTitle;
    expect(find.textContaining(water, findRichText: true), findsWidgets);
  });
}
