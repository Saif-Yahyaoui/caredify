import 'package:caredify/features/auth/widgets/auth_logo_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthLogoHeader Widget Tests', () {
    testWidgets('renders logo image in light mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: AuthLogoHeader(isDark: false),
        ),
      );
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('renders logo image in dark mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: AuthLogoHeader(isDark: true),
        ),
      );
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('renders title and subtitle', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AuthLogoHeader(
            isDark: false,
            title: 'Test Title',
            subtitle: 'Test Subtitle',
          ),
        ),
      );
      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Subtitle'), findsOneWidget);
    });
  });
}
