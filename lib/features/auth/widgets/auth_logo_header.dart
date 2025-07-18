import 'package:flutter/material.dart';
import '../../../core/constants/auth_constants.dart';

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
          fit: BoxFit.cover,
        ),
        if (title != null) ...[
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
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color:
                  isDark
                      ? AuthConstants.darkSubtitleColor
                      : AuthConstants.lightSubtitleColor,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
