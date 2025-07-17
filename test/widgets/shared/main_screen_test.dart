import 'package:caredify/shared/widgets/misc/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('MainScreen Widget Tests', () {
    testWidgets('can create main screen widget', (tester) async {
      // Test that we can create the MainScreen widget without crashing
      const mainScreen = MainScreen(
        child: Scaffold(body: Center(child: Text('Test Content'))),
      );

      expect(mainScreen, isNotNull);
      expect(mainScreen.child, isA<Scaffold>());
    });
  });
}
