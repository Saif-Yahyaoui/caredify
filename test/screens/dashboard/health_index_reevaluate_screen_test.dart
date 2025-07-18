import 'package:caredify/shared/widgets/cards/health_index_reevaluate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

Widget testableWidget(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: const [Locale('en'), Locale('fr'), Locale('ar')],
      home: child,
    ),
  );
}

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('HealthIndexReevaluateScreen Widget Tests', () {
    testWidgets('renders health index reevaluate screen', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        testableWidget(const HealthIndexReevaluateScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HealthIndexReevaluateScreen), findsOneWidget);

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });
  });
}
