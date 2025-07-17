import 'package:caredify/shared/widgets/banners/watch_connection_banner.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('WatchConnectionBanner Widget Tests', () {
    testWidgets('renders watch connection banner', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(
          WatchConnectionBanner(isConnected: false, onConnect: () {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(WatchConnectionBanner), findsOneWidget);
    });
  });
}
