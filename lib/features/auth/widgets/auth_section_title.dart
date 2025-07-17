import 'package:flutter/material.dart';
import '../../../core/constants/auth_constants.dart';

class AuthSectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const AuthSectionTitle({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 24),
        const SizedBox(width: AuthConstants.spacingSmall),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
