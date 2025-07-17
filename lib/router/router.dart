import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/auth/screens/forgot_password_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/onboarding_screen.dart';
import '../features/auth/screens/register_screen.dart';
// Import screens
import '../features/auth/screens/splash_screen.dart';
import '../features/auth/screens/welcome_screen.dart';
import '../features/chat/screens/chat.dart';
import '../features/dashboard/screens/advanced_analytics_screen.dart';
import '../features/dashboard/screens/advanced_coach_ai_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/dashboard/screens/data_export_screen.dart';
import '../features/dashboard/screens/ecg_alerts_screen.dart';
import '../features/dashboard/screens/ecg_analysis_screen.dart';
import '../features/dashboard/screens/health_score_screen.dart';
import '../features/health_tracking/screens/blood_pressure_graph_screen.dart';
import '../features/health_tracking/screens/heart_tracker_screen.dart';
import '../features/health_tracking/screens/sleep_rating_screen.dart';
import '../features/health_tracking/screens/spo2_graph_screen.dart';
import '../features/health_tracking/screens/water_intake_screen.dart';
import '../features/health_tracking/screens/workout_tracker_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/legal/screens/privacy_policy_screen.dart';
import '../features/legal/screens/terms_of_service_screen.dart';
import '../features/profile/screens/about_app_screen.dart';
import '../features/profile/screens/accessibility_settings_screen.dart';
import '../features/profile/screens/account_settings_screen.dart';
import '../features/profile/screens/app_settings_screen.dart';
import '../features/profile/screens/contact_support_screen.dart';
import '../features/profile/screens/device_settings_screen.dart';
import '../features/profile/screens/help_faq_screen.dart';
import '../features/profile/screens/messages_screen.dart';
import '../features/profile/screens/notifications_screen.dart';
import '../features/profile/screens/ota_upgrade_screen.dart';
import '../features/profile/screens/personal_info_screen.dart';
import '../features/profile/screens/privacy_settings_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/profile/screens/remote_shutter_screen.dart';
import '../features/profile/screens/reset_device_screen.dart';
import '../features/profile/screens/security_settings_screen.dart';
import '../features/profile/screens/support_screen.dart';
import '../features/profile/screens/upgrade_screen.dart';
import '../features/watch/screens/health_watch_screen.dart';
import '../shared/providers/auth_provider.dart';
import '../shared/services/auth_service.dart';
import '../shared/widgets/cards/health_index.dart';
import '../shared/widgets/cards/health_index_reevaluate.dart';
import '../shared/widgets/cards/healthy_habits.dart';
import '../shared/widgets/misc/main_screen.dart';
// Add other screens as needed

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      // Get authentication state
      final authState = ref.read(authStateProvider);

      // If still loading, don't redirect
      if (authState.isLoading) {
        debugPrint('Router: Still loading auth state, not redirecting');
        return null;
      }

      final location = state.uri.toString();
      debugPrint('Router: Current location: $location');

      // Check onboarding completion
      final prefs = await SharedPreferences.getInstance();
      final onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
      debugPrint('Router: Onboarding complete: $onboardingComplete');
      debugPrint('Router: User logged in: ${authState.isLoggedIn}');
      debugPrint('Router: User type: ${authState.userType}');

      // Special handling for splash screen
      if (location == '/splash') {
        debugPrint('Router: On splash screen, allowing access');
        return null;
      }

      // Special handling for onboarding screen
      if (location == '/onboarding') {
        debugPrint('Router: Checking onboarding screen access...');
        if (onboardingComplete) {
          debugPrint(
            'Router: Onboarding already complete, redirecting to welcome',
          );
          return '/welcome';
        }
        debugPrint('Router: Onboarding not complete, allowing access');
        return null;
      }

      debugPrint('Router: Not on onboarding screen, checking other routes...');

      // Public routes that don't require authentication
      final publicRoutes = [
        '/welcome',
        '/login',
        '/register',
        '/forgot-password',
        '/terms',
        '/privacy',
        '/upgrade',
      ];

      // If accessing a public route, allow it
      if (publicRoutes.contains(location)) {
        debugPrint('Router: Public route, allowing access');
        return null;
      }

      // If user is logged in, allow access to main routes
      if (authState.isLoggedIn) {
        debugPrint('Router: User is logged in, allowing access to main routes');

        // Role-based access control for dashboard routes
        if (location.startsWith('/main/dashboard')) {
          debugPrint('Router: Checking dashboard access...');
          if (authState.userType != UserType.premium) {
            debugPrint('Router: User is not premium, redirecting to home');
            return '/main/home';
          }
          debugPrint(
            'Router: Premium user accessing dashboard, allowing access',
          );
        }

        return null; // Allow access to all main routes for logged-in users
      }

      // If onboarding is not complete, redirect to onboarding
      if (!onboardingComplete) {
        debugPrint(
          'Router: User not logged in and onboarding not complete, redirecting to onboarding',
        );
        return '/onboarding';
      }

      // If onboarding is complete but not logged in, redirect to welcome
      debugPrint(
        'Router: User not logged in but onboarding complete, redirecting to welcome',
      );
      return '/welcome';
    },
    errorBuilder:
        (context, state) =>
            const Scaffold(body: Center(child: Text('404 - Page Not Found'))),
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/terms',
        builder: (context, state) => const TermsOfServiceScreen(),
      ),
      GoRoute(
        path: '/privacy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: '/upgrade',
        builder: (context, state) => const UpgradeScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainScreen(child: child),
        routes: [
          GoRoute(
            path: '/main/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/main/habits',
            builder: (context, state) => const HealthyHabitsScreen(),
          ),
          GoRoute(
            path: '/main/health-index',
            builder: (context, state) => const HealthIndexScreen(),
            routes: [
              GoRoute(
                path: 'reevaluate',
                builder:
                    (context, state) => const HealthIndexReevaluateScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/main/heart',
            builder: (context, state) => const HeartTrackerScreen(),
          ),
          GoRoute(
            path: '/main/water',
            builder: (context, state) => const WaterIntakeScreen(),
          ),
          GoRoute(
            path: '/main/sleep',
            builder: (context, state) => const SleepRatingScreen(),
          ),
          GoRoute(
            path: '/main/workout',
            builder: (context, state) => const WorkoutTrackerScreen(),
          ),

          GoRoute(
            path: '/main/dashboard',
            builder: (context, state) => const DashboardScreen(),
            routes: [
              GoRoute(
                path: 'data-export',
                builder: (context, state) => const DataExportScreen(),
              ),
              GoRoute(
                path: 'advanced-coach-ai',
                builder: (context, state) => const AdvancedCoachAiScreen(),
              ),
              GoRoute(
                path: 'health-score',
                builder: (context, state) => const HealthScoreScreen(),
              ),
              GoRoute(
                path: 'advanced-analytics',
                builder: (context, state) => const AdvancedAnalyticsScreen(),
              ),

              GoRoute(
                path: 'spo2-graph',
                builder: (context, state) => const SpO2GraphScreen(),
              ),
              GoRoute(
                path: 'bp-graph',
                builder: (context, state) => const BloodPressureGraphScreen(),
              ),
              GoRoute(
                path: 'ecg-analysis',
                builder: (context, state) => const EcgAnalysisScreen(),
              ),
              GoRoute(
                path: 'ai-alerts',
                builder: (context, state) => const EcgAlertsScreen(),
              ),
              GoRoute(
                path: 'analysis-history',
                builder:
                    (context, state) => const EcgAnalysisScreen(initialTab: 1),
              ),
            ],
          ),
          GoRoute(
            path: '/main/watch',
            builder: (context, state) => const HealthWatchScreen(),
          ),
          GoRoute(
            path: '/main/chat',
            builder: (context, state) => const ChatScreen(),
          ),
          GoRoute(
            path: '/main/profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'accessibility-settings',
                builder:
                    (context, state) => const AccessibilitySettingsScreen(),
              ),
              GoRoute(
                path: 'account-settings',
                builder: (context, state) => const AccountSettingsScreen(),
                routes: [
                  GoRoute(
                    path: 'personal-info',
                    builder: (context, state) => const PersonalInfoScreen(),
                  ),
                  GoRoute(
                    path: 'security',
                    builder: (context, state) => const SecuritySettingsScreen(),
                  ),
                  GoRoute(
                    path: 'privacy',
                    builder: (context, state) => const PrivacySettingsScreen(),
                  ),
                ],
              ),
              GoRoute(
                path: 'app-settings',
                builder: (context, state) => const AppSettingsScreen(),
                routes: [
                  GoRoute(
                    path: 'notifications',
                    builder: (context, state) => const NotificationsScreen(),
                  ),
                  GoRoute(
                    path: 'messages',
                    builder: (context, state) => const MessagesScreen(),
                  ),
                ],
              ),
              GoRoute(
                path: 'device-settings',
                builder: (context, state) => const DeviceSettingsScreen(),
                routes: [
                  GoRoute(
                    path: 'reset',
                    builder: (context, state) => const ResetDeviceScreen(),
                  ),
                  GoRoute(
                    path: 'remote-shutter',
                    builder: (context, state) => const RemoteShutterScreen(),
                  ),
                  GoRoute(
                    path: 'ota-upgrade',
                    builder: (context, state) => const OTAUpgradeScreen(),
                  ),
                ],
              ),
              GoRoute(
                path: 'support',
                builder: (context, state) => const SupportScreen(),
                routes: [
                  GoRoute(
                    path: 'help-faq',
                    builder: (context, state) => const HelpFAQScreen(),
                  ),
                  GoRoute(
                    path: 'contact',
                    builder: (context, state) => const ContactSupportScreen(),
                  ),
                  GoRoute(
                    path: 'about',
                    builder: (context, state) => const AboutAppScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
