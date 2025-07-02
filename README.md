<p align="center">
  <img src="assets/images/logo.png" alt="CAREDIFY Logo" width="120"/>
</p>

# CAREDIFY

**Smart ECG Monitoring & AI Health Companion**

---

## 🌍 Multilingual & Voice-Accessible

- **Full UI & Voice Feedback in English, French, and Arabic**
- **All app text and TTS (Text-to-Speech) are fully localized and translated**
- **Dynamic TTS language:** Voice feedback automatically matches the selected app language
- **Easy language switching:** Change language anytime from the accessibility controls
- **Contribute translations:** See [Contributing](#contributing-translations)

---

## 🔍 Overview

CAREDIFY is an innovative telehealth app for patients at risk of heart failure. It pairs with a smart ECG belt to provide real-time cardiac monitoring, AI-driven health tips, and secure communication with healthcare professionals. Designed for seniors, CAREDIFY features a soft, reassuring interface and robust accessibility.

---

## 🧠 Key Features

- **BLE ECG Sensor Pairing**: Connects securely to Movesense Medical ECG belts.
- **Real-Time ECG Visualization**: Live display of ECG, BPM, SpO2, temperature, and more.
- **AI Health Tips**: Personalized recommendations based on your data.
- **Chat with Doctors**: Secure, multilingual messaging with healthcare professionals.
- **Offline Sync**: Data is stored locally and synced when online.
- **Multilingual Support**: French, English, Arabic (UI & TTS)
- **Accessibility**: Large text, high contrast, dark mode, voice feedback (TTS), screen reader support.
- **Critical Alerts**: Immediate notifications for dangerous anomalies.

---

## 📱 Design Principles

- **Soft Emotional Palette**: Calming blue (#0092DF) and green (#00C853).
- **Rounded, Touch-Friendly Components**: Large tap zones, minimum 18–20px font.
- **Brand Compliance**: Logo color is never altered.
- **Senior-Optimized Layout**: Critical info at the top, clear hierarchy, visual and voice feedback.

---

## ♿ Accessibility

- **Screen Reader Support**: All interactive elements are labeled for screen readers.
- **Voice Feedback (TTS)**: Key actions and alerts are announced aloud in the selected language.
- **Large Fonts**: All text is at least 18–20px for readability.
- **High Contrast**: Color palette and contrast ratios are optimized for visibility.
- **Accessible Navigation**: Floating bottom navigation bar with large tap zones, fully localized.
- **User Toggle**: Voice feedback can be enabled/disabled in accessibility controls.

---

## 🌐 Switching Languages

- Go to **Accessibility Controls** in the app
- Select your preferred language (English, Français, العربية)
- All UI and voice feedback will instantly update to your chosen language

---

## 🔠 Contributing Translations

- All app text is managed in ARB files: `lib/l10n/app_en.arb`, `app_fr.arb`, `app_ar.arb`
- To add or update translations, edit these files and run:
  ```bash
  flutter pub get
  flutter gen-l10n
  ```
- Please keep ARB files up to date when adding new features
- See Flutter's [internationalization guide](https://docs.flutter.dev/accessibility-and-localization/internationalization)

---

## 🔐 Security & Compliance

- **AES-256 Encryption**: All sensitive data is encrypted.
- **Two-Factor Authentication**: Optional 2FA for enhanced security.
- **GDPR & HIPAA Ready**: Data privacy and compliance by design.
- **Secure Storage**: Tokens and health data stored securely on device.
- **HTTPS Only**: All network traffic is encrypted.
- **Privacy Policy & Terms**: Accessible from the app.

---

## 🚀 Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/) 3.10+
- Dart 3.0+
- Android Studio or Xcode (for iOS)
- Movesense Medical ECG device (for full functionality)

### Installation

```bash
git clone https://github.com/Saif-Yahyaoui/caredify.git
cd caredify
flutter pub get
flutter run
```

---

## 🔗 Screenshots

<p align="center">
  <img src="assets/images/dashboard_light.png" width="200"/>
  <img src="assets/images/dashboard_dark.png" width="200"/>
  <img src="assets/images/login.png" width="200"/>
</p>

---

## 📄 License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

---

## 🙌 Credits / Supervision

- **Lead Developer**: Saif Yahyaoui
- **Supervision**: [Supervisor Name]
- **Design**: [Figma UI Team]
- **Special Thanks**: All contributors and testers

---

## 📌 More

- [Cahier des Charges (FR)](docs/cahier_des_charges.pdf)
- [Figma UI Kit](#)
- [API Documentation](#)

---
