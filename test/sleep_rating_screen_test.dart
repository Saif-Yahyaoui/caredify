import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caredify/features/dashboard/sleep_rating_screen.dart';
import 'test_helpers.dart';

void main() {
  testWidgets('SleepRatingScreen renders and shows sleep', (tester) async {
    await tester.pumpWidget(
      ProviderScope(child: localizedTestableWidget(const SleepRatingScreen())),
    );
    expect(find.textContaining('Sleep', findRichText: true), findsWidgets);
  });
}
