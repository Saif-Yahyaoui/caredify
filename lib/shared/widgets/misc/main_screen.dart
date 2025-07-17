import 'package:caredify/shared/widgets/navigation/floating_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../services/auth_service.dart';

class MainScreen extends ConsumerStatefulWidget {
  final Widget child;
  const MainScreen({super.key, required this.child});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  List<String> _tabRoutes(UserType userType) {
    if (userType == UserType.premium) {
      return ['/main/dashboard', '/main/watch', '/main/chat', '/main/profile'];
    } else {
      return ['/main/home', '/main/watch', '/main/chat', '/main/profile'];
    }
  }

  int _getSelectedIndex(BuildContext context, UserType userType) {
    final location =
        GoRouter.of(context).routeInformationProvider.value.uri.toString();
    final tabs = _tabRoutes(userType);
    for (int i = 0; i < tabs.length; i++) {
      if (location.startsWith(tabs[i])) {
        return i;
      }
    }
    return 0;
  }

  void _onTabSelected(BuildContext context, int index, UserType userType) {
    final tabs = _tabRoutes(userType);
    final currentIndex = _getSelectedIndex(context, userType);
    if (index != currentIndex) {
      context.go(tabs[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final userType = authState.userType;
    final selectedIndex = _getSelectedIndex(context, userType);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: FloatingBottomNavBar(
          selectedIndex: selectedIndex,
          onTabSelected: (index) => _onTabSelected(context, index, userType),
          userType: userType,
        ),
      ),
    );
  }
}
