import 'package:caredify/shared/widgets/cards/health_index.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('HealthIndexScreen Widget Tests', () {
    testWidgets('renders health index screen', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(const HealthIndexScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.byType(HealthIndexScreen), findsOneWidget);
    });
  });
}
