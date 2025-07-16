import 'package:caredify/features/legal/screens/terms_of_service_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('TermsOfServiceScreen Widget Tests', () {
    testWidgets('renders terms of service screen', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(const TermsOfServiceScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.byType(TermsOfServiceScreen), findsOneWidget);
    });
  });
}
