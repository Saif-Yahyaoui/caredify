import 'package:flutter/material.dart';

/// Centralized constants for the authentication feature.
class AuthConstants {
  // Colors
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color textPrimaryDark = Color(0xFF1E293B);
  static const Color accentBlue = Color(0xFF60A5FA);
  static const Color accentGreen = Color(0xFF00C853);
  static const Color accentPurple = Color(0xFFB388FF);
  static const Color accentTeal = Color(0xFF4ADE80);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF475569);
  static const Color borderLight = Color(0xFFCBD5E1);
  static const Color borderLighter = Color(0xFFE2E8F0);
  static const Color iconInactive = Color(0xFF94A3B8);
  static const Color gradientBlue = Color(0xFF0092DF);
  static const Color white = Colors.white;
  static const Color white70 = Colors.white70;
  static const Color black = Colors.black;
  static const Color black54 = Colors.black54;
  static const Color green = Colors.green;

  // Text Colors for Light/Dark
  static const Color textDark = textPrimaryDark;
  static const Color textGray = textSecondary;
  static const Color textGrayLight = borderLight;
  static const Color darkTextColor = white;
  static const Color lightTextColor = black;
  static const Color darkSubtitleColor = white70;
  static const Color lightSubtitleColor = black54;

  // Paddings & Margins
  static const EdgeInsets paddingAll24 = EdgeInsets.all(24);
  static const EdgeInsets paddingAll16 = EdgeInsets.all(16);
  static const EdgeInsets paddingAll12 = EdgeInsets.all(12);
  static const EdgeInsets paddingSymmetricH20 = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 8,
  );
  static const EdgeInsets paddingSymmetricH16 = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );
  static const EdgeInsets paddingSymmetricV20 = EdgeInsets.symmetric(
    vertical: 20,
  );
  static const EdgeInsets paddingSymmetricH8 = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 4,
  );
  static const EdgeInsets paddingOnlyLeft16 = EdgeInsets.only(left: 16);
  static const EdgeInsets paddingOnlyBottom20 = EdgeInsets.only(bottom: 20);
  static const EdgeInsets paddingZero = EdgeInsets.zero;

  // Spacing
  static const double spacingSmall = 12.0;
  static const double spacingMedium = 20.0;
  static const double spacingLarge = 24.0;
  static const double buttonSpacing = 16.0;
  static const double titleSpacing = 16.0;
  static const double subtitleSpacing = 8.0;

  // Border Radius
  static const double borderRadius4 = 4.0;
  static const double borderRadius8 = 8.0;
  static const double borderRadius12 = 12.0;
  static const double borderRadius16 = 16.0;
  static const double borderRadius24 = 24.0;
  static const double borderRadius28 = 28.0;
  static const double floatingCardBorderRadius = 24.0;
  static const double messageContainerBorderRadius = 12.0;

  // Border Widths
  static const double borderWidth = 1.5;
  static const double floatingCardBorderWidth = 1.0;

  // Durations
  static const Duration durationShort = Duration(milliseconds: 300);
  static const Duration durationMedium = Duration(milliseconds: 400);
  static const Duration durationSplashFade = Duration(milliseconds: 1500);
  static const Duration durationSplashScale = Duration(milliseconds: 10);
  static const Duration durationSplashDelay = Duration(milliseconds: 2500);
  static const Duration durationSplashStartDelay = Duration(milliseconds: 300);
  static const Duration validationDelay = Duration(seconds: 2);

  // Asset Paths
  static const String logoLight = 'assets/images/logo.png';
  static const String logoDark = 'assets/images/logo_dark.png';
  static const String logoAsset = logoLight;
  static const String logoDarkAsset = logoDark;
  static const String googleIcon = 'assets/icons/google.svg';
  static const String facebookIcon = 'assets/icons/facebook.svg';
  static const String fingerprintIcon = 'assets/icons/fingerprint.png';
  static const String facialIcon = 'assets/icons/facial.png';

  // Sizes
  static const double logoWidth = 200.0;
  static const double logoHeight = 150.0;
  static const double iconSizeLarge = 60.0;
  static const double iconSizeMedium = 48.0;
  static const double iconSizeSmall = 36.0;
  static const double iconSizeTiny = 24.0;
  static const double iconSize = 24.0;
  static const double iconButtonSize = 48.0;
  static const double dotWidthActive = 32.0;
  static const double dotWidthInactive = 8.0;
  static const double dotHeight = 8.0;
  static const double dotSize = 6.0;
  static const double bulletSize = 6.0;
  static const double dividerWidth = 1.0;
  static const double dividerHeight = 16.0;
  static const double fontSizeTitle = 20.0;
  static const double fontSizeSubtitle = 18.0;
  static const double fontSizeSection = 16.0;
  static const double fontSizeBody = 15.0;
  static const double fontSizeSmall = 14.0;
  static const double fontSizeTiny = 13.0;
  static const double fontSizeCaption = 12.0;
  static const double loginTextFontSize = 15.0;
  static const double messageContainerIconSize = 20.0;
  static const double messageContainerIconSpacing = 12.0;
  static const double buttonHeight = 48.0;
  static const double buttonHorizontalPadding = 16.0;
  static const double iconWidth = 24.0;
  static const double iconHeight = 24.0;
  static const double iconSpacing = 8.0;
  static const double biometricButtonSize = 60.0;
  static const double floatingCardShadowOffsetY = 8.0;
  static const double shadowBlurRadius = 8.0;
  static const double shadowOffsetY = 4.0;
  static const double loadingIndicatorSize = 40.0;
  static const double loadingIndicatorStrokeWidth = 3.0;
  static const double loadingIndicatorTextSpacing = 16.0;
  static const double splashLogoSpacing = 80.0;

  // Floating Card
  static const EdgeInsets floatingCardPadding = EdgeInsets.all(24);
  static const double floatingCardHorizontalPadding = 24.0;
  static const double floatingCardVerticalPadding = 24.0;

  // Message Container
  static const EdgeInsets messageContainerPadding = EdgeInsets.all(16);
  static const EdgeInsets messageContainerMargin = EdgeInsets.only(bottom: 20);

  // Shared preferences keys
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String authTokenKey = 'auth_token';

  // Language codes
  static const String englishLanguageCode = 'en-US';
  static const String arabicLanguageCode = 'ar-SA';
  static const String frenchLanguageCode = 'fr-FR';

  // Demo values
  static const String demoToken = 'demo_token';

  AuthConstants._();
}
