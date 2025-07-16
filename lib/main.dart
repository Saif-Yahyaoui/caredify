import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'router/router.dart';
import 'shared/providers/language_provider.dart';
import 'shared/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // If Firebase is already initialized, continue
    if (e.toString().contains('duplicate-app')) {
      log('Firebase already initialized, continuing...');
    } else {
      log('Firebase initialization error: $e');
    }
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final fontSize = ref.watch(fontSizeProvider);
    final language = ref.watch(languageProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'CAREDIFY',
      debugShowCheckedModeBanner: false,

      // Localization setup
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', 'FR'),
        Locale('en', 'US'),
        Locale('ar', 'TN'),
      ],
      locale: language,

      // Theme configuration
      theme: AppTheme.lightTheme(fontSize),
      darkTheme: AppTheme.darkTheme(fontSize),
      themeMode: themeMode,

      // Router configuration
      routerConfig: router,
    );
  }
}
