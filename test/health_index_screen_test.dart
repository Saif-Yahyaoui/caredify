import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:caredify/features/dashboard/health_index_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'test_helpers.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('HealthIndexScreen renders main card', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());
    addTearDown(() => tester.view.resetDevicePixelRatio());

    await tester.pumpWidget(
      ProviderScope(
        child: localizedTestableWidget(
          const Scaffold(body: HealthIndexScreen()),
        ),
      ),
    );

    expect(find.byType(HealthIndexScreen), findsOneWidget);
  });
}
