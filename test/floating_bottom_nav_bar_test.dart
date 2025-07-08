import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:caredify/widgets/floating_bottom_nav_bar.dart';

void main() {
  testWidgets('FloatingBottomNavBar renders and responds to taps', (
    WidgetTester tester,
  ) async {
    int selectedIndex = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: FloatingBottomNavBar(
            selectedIndex: selectedIndex,
            onTabSelected: (index) {
              selectedIndex = index;
            },
          ),
        ),
      ),
    );

    // Check that all tab icons are present
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.watch), findsOneWidget);
    expect(find.byIcon(Icons.chat_bubble_outline), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
    expect(find.byIcon(Icons.person_outline), findsOneWidget);

    // Tap the "Profile" tab (last one)
    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();

    // The callback should have updated selectedIndex
    expect(selectedIndex, 4);
  });
}
