import 'package:flutter/material.dart';

import '../../../core/constants/auth_constants.dart';
import '../../../core/theme/app_colors.dart';

class AuthFloatingCard extends StatelessWidget {
  /// The content to display inside the card.
  final Widget child;

  /// Custom padding for the card content.
  ///
  /// If null, uses the default padding defined in [AuthConstants].
  final EdgeInsetsGeometry? padding;

  /// Custom margin for the card.
  final EdgeInsetsGeometry? margin;

  /// The border radius for the card corners.
  ///
  /// Defaults to [AuthConstants.floatingCardBorderRadius].
  final double borderRadius;

  /// Whether this card should use the primary styling.
  ///
  /// Primary cards have a blue gradient background and are typically used
  /// for main content areas.
  final bool isPrimary;

  /// Whether this card should use form-specific styling.
  ///
  /// Form cards have a white/transparent background and are typically used
  /// for input forms.
  final bool isFormCard;

  /// Creates an AuthFloatingCard widget.
  ///
  /// The [child] parameter is required and contains the content to display.
  /// TheisPrimary] and [isFormCard] parameters control the visual styling.
  const AuthFloatingCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = AuthConstants.floatingCardBorderRadius,
    this.isPrimary = false,
    this.isFormCard = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: padding ?? AuthConstants.paddingAll16,
      margin: margin,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _getGradientColors(isDark),
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: _getBorderColor(isDark),
          width: AuthConstants.floatingCardBorderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: _getShadowColor(isDark),
            blurRadius: borderRadius,
            offset: const Offset(0, AuthConstants.floatingCardShadowOffsetY),
          ),
        ],
      ),
      child: child,
    );
  }

  /// Returns the appropriate gradient colors based on the card type and theme.
  List<Color> _getGradientColors(bool isDark) {
    if (isPrimary) {
      return isDark
          ? [
            AppColors.primaryBlue.withAlpha((0.1 * 255).toInt()),
            AppColors.primaryBlue.withAlpha((0.1 * 255).toInt()),
          ]
          : [
            AppColors.primaryBlue.withAlpha((0.1 * 255).toInt()),
            AppColors.primaryBlue.withAlpha((0.1 * 255).toInt()),
          ];
    } else if (isFormCard) {
      return isDark
          ? [
            Colors.white.withAlpha((0.05 * 255).toInt()),
            Colors.white.withAlpha((0.02 * 255).toInt()),
          ]
          : [
            Colors.white.withAlpha((0.8 * 255).toInt()),
            Colors.white.withAlpha((0.6 * 255).toInt()),
          ];
    } else {
      return isDark
          ? [
            AppColors.primaryBlue.withAlpha((0.1 * 255).toInt()),
            AppColors.primaryBlue.withAlpha((0.1 * 255).toInt()),
          ]
          : [
            AppColors.primaryBlue.withAlpha((0.1 * 255).toInt()),
            AppColors.primaryBlue.withAlpha((0.1 * 255).toInt()),
          ];
    }
  }

  /// Returns the appropriate border color based on the card type and theme.
  Color _getBorderColor(bool isDark) {
    if (isPrimary) {
      return isDark
          ? AppColors.primaryBlue.withAlpha((0.2 * 255).toInt())
          : AppColors.primaryBlue.withAlpha((0.2 * 255).toInt());
    } else if (isFormCard) {
      return isDark
          ? Colors.white.withAlpha((0.1 * 255).toInt())
          : Colors.white.withAlpha((0.3 * 255).toInt());
    } else {
      return isDark
          ? AppColors.primaryBlue.withAlpha((0.2 * 255).toInt())
          : AppColors.primaryBlue.withAlpha((0.2 * 255).toInt());
    }
  }

  /// Returns the appropriate shadow color based on the card type and theme.
  Color _getShadowColor(bool isDark) {
    if (isPrimary) {
      return isDark
          ? Colors.black.withAlpha((0.3 * 255).toInt())
          : AppColors.primaryBlue.withAlpha((0.1 * 255).toInt());
    } else if (isFormCard) {
      return isDark
          ? Colors.black.withAlpha((0.3 * 255).toInt())
          : Colors.black.withAlpha((0.1 * 255).toInt());
    } else {
      return isDark
          ? Colors.black.withAlpha((0.3 * 255).toInt())
          : AppColors.primaryBlue.withAlpha((0.1 * 255).toInt());
    }
  }
}
