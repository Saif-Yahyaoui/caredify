import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'package:intl/intl.dart' as intl;

/// Custom button widget with CAREDIFY styling and accessibility features
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isSecondary;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isSecondary = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
  });

  /// Primary button factory
  factory CustomButton.primary({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    double? width,
    Key? key,
  }) {
    return CustomButton(
      key: key,
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      width: width,
      backgroundColor: AppColors.buttonPrimary,
      textColor: Colors.white,
    );
  }

  /// Secondary button factory
  factory CustomButton.secondary({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    double? width,
    Key? key,
  }) {
    return CustomButton(
      key: key,
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isSecondary: true,
      icon: icon,
      width: width,
      backgroundColor: Colors.transparent,
      textColor: AppColors.buttonSecondary,
    );
  }

  /// Danger/Alert button factory
  factory CustomButton.danger({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    double? width,
    Key? key,
  }) {
    return CustomButton(
      key: key,
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      width: width,
      backgroundColor: AppColors.alertRed,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor =
        backgroundColor ??
        (isSecondary ? Colors.transparent : AppColors.buttonPrimary);
    final effectiveTextColor =
        textColor ?? (isSecondary ? AppColors.buttonSecondary : Colors.white);
    final isEnabled = onPressed != null && !isLoading;

    return Semantics(
      button: true,
      enabled: isEnabled,
      label: text,
      child: SizedBox(
        width: width ?? double.infinity,
        height: height ?? 56, // Accessibility - minimum touch target
        child:
            isSecondary
                ? _buildOutlinedButton(context, effectiveTextColor, isEnabled)
                : _buildElevatedButton(
                  context,
                  effectiveBackgroundColor,
                  effectiveTextColor,
                  isEnabled,
                ),
      ),
    );
  }

  /// Build elevated button with gradient background for primary actions
  Widget _buildElevatedButton(
    BuildContext context,
    Color backgroundColor,
    Color textColor,
    bool isEnabled,
  ) {
    return Ink(
      decoration: BoxDecoration(
        gradient:
            isEnabled
                ? const LinearGradient(
                  colors: [Color(0xFF0092DF), Color(0xFF00C853)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
                : null,
        color: isEnabled ? null : AppColors.buttonDisabled,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Keep it transparent
          shadowColor: Colors.transparent,
          elevation: 0,
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
          ),
        ),
        child: _buildButtonContent(context, textColor),
      ),
    );
  }

  /// Build outlined button for secondary actions
  Widget _buildOutlinedButton(
    BuildContext context,
    Color borderColor,
    bool isEnabled,
  ) {
    return OutlinedButton(
      onPressed: isEnabled ? onPressed : null,
      style: OutlinedButton.styleFrom(
        foregroundColor: borderColor,
        disabledForegroundColor: AppColors.mediumGray,
        side: BorderSide(
          color: isEnabled ? borderColor : AppColors.buttonDisabled,
          width: 2,
        ),
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(12),
        ),
      ),
      child: _buildButtonContent(context, borderColor),
    );
  }

  /// Build button content with loading state and icon support
  Widget _buildButtonContent(BuildContext context, Color contentColor) {
    final locale = Localizations.localeOf(context);
    final isRtl = intl.Bidi.isRtlLanguage(locale.languageCode);
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            contentColor.withOpacity(0.8),
          ),
        ),
      );
    }

    if (icon != null) {
      return Directionality(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              isRtl
                  ? [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          text,
                          style: Theme.of(
                            context,
                          ).textTheme.labelLarge?.copyWith(
                            color: contentColor,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(icon, size: 20, color: contentColor),
                  ]
                  : [
                    Icon(icon, size: 20, color: contentColor),
                    const SizedBox(width: 8),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          text,
                          style: Theme.of(
                            context,
                          ).textTheme.labelLarge?.copyWith(
                            color: contentColor,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
        ),
      );
    }

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Flexible(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: contentColor,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

/// Loading button overlay for async operations
class LoadingButton extends StatefulWidget {
  final String text;
  final Future<void> Function() onPressed;
  final bool isSecondary;
  final IconData? icon;
  final double? width;

  const LoadingButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isSecondary = false,
    this.icon,
    this.width,
  });

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool _isLoading = false;

  Future<void> _handlePress() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onPressed();
    } catch (e) {
      // Handle error - you might want to show a snackbar here
      debugPrint('Button action failed: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: widget.text,
      onPressed: _handlePress,
      isLoading: _isLoading,
      isSecondary: widget.isSecondary,
      icon: widget.icon,
      width: widget.width,
    );
  }
}
