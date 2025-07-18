import 'package:caredify/features/auth/widgets/auth_social_button_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class TestLocalizations {
  static AppLocalizations get(BuildContext context) =>
      AppLocalizations.of(context)!;
}

Widget withLocalizations(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      DefaultWidgetsLocalizations.delegate,
      DefaultMaterialLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en', '')],
    home: child,
  );
}

void main() {
  group('AuthSocialButtonRow Widget Tests', () {
    testWidgets(
      'renders both Google and Facebook buttons and responds to tap',
      (tester) async {
        bool googleTapped = false;
        bool facebookTapped = false;
        await tester.pumpWidget(
          withLocalizations(
            AuthSocialButtonRow(
              isLoading: false,
              onGooglePressed: () => googleTapped = true,
              onFacebookPressed: () => facebookTapped = true,
            ),
          ),
        );
        expect(find.text('Google'), findsOneWidget);
        expect(find.text('Facebook'), findsOneWidget);
        await tester.tap(find.text('Google'));
        await tester.tap(find.text('Facebook'));
        expect(googleTapped, isTrue);
        expect(facebookTapped, isTrue);
      },
    );

    testWidgets('disables tap when loading', (tester) async {
      bool googleTapped = false;
      bool facebookTapped = false;
      await tester.pumpWidget(
        withLocalizations(
          AuthSocialButtonRow(
            isLoading: true,
            onGooglePressed: () => googleTapped = true,
            onFacebookPressed: () => facebookTapped = true,
          ),
        ),
      );
      await tester.tap(find.text('Google'));
      await tester.tap(find.text('Facebook'));
      expect(googleTapped, isFalse);
      expect(facebookTapped, isFalse);
    });
  });
}
