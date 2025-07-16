import 'package:caredify/features/profile/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('ProfileScreen Widget Tests', () {
    testWidgets('renders and shows options', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(const ProfileScreen()),
      );
      await tester.pumpAndSettle();

      // Check that the screen renders
      expect(find.byType(ProfileScreen), findsOneWidget);

      // Check for profile options by their text
      expect(find.text('Personal Information'), findsOneWidget);
      expect(find.text('Security Settings'), findsOneWidget);
      expect(find.text('Privacy Settings'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Message Push'), findsOneWidget);
      expect(find.text('Accessibility Controls'), findsOneWidget);
      expect(find.text('Reset Device'), findsOneWidget);
      expect(find.text('Remote Shutter'), findsOneWidget);
      expect(find.text('OTA Upgrade'), findsOneWidget);
      expect(find.text('Help & FAQ'), findsOneWidget);
      expect(find.text('Contact Support'), findsOneWidget);
      expect(find.text('About App'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });
  });
}
