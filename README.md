<p align="center">
  <img src="assets/images/logo.png" alt="Light Theme Logo" width="220" style="margin-right: 40px;"/>
  <img src="assets/images/logo_dark.png" alt="Dark Theme Logo" width="220"/>
</p>

# CAREDIFY

<!-- SonarCloud Badges -->
<p align="center">
  <a href="https://sonarcloud.io/summary/new_code?id=Saif-Yahyaoui_caredify">
    <img src="https://sonarcloud.io/api/project_badges/measure?project=Saif-Yahyaoui_caredify&metric=alert_status" alt="Quality Gate Status"/>
  </a>
  <a href="https://sonarcloud.io/summary/new_code?id=Saif-Yahyaoui_caredify">
    <img src="https://sonarcloud.io/api/project_badges/measure?project=Saif-Yahyaoui_caredify&metric=coverage" alt="Coverage"/>
  </a>
  <a href="https://sonarcloud.io/summary/new_code?id=Saif-Yahyaoui_caredify">
    <img src="https://sonarcloud.io/api/project_badges/measure?project=Saif-Yahyaoui_caredify&metric=bugs" alt="Bugs"/>
  </a>
  <a href="https://sonarcloud.io/summary/new_code?id=Saif-Yahyaoui_caredify">
    <img src="https://sonarcloud.io/api/project_badges/measure?project=Saif-Yahyaoui_caredify&metric=vulnerabilities" alt="Vulnerabilities"/>
  </a>
  <a href="https://sonarcloud.io/summary/new_code?id=Saif-Yahyaoui_caredify">
    <img src="https://sonarcloud.io/api/project_badges/measure?project=Saif-Yahyaoui_caredify&metric=sqale_rating" alt="Maintainability Rating"/>
  </a>
</p>

<p align="center">
  <em>Automated code quality, coverage, and maintainability analysis powered by SonarCloud.</em>
</p>

**Smart ECG Monitoring & AI Health Companion**

---

## 🚀 Overview

CAREDIFY is an innovative telehealth app for patients at risk of heart failure. It pairs with a smart ECG belt to provide real-time cardiac monitoring, AI-driven health tips, and secure communication with healthcare professionals. Designed for seniors, CAREDIFY features a soft, reassuring interface and robust accessibility.

---

## 🧩 Key Features

- **Authentication:** Email/password login, onboarding, registration, forgot password. (Google/Facebook login planned)
- **Dashboard:** Real-time vitals, ECG card, heart tracker, water intake, sleep rating, workout tracker, health index, healthy habits, weekly charts.
- **Accessibility:** Font size toggle, dark/light/system theme, TTS (voice feedback), RTL support, large tap zones, screen reader labels.
- **Internationalization:** Full support for English, French, Arabic via `.arb` files; instant language switching.
- **Voice Feedback:** TTS for all major actions and alerts, toggleable in accessibility controls.
- **Legal & Compliance:** Privacy Policy, Terms of Service screens.
- **Profile:** User profile management.
- **Planned/Upcoming:** Chat with doctors, AI health recommendations, BLE device pairing, Google/Facebook login.

---

## 🏗️ Updated Project Structure

```plaintext
caredify/
├── android/                  # Android native project
├── assets/
│   ├── icons/                # SVG and PNG icons
│   └── images/               # App images (logo, onboarding, profile)
├── ios/                      # iOS native project
├── lib/
│   ├── core/
│   │   ├── constants/        # App-wide constants
│   │   ├── theme/            # Color palette & theme
│   │   ├── utils/            # Utility functions (validators, etc.)
│   │   └── navigation/       # Navigation helpers
│   ├── features/
│   │   ├── auth/             # Auth screens (login, register, onboarding, splash, welcome, forgot password)
│   │   ├── dashboard/        # Dashboard, health cards, trackers, charts
│   │   ├── profile/          # Profile, accessibility settings
│   │   ├── legal/            # Privacy policy, terms of service
│   │   ├── recommendations/  # (Planned) AI health recommendations
│   │   ├── chat/             # (Planned) Chat with doctors
│   │   ├── home/             # Home screen
│   │   ├── health_tracking/  # Health tracking screens
│   │   └── watch/            # Health watch connection screen
│   ├── l10n/                 # Localization files (.arb)
│   ├── shared/
│   │   ├── models/           # Data models (habit, health_metrics, user_profile, ecg_analysis_result)
│   │   ├── providers/        # Riverpod state providers (auth, habits, health, language, theme, user, voice, ai_chat, ecg_analysis)
│   │   ├── services/         # Service classes (auth_service, ai_chat_service, ecg_analysis_service)
│   │   └── widgets/          # Shared UI widgets (cards, charts, premium, role-based, etc.)
│   ├── main.dart             # App entry point
│   ├── router/               # App router (GoRouter)
│   └── firebase_options.dart # Firebase config
├── macos/                    # macOS native project
├── test/                     # Unit, provider, widget, and integration tests
│   ├── unit/                 # Unit tests for services, models, and utils
│   ├── providers/            # Provider/state management tests
│   ├── widgets/              # Widget tests (with shared/ for shared widgets)
│   ├── screens/              # Screen/feature tests
│   ├── integration/          # Integration tests (user flows, navigation)
│   ├── mocks/                # Mock implementations for services/providers
│   ├── reports/              # Test reports and documentation
│   ├── test_helpers.dart     # Common test utilities and setup
│   └── test_runner.dart      # Test execution utilities
├── pubspec.yaml              # Flutter dependencies
├── pubspec.lock              # Dependency lockfile
├── README.md                 # Project documentation
└── ...                       # Other config/build files
```

