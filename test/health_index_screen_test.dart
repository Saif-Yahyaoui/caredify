import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caredify/features/dashboard/health_index_screen.dart';
import 'test_helpers.dart';

void main() {
  testWidgets('HealthIndexScreen renders main card', (tester) async {
    await tester.pumpWidget(
      ProviderScope(child: localizedTestableWidget(const HealthIndexScreen())),
    );
    expect(find.textContaining('Health Index'), findsWidgets);
  });
}
