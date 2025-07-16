import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import 'auth_provider.dart';

/// Provider for current user type
final userTypeProvider = Provider<UserType>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.userType;
});

/// Provider to check if user has premium access
final hasPremiumAccessProvider = Provider<bool>((ref) {
  final userType = ref.watch(userTypeProvider);
  return userType == UserType.premium;
});

/// Provider to check if user has basic access
final hasBasicAccessProvider = Provider<bool>((ref) {
  final userType = ref.watch(userTypeProvider);
  return userType == UserType.basic || userType == UserType.premium;
});

/// Provider to check if user is logged in
final isLoggedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.isLoggedIn;
});

/// Provider for user type display name
final userTypeDisplayNameProvider = Provider<String>((ref) {
  final userType = ref.watch(userTypeProvider);
  switch (userType) {
    case UserType.premium:
      return 'Premium';
    case UserType.basic:
      return 'Basic';
    case UserType.none:
      return 'Guest';
  }
});

/// Provider for user type color
final userTypeColorProvider = Provider<Map<String, dynamic>>((ref) {
  final userType = ref.watch(userTypeProvider);
  switch (userType) {
    case UserType.premium:
      return {
        'primary': const Color(0xFFFFD700), // Gold
        'background': const Color(0xFFFFF8E1), // Light gold background
        'text': const Color(0xFFB8860B), // Dark gold text
      };
    case UserType.basic:
      return {
        'primary': const Color(0xFF2196F3), // Blue
        'background': const Color(0xFFE3F2FD), // Light blue background
        'text': const Color(0xFF1976D2), // Dark blue text
      };
    case UserType.none:
      return {
        'primary': const Color(0xFF9E9E9E), // Grey
        'background': const Color(0xFFF5F5F5), // Light grey background
        'text': const Color(0xFF616161), // Dark grey text
      };
  }
});

/// Provider for user type features
final userTypeFeaturesProvider = Provider<Map<String, List<String>>>((ref) {
  final userType = ref.watch(userTypeProvider);

  switch (userType) {
    case UserType.premium:
      return {
        'available': [
          'Advanced ECG Analysis with AI insights',
          'Historical data and trend analysis',
          'AI-generated health alerts and recommendations',
          'Data export for medical consultations',
          'Premium dashboard with detailed metrics',
          'Comparison charts and analytics',
          'Health score and grading system',
          'Detailed health index calculations',
          'Trend analysis over time periods',
          'AI-powered health insights',
          'Advanced coach AI with personalized recommendations',
          'Priority support and notifications',
          'Detailed sleep analysis',
          'Advanced activity tracking',
          'Comprehensive health reports',
        ],
        'unavailable': [],
      };
    case UserType.basic:
      return {
        'available': [
          'Basic ECG readings (Normal/Abnormal)',
          'Simple vital signs display',
          'Basic activity tracking (steps, calories)',
          'Simple alerts and notifications',
          'Basic coach recommendations',
          'Emergency call functionality',
          'Basic health monitoring',
          'Simple sleep tracking',
          'Basic water intake tracking',
          'Simple medication reminders',
        ],
        'unavailable': [
          'Advanced ECG Analysis',
          'Historical data and trends',
          'AI-generated insights',
          'Data export functionality',
          'Premium dashboard',
          'Comparison charts',
          'Health score system',
          'Detailed analytics',
          'Advanced coach AI',
          'Priority support',
        ],
      };
    case UserType.none:
      return {
        'available': [],
        'unavailable': ['All Features'],
      };
  }
});

/// Provider for upgrade benefits with detailed descriptions
final upgradeBenefitsProvider = Provider<List<Map<String, String>>>((ref) {
  return [
    {
      'title': 'Advanced ECG Analysis',
      'description':
          'Get detailed ECG readings with AI-powered analysis and abnormality detection',
      'icon': 'favorite',
    },
    {
      'title': 'Historical Data & Trends',
      'description':
          'View your health data over time with detailed trend analysis',
      'icon': 'timeline',
    },
    {
      'title': 'AI Health Insights',
      'description':
          'Receive personalized health insights and recommendations from AI',
      'icon': 'psychology',
    },
    {
      'title': 'Data Export',
      'description':
          'Export your health data for medical consultations and personal records',
      'icon': 'download',
    },
    {
      'title': 'Premium Dashboard',
      'description':
          'Access comprehensive health metrics and advanced analytics',
      'icon': 'dashboard',
    },
    {
      'title': 'Health Score System',
      'description': 'Get a comprehensive health score with detailed breakdown',
      'icon': 'health_and_safety',
    },
    {
      'title': 'Advanced Coach AI',
      'description': 'Personalized coaching with advanced AI recommendations',
      'icon': 'support_agent',
    },
  ];
});

/// Provider for feature comparison
final featureComparisonProvider = Provider<Map<String, Map<String, dynamic>>>((
  ref,
) {
  return {
    'ECG Analysis': {
      'basic': 'Simple Normal/Abnormal display',
      'premium': 'Advanced AI analysis with detailed insights',
      'basic_icon': Icons.favorite,
      'premium_icon': Icons.psychology,
    },
    'Data History': {
      'basic': 'Current readings only',
      'premium': 'Historical data with trend analysis',
      'basic_icon': Icons.today,
      'premium_icon': Icons.history,
    },
    'Health Insights': {
      'basic': 'Basic recommendations',
      'premium': 'AI-powered personalized insights',
      'basic_icon': Icons.lightbulb_outline,
      'premium_icon': Icons.lightbulb,
    },
    'Data Export': {
      'basic': 'Not available',
      'premium': 'Full data export for medical use',
      'basic_icon': Icons.block,
      'premium_icon': Icons.download,
    },
    'Dashboard': {
      'basic': 'Simple home screen',
      'premium': 'Advanced analytics dashboard',
      'basic_icon': Icons.home,
      'premium_icon': Icons.dashboard,
    },
    'Health Score': {
      'basic': 'Not available',
      'premium': 'Comprehensive health scoring system',
      'basic_icon': Icons.block,
      'premium_icon': Icons.health_and_safety,
    },
  };
});
