import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caredify/features/dashboard/water_intake_screen.dart';
import 'test_helpers.dart';

void main() {
  testWidgets('WaterIntakeScreen renders and shows water', (tester) async {
    await tester.pumpWidget(
      ProviderScope(child: localizedTestableWidget(const WaterIntakeScreen())),
    );
    expect(find.textContaining('Water', findRichText: true), findsWidgets);
  });
}
