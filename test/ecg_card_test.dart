import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:caredify/features/dashboard/ecg_card.dart';
import 'test_helpers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  testWidgets('ECGCard renders and see more button exists', (tester) async {
    await tester.pumpWidget(localizedTestableWidget(const ECGCard()));
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(ECGCard));
    final seeMore = AppLocalizations.of(context)!.seeMore;
    expect(find.textContaining('ECG', findRichText: true), findsWidgets);
    expect(find.text(seeMore), findsOneWidget);
    expect(find.byType(TextButton), findsOneWidget);
  });
}
