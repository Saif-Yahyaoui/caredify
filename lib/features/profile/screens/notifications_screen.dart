import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/user_type_provider.dart';
import '../../../shared/services/auth_service.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  bool _pushNotificationsEnabled = true;
  bool _emailNotificationsEnabled = true;
  bool _inAppNotificationsEnabled = true;
  bool _healthAlertsEnabled = true;
  bool _activityRemindersEnabled = true;
  bool _weeklyReportsEnabled = false;
  bool _emergencyAlertsEnabled = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final userType = ref.watch(userTypeProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
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
        actions: [
          if (userType == UserType.premium)
            TextButton(
              onPressed: _saveNotificationSettings,
              child:
                  _isLoading
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Text('Save'),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // General Notifications
            _buildSectionHeader(
              context,
              theme,
              isDark,
              'General Notifications',
            ),
            const SizedBox(height: 16),
            _buildNotificationCard(
              context,
              theme,
              isDark,
              'Push Notifications',
              'Receive notifications on your device',
              Icons.notifications,
              const Color(0xFF3B82F6),
              _pushNotificationsEnabled,
              (value) => setState(() => _pushNotificationsEnabled = value),
              userType,
            ),
            const SizedBox(height: 16),
            _buildNotificationCard(
              context,
              theme,
              isDark,
              'Email Notifications',
              'Receive notifications via email',
              Icons.email,
              const Color(0xFF10B981),
              _emailNotificationsEnabled,
              (value) => setState(() => _emailNotificationsEnabled = value),
              userType,
            ),
            const SizedBox(height: 16),
            _buildNotificationCard(
              context,
              theme,
              isDark,
              'In-App Notifications',
              'Show notifications within the app',
              Icons.notifications_active,
              const Color(0xFF8B5CF6),
              _inAppNotificationsEnabled,
              (value) => setState(() => _inAppNotificationsEnabled = value),
              userType,
            ),
            const SizedBox(height: 24),

            // Health Notifications
            _buildSectionHeader(context, theme, isDark, 'Health Notifications'),
            const SizedBox(height: 16),
            _buildNotificationCard(
              context,
              theme,
              isDark,
              'Health Alerts',
              'Get notified about health issues',
              Icons.health_and_safety,
              const Color(0xFFEF4444),
              _healthAlertsEnabled,
              (value) => setState(() => _healthAlertsEnabled = value),
              userType,
            ),
            const SizedBox(height: 16),
            _buildNotificationCard(
              context,
              theme,
              isDark,
              'Activity Reminders',
              'Reminders for daily activities',
              Icons.fitness_center,
              const Color(0xFFF59E0B),
              _activityRemindersEnabled,
              (value) => setState(() => _activityRemindersEnabled = value),
              userType,
            ),
            const SizedBox(height: 16),
            _buildNotificationCard(
              context,
              theme,
              isDark,
              'Weekly Reports',
              'Receive weekly health summaries',
              Icons.assessment,
              const Color(0xFF06B6D4),
              _weeklyReportsEnabled,
              (value) => setState(() => _weeklyReportsEnabled = value),
              userType,
              isPremiumOnly: true,
            ),
            const SizedBox(height: 24),

            // Emergency Notifications
            _buildSectionHeader(
              context,
              theme,
              isDark,
              'Emergency Notifications',
            ),
            const SizedBox(height: 16),
            _buildNotificationCard(
              context,
              theme,
              isDark,
              'Emergency Alerts',
              'Critical health and safety alerts',
              Icons.emergency,
              const Color(0xFFDC2626),
              _emergencyAlertsEnabled,
              (value) => setState(() => _emergencyAlertsEnabled = value),
              userType,
            ),
            const SizedBox(height: 24),

            // Notification Schedule
            _buildSectionHeader(
              context,
              theme,
              isDark,
              'Notification Schedule',
            ),
            const SizedBox(height: 16),
            _buildActionCard(
              context,
              theme,
              isDark,
              'Quiet Hours',
              'Set times when notifications are silenced',
              Icons.bedtime,
              const Color(0xFF6366F1),
              () => _showQuietHoursDialog(context),
              userType,
              isPremiumOnly: true,
            ),
            const SizedBox(height: 16),
            _buildActionCard(
              context,
              theme,
              isDark,
              'Notification Frequency',
              'Control how often you receive notifications',
              Icons.schedule,
              const Color(0xFF8B5CF6),
              () => _showFrequencyDialog(context),
              userType,
              isPremiumOnly: true,
            ),
            const SizedBox(height: 24),

            // Premium Features
            if (userType == UserType.premium)
              _buildPremiumFeaturesSection(context, theme, isDark)
            else
              _buildUpgradeSection(context, theme, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    String title,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDark
                  ? [
                    const Color(0xFF1E293B).withAlpha((0.5 * 255).toInt()),
                    const Color(0xFF334155).withAlpha((0.4 * 255).toInt()),
                  ]
                  : [const Color(0xFFF1F5F9), const Color(0xFFE2E8F0)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isDark
                  ? const Color(0xFF475569).withAlpha((0.2 * 255).toInt())
                  : const Color(0xFFCBD5E1).withAlpha((0.3 * 255).toInt()),
          width: 1,
        ),
      ),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : const Color(0xFF1E293B),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    bool value,
    ValueChanged<bool> onChanged,
    UserType userType, {
    bool isPremiumOnly = false,
  }) {
    final isEnabled = !isPremiumOnly || userType == UserType.premium;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isEnabled ? null : Colors.grey.withAlpha((0.1 * 255).toInt()),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, color.withAlpha((0.8 * 255).toInt())],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: color.withAlpha((0.3 * 255).toInt()),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                      if (isPremiumOnly && userType != UserType.premium) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD700),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'PREMIUM',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                ],
              ),
            ),
            Switch(value: value, onChanged: isEnabled ? onChanged : null),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
    UserType userType, {
    bool isPremiumOnly = false,
  }) {
    final isEnabled = !isPremiumOnly || userType == UserType.premium;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color:
                isEnabled ? null : Colors.grey.withAlpha((0.1 * 255).toInt()),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color, color.withAlpha((0.8 * 255).toInt())],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: color.withAlpha((0.3 * 255).toInt()),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color:
                                isDark ? Colors.white : const Color(0xFF1E293B),
                          ),
                        ),
                        if (isPremiumOnly && userType != UserType.premium) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD700),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'PREMIUM',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: theme.hintColor, size: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumFeaturesSection(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                isDark
                    ? [
                      const Color(0xFF1E293B).withAlpha((0.8 * 255).toInt()),
                      const Color(0xFF334155).withAlpha((0.5 * 255).toInt()),
                    ]
                    : [const Color(0xFFFFF8E1), const Color(0xFFFFF3CD)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFFFD700).withAlpha((0.3 * 255).toInt()),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'PREMIUM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Premium Notification Features',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Weekly health reports, quiet hours, notification frequency controls, and advanced notification scheduling.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white70 : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpgradeSection(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                isDark
                    ? [
                      const Color(0xFF1E293B).withAlpha((0.8 * 255).toInt()),
                      const Color(0xFF334155).withAlpha((0.5 * 255).toInt()),
                    ]
                    : [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryBlue.withAlpha((0.3 * 255).toInt()),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star, color: Color(0xFFFFD700), size: 24),
                const SizedBox(width: 12),
                Text(
                  'Upgrade for Advanced Notifications',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Unlock weekly health reports, quiet hours, notification frequency controls, and advanced scheduling.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white70 : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go('/upgrade'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Upgrade Now',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuietHoursDialog(BuildContext context) {
    final userType = ref.read(userTypeProvider);
    if (userType != UserType.premium) {
      _showUpgradeDialog(context);
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Quiet Hours'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Set times when notifications are silenced'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Start Time',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'End Time',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Quiet hours updated'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  void _showFrequencyDialog(BuildContext context) {
    final userType = ref.read(userTypeProvider);
    if (userType != UserType.premium) {
      _showUpgradeDialog(context);
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Notification Frequency'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: const Text('Immediate'),
                  subtitle: const Text('Receive notifications instantly'),
                  value: 'immediate',
                  groupValue: 'immediate',
                  onChanged: (value) {},
                ),
                RadioListTile<String>(
                  title: const Text('Hourly'),
                  subtitle: const Text('Receive notifications every hour'),
                  value: 'hourly',
                  groupValue: 'immediate',
                  onChanged: (value) {},
                ),
                RadioListTile<String>(
                  title: const Text('Daily'),
                  subtitle: const Text('Receive notifications once per day'),
                  value: 'daily',
                  groupValue: 'immediate',
                  onChanged: (value) {},
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notification frequency updated'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Premium Feature'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, size: 48, color: Color(0xFFFFD700)),
                SizedBox(height: 16),
                Text(
                  'This feature is only available for Premium users. Upgrade to unlock advanced notification controls.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/upgrade');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Upgrade'),
              ),
            ],
          ),
    );
  }

  Future<void> _saveNotificationSettings() async {
    setState(() => _isLoading = true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification settings updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update settings: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
