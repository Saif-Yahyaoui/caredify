import 'package:caredify/features/legal/screens/privacy_policy_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('PrivacyPolicyScreen Widget Tests', () {
    testWidgets('renders privacy policy screen', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(const PrivacyPolicyScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.byType(PrivacyPolicyScreen), findsOneWidget);
    });
  });
}
