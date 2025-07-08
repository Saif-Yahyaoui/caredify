import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:caredify/features/auth/onboarding_screen.dart';
import 'test_helpers.dart';

void main() {
  testWidgets('OnboardingScreen renders and can swipe', (tester) async {
    await tester.pumpWidget(localizedTestableWidget(const OnboardingScreen()));
    await tester.pumpAndSettle();
    expect(find.byType(PageView), findsOneWidget);
    await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
    await tester.pumpAndSettle();
    expect(find.byType(PageView), findsOneWidget);
  });
}
