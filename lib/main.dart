import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';

void main() {
  runApp(const ProviderScope(child: CaredifyApp()));
}

class CaredifyApp extends ConsumerWidget {
  const CaredifyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final fontSize = ref.watch(fontSizeProvider);

    return MaterialApp.router(
      title: 'CAREDIFY',
      debugShowCheckedModeBanner: false,
      
      // Localization setup
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', 'FR'),
        Locale('en', 'US'),
        Locale('ar', 'TN'),
      ],
      locale: const Locale('fr', 'FR'),
      
      // Theme configuration
      theme: AppTheme.lightTheme(fontSize),
      darkTheme: AppTheme.darkTheme(fontSize),
      themeMode: themeMode,
      
      // Router configuration
      routerConfig: _router,
    );
  }
}

// Router configuration with named routes
final GoRouter _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
   /* GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),*/
    // Future routes for main app screens
    // GoRoute(
    //   path: '/dashboard',
    //   name: 'dashboard',
    //   builder: (context, state) => const DashboardScreen(),
    // ),
  ],
);