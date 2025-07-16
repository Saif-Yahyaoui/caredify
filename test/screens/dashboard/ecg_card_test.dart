import 'package:caredify/features/dashboard/widgets/ecg_card.dart';

import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('EcgCard Widget Tests', () {
    testWidgets('renders ECG card correctly', (tester) async {
      await tester.pumpWidget(TestSetup.createTestWidget(const ECGCard()));
      await tester.pumpAndSettle();
      expect(find.text('ECG'), findsOneWidget);
      expect(find.text('Average ECG Value: 00 BPM'), findsOneWidget);
    });
  });
}
