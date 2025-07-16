import 'package:caredify/features/auth/screens/forgot_password_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('ForgotPasswordScreen Widget Tests', () {
    testWidgets('renders forgot password screen', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(const ForgotPasswordScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ForgotPasswordScreen), findsOneWidget);
    });
  });
}
