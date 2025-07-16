import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/providers/user_type_provider.dart';
import '../../../shared/services/auth_service.dart';


class MessagesScreen extends ConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userType = ref.watch(userTypeProvider);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Settings'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => context.go('/main/profile'),
        ),
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Message Push Settings', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text('Configure message notifications and chat settings.'),
          const Divider(),
          if (userType == UserType.premium)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Premium Message Features',
                style: theme.textTheme.titleLarge,
              ),
            ),
          if (userType == UserType.basic)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Upgrade to unlock more message features!',
                style: theme.textTheme.bodyLarge?.copyWith(color: Colors.blue),
              ),
            ),
        ],
      ),
    );
  }
}
