import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../shared/providers/user_type_provider.dart';
import '../../shared/services/auth_service.dart';
import 'route_names.dart';

/// Navigation helpers for GoRouter
class NavigationHelpers {
  /// Safely navigate to a route only if not already there
  static void safeGo(BuildContext context, String route) {
    final currentLocation =
        GoRouter.of(context).routeInformationProvider.value.uri.toString();
    if (currentLocation != route) {
      context.go(route);
    }
  }

  /// Pop to root (dashboard or home) based on user type
  static void popToRoot(BuildContext context, WidgetRef ref) {
    final userType = ref.read(userTypeProvider);
    if (userType == UserType.premium) {
      context.go(RouteNames.dashboard);
    } else if (userType == UserType.basic) {
      context.go(RouteNames.home);
    } else {
      context.go(RouteNames.splash);
    }
  }

  /// Go to a route if it exists in RouteNames
  static void goToNamedRoute(BuildContext context, String route) {
    const allRoutes = RouteNames.allRoutes;
    if (allRoutes.contains(route)) {
      context.go(route);
    }
  }
}
