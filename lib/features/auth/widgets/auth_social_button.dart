import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/auth_constants.dart';

class AuthSocialButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onPressed;
  final bool isLoading;

  const AuthSocialButton({
    super.key,
    required this.iconPath,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AuthConstants.buttonHeight,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AuthConstants.borderRadius12),
        border: Border.all(
          color: borderColor,
          width: AuthConstants.borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: borderColor.withAlpha((0.2 * 255).toInt()),
            blurRadius: AuthConstants.shadowBlurRadius,
            offset: const Offset(0, AuthConstants.shadowOffsetY),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AuthConstants.borderRadius12),
          onTap: isLoading ? null : onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AuthConstants.buttonHorizontalPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  iconPath,
                  width: AuthConstants.iconWidth,
                  height: AuthConstants.iconHeight,
                ),
                const SizedBox(width: AuthConstants.iconSpacing),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
