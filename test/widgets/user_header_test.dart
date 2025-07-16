import 'package:caredify/shared/widgets/user_header.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('UserHeader Widget Tests', () {
    testWidgets('renders user header', (tester) async {
      await tester.pumpWidget(TestSetup.createTestWidget(const UserHeader()));
      await tester.pumpAndSettle();
      expect(find.byType(UserHeader), findsOneWidget);
    });
  });
}
