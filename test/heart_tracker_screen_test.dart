import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caredify/features/dashboard/heart_tracker_screen.dart';
import 'test_helpers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  testWidgets('HeartTrackerScreen renders and shows BPM', (tester) async {
    await tester.pumpWidget(
      ProviderScope(child: localizedTestableWidget(const HeartTrackerScreen())),
    );
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(HeartTrackerScreen));
    final bpm = AppLocalizations.of(context)!.unitBpm;
    expect(find.textContaining(bpm, findRichText: true), findsWidgets);
  });
}
