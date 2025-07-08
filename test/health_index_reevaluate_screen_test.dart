import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caredify/features/dashboard/health_index_reevaluate_screen.dart';
import 'test_helpers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  testWidgets('HealthIndexReevaluateScreen renders', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: localizedTestableWidget(const HealthIndexReevaluateScreen()),
      ),
    );
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(HealthIndexReevaluateScreen));
    final reevaluate = AppLocalizations.of(context)!.reevaluate;
    expect(find.text(reevaluate), findsWidgets);
  });
}
