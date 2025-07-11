import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'core/theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'providers/language_provider.dart';
import 'features/auth/splash_screen.dart';
import 'features/auth/welcome_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/auth/forgot_password_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/legal/privacy_policy_screen.dart';
import 'features/legal/terms_of_service_screen.dart';
import 'features/dashboard/workout_tracker_screen.dart';
import 'features/dashboard/sleep_rating_screen.dart';
import 'features/dashboard/water_intake_screen.dart';
import 'features/dashboard/heart_tracker_screen.dart';
import 'features/auth/onboarding_screen.dart';
import 'features/profile/accessibility_settings_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'features/dashboard/healthy_habits_screen.dart';
import 'features/dashboard/health_index_screen.dart';
import 'features/dashboard/health_index_reevaluate_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ProviderScope(child: CaredifyApp()));
}

class CaredifyApp extends ConsumerWidget {
  const CaredifyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final fontSize = ref.watch(fontSizeProvider);
    final language = ref.watch(languageProvider);

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
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/welcome',
      name: 'welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      name: 'forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/terms',
      name: 'terms',
      builder: (context, state) => const TermsOfServiceScreen(),
    ),
    GoRoute(
      path: '/privacy',
      name: 'privacy',
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),
    GoRoute(
      path: '/workout',
      name: 'workout',
      builder: (context, state) => const WorkoutTrackerScreen(),
    ),
    GoRoute(
      path: '/sleep',
      name: 'sleep',
      builder: (context, state) => const SleepRatingScreen(),
    ),
    GoRoute(
      path: '/water',
      name: 'water',
      builder: (context, state) => const WaterIntakeScreen(),
    ),
    GoRoute(
      path: '/heart',
      name: 'heart',
      builder: (context, state) => const HeartTrackerScreen(),
    ),
    GoRoute(
      path: '/accessibility-settings',
      name: 'accessibility-settings',
      builder: (context, state) => const AccessibilitySettingsScreen(),
    ),

    GoRoute(
      path: '/habits',
      name: 'habits',
      builder: (context, state) => const HealthyHabitsScreen(),
    ),
    GoRoute(
      path: '/health-index',
      name: 'health-index',
      builder: (context, state) => const HealthIndexScreen(),
    ),
    GoRoute(
      path: '/health-index-reevaluate',
      name: 'health-index-reevaluate',
      builder: (context, state) => const HealthIndexReevaluateScreen(),
    ),
  ],
);
