import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/user_type_provider.dart';
import '../../../shared/services/auth_service.dart';

class ResetDeviceScreen extends ConsumerStatefulWidget {
  const ResetDeviceScreen({super.key});

  @override
  ConsumerState<ResetDeviceScreen> createState() => _ResetDeviceScreenState();
}

class _ResetDeviceScreenState extends ConsumerState<ResetDeviceScreen> {
 

  @override
  Widget build(BuildContext context) {
    final userType = ref.watch(userTypeProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Device'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Warning Section
            _buildWarningCard(context, theme, isDark),
            const SizedBox(height: 24),

            // Reset Options
            _buildSectionHeader(context, theme, isDark, 'Reset Options'),
            const SizedBox(height: 16),

            // Settings Reset
            _buildResetCard(
              context,
              theme,
              isDark,
              'Settings Reset',
              'Reset app settings to default values',
              'This will reset all app preferences, themes, and configurations. Your data will be preserved.',
              Icons.settings_backup_restore,
              const Color(0xFF3B82F6),
              () => _showSettingsResetDialog(context),
              userType,
            ),
            const SizedBox(height: 16),

            // Data Reset
            _buildResetCard(
              context,
              theme,
              isDark,
              'Data Reset',
              'Clear all health data and user information',
              'This will delete all your health data, activity history, and personal information. This action cannot be undone.',
              Icons.delete_sweep,
              const Color(0xFFEF4444),
              () => _showDataResetDialog(context),
              userType,
              isPremiumOnly: true,
            ),
            const SizedBox(height: 16),

            // Factory Reset
            _buildResetCard(
              context,
              theme,
              isDark,
              'Factory Reset',
              'Complete device reset to factory settings',
              'This will completely reset the device to factory settings. All data, settings, and configurations will be permanently deleted.',
              Icons.restore,
              const Color(0xFFDC2626),
              () => _showFactoryResetDialog(context),
              userType,
              isPremiumOnly: true,
            ),
            const SizedBox(height: 24),

            // Device Information
            _buildSectionHeader(context, theme, isDark, 'Device Information'),
            const SizedBox(height: 16),
            _buildDeviceInfoCard(context, theme, isDark),
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

  Widget _buildWarningCard(BuildContext context, ThemeData theme, bool isDark) {
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
                      const Color(0xFF7F1D1D).withAlpha((0.8 * 255).toInt()),
                      const Color(0xFF991B1B).withAlpha((0.6 * 255).toInt()),
                    ]
                    : [const Color(0xFFFEF2F2), const Color(0xFFFEE2E2)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFEF4444).withAlpha((0.3 * 255).toInt()),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFEF4444),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Warning',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Resetting your device will permanently delete data and settings. Make sure to backup any important information before proceeding.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white70 : const Color(0xFF64748B),
              ),
            ),
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
                    const Color(0xFF1E293B).withAlpha((0.6 * 255).toInt()),
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

  Widget _buildResetCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    String title,
    String subtitle,
    String description,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                                    isDark
                                        ? Colors.white
                                        : const Color(0xFF1E293B),
                              ),
                            ),
                            if (isPremiumOnly &&
                                userType != UserType.premium) ...[
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
              const SizedBox(height: 12),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceInfoCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.primaryBlue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Device Information',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Device Model', 'Caredify Health Watch Pro'),
            _buildInfoRow('Firmware Version', 'v2.1.4'),
            _buildInfoRow('Serial Number', 'CF-2024-001234'),
            _buildInfoRow('Last Reset', 'Never'),
            _buildInfoRow('Storage Used', '2.4 GB / 8 GB'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
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
                      const Color(0xFF334155).withAlpha((0.6 * 255).toInt()),
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
                  'Premium Reset Features',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Advanced reset options including data reset and factory reset with detailed device information and backup options.',
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
                      const Color(0xFF334155).withAlpha((0.6 * 255).toInt()),
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
                  'Upgrade for Advanced Reset',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Unlock advanced reset options including data reset and factory reset with detailed device information.',
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

  void _showSettingsResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Reset Settings'),
            content: const Text(
              'This will reset all app settings to their default values. Your data will be preserved. Are you sure you want to continue?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _performSettingsReset();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Reset Settings'),
              ),
            ],
          ),
    );
  }

  void _showDataResetDialog(BuildContext context) {
    final userType = ref.read(userTypeProvider);
    if (userType != UserType.premium) {
      _showUpgradeDialog(context);
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Reset Data'),
            content: const Text(
              'This will permanently delete all your health data, activity history, and personal information. This action cannot be undone. Are you absolutely sure?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _performDataReset();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Reset Data'),
              ),
            ],
          ),
    );
  }

  void _showFactoryResetDialog(BuildContext context) {
    final userType = ref.read(userTypeProvider);
    if (userType != UserType.premium) {
      _showUpgradeDialog(context);
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Factory Reset'),
            content: const Text(
              'This will completely reset the device to factory settings. All data, settings, and configurations will be permanently deleted. This action cannot be undone. Are you absolutely sure?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _performFactoryReset();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Factory Reset'),
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
                  'This feature is only available for Premium users. Upgrade to unlock advanced reset options.',
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

  Future<void> _performSettingsReset() async {

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings reset successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to reset settings: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
      }
    }
  }

  Future<void> _performDataReset() async {

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 3));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data reset successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to reset data: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
      }
    }
  }

  Future<void> _performFactoryReset() async {

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 5));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Factory reset completed!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to perform factory reset: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
      }
    }
  }
}
