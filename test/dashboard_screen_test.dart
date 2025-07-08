import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caredify/features/dashboard/dashboard_screen.dart';
import 'package:caredify/widgets/floating_bottom_nav_bar.dart';
import 'test_helpers.dart';

void main() {
  testWidgets('DashboardScreen renders and shows nav bar', (tester) async {
    await tester.pumpWidget(
      ProviderScope(child: localizedTestableWidget(const DashboardScreen())),
    );
    await tester.pumpAndSettle();
    expect(find.byType(FloatingBottomNavBar), findsOneWidget);
  });
}
