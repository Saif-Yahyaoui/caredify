import 'package:caredify/shared/services/auth_service.dart';
import 'package:caredify/shared/widgets/navigation/floating_bottom_nav_bar.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('FloatingBottomNavBar Widget Tests', () {
    testWidgets('renders floating bottom nav bar', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(
          FloatingBottomNavBar(
            selectedIndex: 0,
            onTabSelected: (index) {},
            userType: UserType.basic,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(FloatingBottomNavBar), findsOneWidget);
    });
  });
}
