import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:caredify/shared/widgets/premium_tabbar.dart';

void main() {
  group('PremiumTabBar', () {
    testWidgets('renders with given tabs', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PremiumTabBar(
              tabs: const [
                TabData('ECG', Icons.monitor_heart),
                TabData('SpO₂', Icons.bloodtype),
                TabData('BP', Icons.favorite),
              ],
              selectedIndex: 1, // Select 'SpO₂' tab
              onTabSelected: (_) {},
              isDark: false,
            ),
          ),
        ),
      );
      expect(find.text('SpO₂'), findsOneWidget);
      expect(find.text('ECG'), findsNothing);
      expect(find.text('BP'), findsNothing);
      expect(find.byType(PremiumTabBar), findsOneWidget);
    });
  });
}
