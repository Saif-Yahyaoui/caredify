import 'package:caredify/features/auth/widgets/auth_section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthSectionTitle Widget Tests', () {
    testWidgets('renders icon and title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AuthSectionTitle(icon: Icons.lock, title: 'Section Title'),
        ),
      );
      expect(find.text('Section Title'), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });
  });
}
