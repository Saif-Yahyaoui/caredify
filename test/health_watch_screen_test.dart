import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caredify/features/dashboard/health_watch_screen.dart';
import 'test_helpers.dart';

void main() {
  testWidgets('HealthWatchScreen renders and shows connect button', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(child: localizedTestableWidget(const HealthWatchScreen())),
    );
    expect(find.textContaining('connect', findRichText: true), findsWidgets);
  });
}
