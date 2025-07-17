import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../services/auth_service.dart';

/// Role-based access control widget
class RoleBasedAccess extends ConsumerWidget {
  final Widget child;
  final List<UserType> allowedUserTypes;
  final Widget? fallbackWidget;

  const RoleBasedAccess({
    super.key,
    required this.child,
    required this.allowedUserTypes,
    this.fallbackWidget,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final userType = authState.userType;

    if (allowedUserTypes.contains(userType)) {
      return child;
    }

    return fallbackWidget ?? _defaultFallback(context, userType);
  }

  Widget _defaultFallback(BuildContext context, UserType userType) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Premium Feature',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'This feature is only available for premium users.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withAlpha((0.7 * 255).toInt()),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.go('/upgrade');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Upgrade to Premium'),
          ),
        ],
      ),
    );
  }
}

/// Extension to easily check user type access
extension UserTypeAccess on UserType {
  bool get isPremium => this == UserType.premium;
  bool get isBasic => this == UserType.basic;
  bool get isLoggedIn => this != UserType.none;
}

/// Hook to get current user type
UserType useUserType(WidgetRef ref) {
  final authState = ref.watch(authStateProvider);
  return authState.userType;
}

/// Hook to check if user has premium access
bool useHasPremiumAccess(WidgetRef ref) {
  final userType = useUserType(ref);
  return userType.isPremium;
}
