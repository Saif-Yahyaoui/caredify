import 'package:flutter/material.dart';

import '../../../core/constants/auth_constants.dart';
import '../../../core/theme/app_colors.dart';

/// A reusable message container for displaying error and success messages
/// in authentication screens
class AuthMessageContainer extends StatelessWidget {
  final String message;
  final bool isError;
  final EdgeInsetsGeometry? margin;

  const AuthMessageContainer({
    super.key,
    required this.message,
    this.isError = true,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AuthConstants.messageContainerPadding,
      margin: margin ?? AuthConstants.messageContainerMargin,
      decoration: BoxDecoration(
        color:
            isError ? AppColors.alertBackground : AppColors.successBackground,
        borderRadius: BorderRadius.circular(
          AuthConstants.messageContainerBorderRadius,
        ),
        border: Border.all(
          color:
              isError
                  ? AppColors.alertRed.withAlpha((0.3 * 255).toInt())
                  : AppColors.healthGreen.withAlpha((0.3 * 255).toInt()),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: isError ? AppColors.alertRed : AppColors.healthGreen,
            size: AuthConstants.messageContainerIconSize,
          ),
          const SizedBox(width: AuthConstants.messageContainerIconSpacing),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isError ? AppColors.alertRed : AppColors.healthGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
