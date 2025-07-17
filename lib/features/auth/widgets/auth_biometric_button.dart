import 'package:flutter/material.dart';
import '../../../core/constants/auth_constants.dart';

class AuthBiometricButton extends StatelessWidget {
  final String iconAsset;
  final String label;
  final VoidCallback onPressed;
  final bool isDark;

  const AuthBiometricButton({
    super.key,
    required this.iconAsset,
    required this.label,
    required this.onPressed,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: AuthConstants.biometricButtonSize,
          height: AuthConstants.biometricButtonSize,
          decoration: BoxDecoration(
            color:
                isDark
                    ? Colors.white.withAlpha((0.1 * 255).toInt())
                    : Colors.white.withAlpha((0.8 * 255).toInt()),
            borderRadius: BorderRadius.circular(AuthConstants.borderRadius12),
            border: Border.all(
              color:
                  isDark
                      ? Colors.white.withAlpha((0.2 * 255).toInt())
                      : Colors.white.withAlpha((0.5 * 255).toInt()),
            ),
            boxShadow: [
              BoxShadow(
                color:
                    isDark
                        ? Colors.black.withAlpha((0.2 * 255).toInt())
                        : Colors.black.withAlpha((0.1 * 255).toInt()),
                blurRadius: AuthConstants.shadowBlurRadius,
                offset: const Offset(0, AuthConstants.shadowOffsetY),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AuthConstants.borderRadius12),
              onTap: onPressed,
              child: Padding(
                padding: const EdgeInsets.all(AuthConstants.spacingSmall),
                child: Image.asset(
                  iconAsset,
                  width: AuthConstants.iconSize,
                  height: AuthConstants.iconSize,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AuthConstants.spacingSmall),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isDark ? Colors.white70 : Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
