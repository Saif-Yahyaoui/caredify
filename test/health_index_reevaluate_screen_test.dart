import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caredify/features/dashboard/health_index_reevaluate_screen.dart';
import 'test_helpers.dart';

void main() {
  testWidgets('HealthIndexReevaluateScreen renders', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: localizedTestableWidget(const HealthIndexReevaluateScreen()),
      ),
    );
    expect(find.textContaining('REEVALUATE'), findsWidgets);
  });
}
