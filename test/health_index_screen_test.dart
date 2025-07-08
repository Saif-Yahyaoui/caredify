import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caredify/features/dashboard/health_index_screen.dart';
import 'test_helpers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  testWidgets('HealthIndexScreen renders main card', (tester) async {
    await tester.pumpWidget(
      ProviderScope(child: localizedTestableWidget(const HealthIndexScreen())),
    );
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(HealthIndexScreen));
    final healthIndex = AppLocalizations.of(context)!.myHealthIndex;
    expect(find.textContaining(healthIndex, findRichText: true), findsWidgets);
  });
}
