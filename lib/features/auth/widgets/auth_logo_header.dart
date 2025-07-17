import 'package:flutter/material.dart';
import '../../../core/constants/auth_constants.dart';

/// A reusable widget that displays the app logo with optional title and subtitle.
///
/// This widget automatically adapts to the current theme (light/dark) and displays
/// the appropriate logo asset. It's commonly used at the top of authentication
/// screens to provide brand recognition and context.
///
/// Example usage:
/// ```dart
/// AuthLogoHeader(
///   isDark: isDark,
///   title: 'Welcome,
///   subtitle: 'Sign in to continue',
/// )
/// ```
class AuthLogoHeader extends StatelessWidget {
  /// Optional title text to display below the logo.
  final String? title;

  /// Optional subtitle text to display below the title.
  final String? subtitle;

  /// Whether the current theme is dark mode.
  ///
  /// This determines which logo asset to display and text colors to use.
  final bool isDark;

  /// Creates an AuthLogoHeader widget.
  ///
  /// The [isDark] parameter is required and determines the theme-appropriate
  /// styling. The [title] and [subtitle] parameters are optional.
  const AuthLogoHeader({
    super.key,
    this.title,
    this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          isDark ? AuthConstants.logoDarkAsset : AuthConstants.logoAsset,
          width: AuthConstants.logoWidth,
          height: AuthConstants.logoHeight,
          fit: BoxFit.contain,
        ),
        if (title != null) ...[
          const SizedBox(height: AuthConstants.titleSpacing),
          Text(
            title!,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color:
                  isDark
                      ? AuthConstants.darkTextColor
                      : AuthConstants.lightTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        if (subtitle != null) ...[
          const SizedBox(height: AuthConstants.subtitleSpacing),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color:
                  isDark
                      ? AuthConstants.darkSubtitleColor
                      : AuthConstants.lightSubtitleColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
