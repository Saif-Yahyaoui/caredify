import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caredify/features/auth/splash_screen.dart';
import 'test_helpers.dart';

void main() {
  testWidgets('SplashScreen renders logo and loading', (tester) async {
    await tester.pumpWidget(
      ProviderScope(child: localizedTestableWidget(const SplashScreen())),
    );
    await tester.pump(const Duration(seconds: 3));
    expect(find.byType(Image), findsWidgets);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
