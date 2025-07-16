# Caredify Project Structure

## New Organized Structure

```
lib/
├── core/                           # Core app functionality
│   ├── constants/                  # App constants
│   │   ├── api_endpoints.dart
│   │   ├── app_constants.dart
│   │   └── error_messages.dart
│   ├── theme/                      # App theming
│   │   ├── app_colors.dart
│   │   └── app_theme.dart
│   ├── utils/                      # Utility functions
│   │   └── validators.dart
│   └── navigation/                 # Navigation helpers
│       ├── navigation_helpers.dart
│       └── route_names.dart
├── features/                       # Feature-based modules
│   ├── auth/                       # Authentication feature
│   │   ├── screens/
│   │   │   ├── splash_screen.dart
│   │   │   ├── onboarding_screen.dart
│   │   │   ├── welcome_screen.dart
│   │   │   ├── login_screen.dart
│   │   │   ├── register_screen.dart
│   │   │   └── forgot_password_screen.dart
│   │   └── widgets/
│   ├── dashboard/                  # Dashboard feature
│   │   ├── screens/
│   │   │   ├── dashboard_screen.dart
│   │   │   ├── health_index_screen.dart
│   │   │   ├── health_index_reevaluate_screen.dart
│   │   │   ├── enhanced_ecg_screen.dart
│   │   │   ├── data_export_screen.dart
│   │   │   ├── advanced_coach_ai_screen.dart
│   │   │   ├── health_score_screen.dart
│   │   │   ├── advanced_analytics_screen.dart
│   │   │   └── priority_support_screen.dart
│   │   └── widgets/
│   │       ├── health_cards_grid.dart
│   │       └── ecg_card.dart
│   ├── health_tracking/            # Health tracking feature
│   │   ├── screens/
│   │   │   ├── heart_tracker_screen.dart
│   │   │   ├── water_intake_screen.dart
│   │   │   ├── sleep_rating_screen.dart
│   │   │   ├── workout_tracker_screen.dart
│   │   │   ├── healthy_habits_screen.dart
│   │   │   ├── spo2_graph_screen.dart
│   │   │   └── blood_pressure_graph_screen.dart
│   │   └── widgets/
│   ├── home/                       # Home feature
│   │   └── screens/
│   │       └── home_screen.dart
│   ├── profile/                    # Profile feature
│   │   ├── screens/
│   │   │   ├── profile_screen.dart
│   │   │   ├── account_settings_screen.dart
│   │   │   ├── app_settings_screen.dart
│   │   │   ├── device_settings_screen.dart
│   │   │   ├── support_screen.dart
│   │   │   ├── personal_info_screen.dart
│   │   │   ├── security_settings_screen.dart
│   │   │   ├── privacy_settings_screen.dart
│   │   │   ├── notifications_screen.dart
│   │   │   ├── messages_screen.dart
│   │   │   ├── reset_device_screen.dart
│   │   │   ├── remote_shutter_screen.dart
│   │   │   ├── ota_upgrade_screen.dart
│   │   │   ├── help_faq_screen.dart
│   │   │   ├── contact_support_screen.dart
│   │   │   ├── about_app_screen.dart
│   │   │   ├── accessibility_settings_screen.dart
│   │   │   └── upgrade_screen.dart
│   │   └── widgets/
│   ├── chat/                       # Chat feature
│   │   └── screens/
│   │       └── chat.dart
│   ├── watch/                      # Watch feature
│   │   └── screens/
│   │       └── health_watch_screen.dart
│   └── legal/                      # Legal feature
│       └── screens/
│           ├── privacy_policy_screen.dart
│           └── terms_of_service_screen.dart
├── shared/                         # Shared components
│   ├── widgets/                    # Reusable widgets
│   │   ├── user_header.dart
│   │   ├── floating_bottom_nav_bar.dart
│   │   ├── accessibility_controls.dart
│   │   ├── custom_text_field.dart
│   │   ├── custom_button.dart
│   │   ├── activity_card.dart
│   │   ├── alert_card.dart
│   │   ├── circular_step_counter.dart
│   │   ├── coach_card.dart
│   │   ├── ecg_quick_access_card.dart
│   │   ├── emergency_button.dart
│   │   ├── main_screen.dart
│   │   ├── metrics_row.dart
│   │   ├── premium_components.dart
│   │   ├── role_based_access.dart
│   │   ├── unified_health_metrics.dart
│   │   ├── unified_vital_cards.dart
│   │   ├── vital_card.dart
│   │   ├── watch_connection_banner.dart
│   │   └── weekly_chart.dart
│   ├── models/                     # Shared models
│   │   ├── habit.dart
│   │   ├── health_metrics.dart
│   │   └── user_profile.dart
│   ├── services/                   # Shared services
│   │   ├── ai_chat_service.dart
│   │   └── auth_service.dart
│   └── providers/                  # Shared providers
│       ├── ai_chat_provider.dart
│       ├── auth_provider.dart
│       ├── habits_provider.dart
│       ├── health_metrics_provider.dart
│       ├── language_provider.dart
│       ├── theme_provider.dart
│       ├── user_profile_provider.dart
│       ├── user_type_provider.dart
│       └── voice_feedback_provider.dart
├── router/                         # App routing
│   └── router.dart
├── l10n/                           # Localization
│   ├── app_ar.arb
│   ├── app_en.arb
│   └── app_fr.arb
├── firebase_options.dart           # Firebase configuration
└── main.dart                       # App entry point
```

## Benefits of This Structure

1. **Feature-Based Organization**: Each feature is self-contained with its own screens, widgets, and models
2. **Clear Separation**: Shared components are separated from feature-specific ones
3. **Scalability**: Easy to add new features without cluttering existing code
4. **Maintainability**: Related files are grouped together logically
5. **Reusability**: Shared components can be easily imported across features

## Migration Plan

1. Create new directory structure
2. Move files to their new locations
3. Update all import statements
4. Update router imports
5. Test the application
6. Remove old directories

## Import Path Updates

After reorganization, import paths will change from:
- `../widgets/shared/` → `../../shared/widgets/`
- `../models/` → `../../shared/models/`
- `../providers/` → `../../shared/providers/`
- `../services/` → `../../shared/services/`

## Feature Responsibilities

- **Auth**: Login, registration, onboarding
- **Dashboard**: Main dashboard, analytics, premium features
- **Health Tracking**: All health monitoring screens (heart, sleep, water, etc.)
- **Profile**: User settings, account management
- **Home**: Main home screen
- **Chat**: AI chat functionality
- **Watch**: Smartwatch integration
- **Legal**: Terms, privacy policy
- **Shared**: Reusable components used across features 