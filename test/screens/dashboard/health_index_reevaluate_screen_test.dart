import 'package:caredify/shared/widgets/cards/health_index_reevaluate.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('HealthIndexReevaluateScreen Widget Tests', () {
    testWidgets('renders health index reevaluate screen', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(const HealthIndexReevaluateScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.byType(HealthIndexReevaluateScreen), findsOneWidget);
    });
  });
}