### Test Patterns & Mocking

- All widget and unit tests use provider/service overrides to avoid real Firebase or platform dependencies.
- ProviderScope overrides and standalone mocks are used for all Firebase-dependent code.
- Robust test templates for widgets and services ensure reliable, maintainable testing.

---

## ♿ Accessibility

- Font size toggle (normal/large)
- Theme toggle (light/dark/system)
- Voice feedback (TTS) toggle
- Language selector (EN/FR/AR)
- RTL support
- Large, touch-friendly UI
- Screen reader labels

---

## 🌐 Internationalization

- `.arb` files for EN, FR, AR in `lib/l10n/`
- All UI and TTS fully localized
- Language switching in-app

---

## 🔐 Security & Compliance

- GDPR & HIPAA-ready design
- Privacy Policy & Terms screens
- (Planned) AES-256 encryption, secure storage, HTTPS-only, offline sync

---

## 📊 Dashboard & UI Components

- Floating bottom navigation bar
- Cards for ECG, heart, water, sleep, workouts, health index
- Weekly charts, metrics row, circular step counter

---

## 📡 BLE Connection & Pairing

- UI placeholders for BLE/ECG device connection (Movesense planned)
- BLE logic not yet implemented, but navigation and UI are ready

---

## 🚧 Planned Features

- Chat with doctors (feature folder present, not yet implemented)
- AI health recommendations (feature folder present, not yet implemented)
- BLE device pairing (UI present, logic planned)
- Google/Facebook login (UI present, logic TODO)

---

## 🛠️ Tech Stack

| Tech                  | Usage                |
| --------------------- | -------------------- |
| Flutter               | UI, cross-platform   |
| Dart                  | Main language        |
| Riverpod              | State management     |
| GoRouter              | Navigation           |
| flutter_tts           | Voice feedback (TTS) |
| flutter_localizations | i18n/l10n            |
| .arb                  | Localization files   |
| Material Design       | UI/UX                |

---

## ▶️ How to Run

1. **Prerequisites:**

   - [Flutter](https://flutter.dev/) 3.10+
   - Dart 3.0+
   - Android Studio or Xcode (for iOS)
   - (Optional) Movesense ECG device for full functionality

2. **Setup:**

   ```bash
   flutter pub get
   flutter gen-l10n
   flutter run
   ```

   - `flutter gen-l10n` generates Dart localization files from your `.arb` files in `lib/l10n/`. Run this after adding or updating translations.

3. **Run All Tests:**

   ```bash
   flutter test
   ```

   - All widget and unit tests use provider/service mocking, so no real Firebase setup is required for most tests.
   - If you see Firebase or platform errors in integration tests, check if those tests require real backend setup.

4. **Run Tests with Coverage:**

   ```bash
   flutter test --coverage
   genhtml coverage/lcov.info -o coverage/html
   # Open coverage/html/index.html in your browser
   ```

5. **Troubleshooting:**
   - If you see platform or Firebase errors in widget/unit tests, ensure you are using the latest codebase with provider/service overrides and mocks.
   - Integration tests may require additional setup if they use real Firebase features.

---

## 📄 License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

---

## 🙌 Credits

- **Lead Developer:** Saif Yahyaoui
- **Supervision:** Werghemmi Radhia & Bensaed Radhia
- **Design:** [Figma UI Team]
- **Special Thanks:** All contributors and testers

---

## 📸 Screenshots

<p align="center">
  <img src="assets/images/dashboard_light.png" width="200"/>
  <img src="assets/images/dashboard_dark.png" width="200"/>
  <img src="assets/images/login.png" width="200"/>
</p>

---

## 📄 Documentation

- [Cahier des Charges (Project Specification)](docs/cahier_des_charges.pdf)
- [System Diagrams (Architecture, Flows, etc.)](docs/diagrams.pdf)

---

**For more details, see the codebase and comments in each folder.**

---

**This version is now clean, professional, and focused—ready for users, developers, and stakeholders.**
