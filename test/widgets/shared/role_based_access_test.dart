import 'package:caredify/shared/services/auth_service.dart';
import 'package:caredify/shared/widgets/role_based_access.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('RoleBasedAccess Widget Tests', () {
    testWidgets('renders role based access', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(
          const RoleBasedAccess(
            allowedUserTypes: [UserType.premium],
            child: Text('Premium Content'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check that the widget renders
      expect(find.byType(RoleBasedAccess), findsOneWidget);
    });
  });
}
