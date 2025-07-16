import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/user_type_provider.dart';
import '../../../shared/services/auth_service.dart';

class PrivacySettingsScreen extends ConsumerStatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  ConsumerState<PrivacySettingsScreen> createState() =>
      _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends ConsumerState<PrivacySettingsScreen> {
  bool _dataSharingEnabled = true;
  bool _analyticsEnabled = true;
  bool _marketingEmailsEnabled = false;
  bool _healthDataSharingEnabled = false;
  bool _locationSharingEnabled = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final userType = ref.watch(userTypeProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
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
              onPressed: _savePrivacySettings,
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
            // Data Sharing Section
            _buildSectionHeader(context, theme, isDark, 'Data Sharing'),
            const SizedBox(height: 16),
            _buildPrivacyCard(
              context,
              theme,
              isDark,
              'Data Sharing',
              'Allow sharing of anonymized data for app improvement',
              Icons.share,
              const Color(0xFF3B82F6),
              _dataSharingEnabled,
              (value) => setState(() => _dataSharingEnabled = value),
              userType,
            ),
            const SizedBox(height: 16),
            _buildPrivacyCard(
              context,
              theme,
              isDark,
              'Analytics',
              'Help improve the app with usage analytics',
              Icons.analytics,
              const Color(0xFF10B981),
              _analyticsEnabled,
              (value) => setState(() => _analyticsEnabled = value),
              userType,
            ),
            const SizedBox(height: 24),

            // Communication Section
            _buildSectionHeader(context, theme, isDark, 'Communication'),
            const SizedBox(height: 16),
            _buildPrivacyCard(
              context,
              theme,
              isDark,
              'Marketing Emails',
              'Receive promotional emails and updates',
              Icons.email,
              const Color(0xFF8B5CF6),
              _marketingEmailsEnabled,
              (value) => setState(() => _marketingEmailsEnabled = value),
              userType,
            ),
            const SizedBox(height: 24),

            // Health Data Section
            _buildSectionHeader(context, theme, isDark, 'Health Data'),
            const SizedBox(height: 16),
            _buildPrivacyCard(
              context,
              theme,
              isDark,
              'Health Data Sharing',
              'Share health data with healthcare providers',
              Icons.health_and_safety,
              const Color(0xFFEF4444),
              _healthDataSharingEnabled,
              (value) => setState(() => _healthDataSharingEnabled = value),
              userType,
              isPremiumOnly: true,
            ),
            const SizedBox(height: 16),
            _buildPrivacyCard(
              context,
              theme,
              isDark,
              'Location Sharing',
              'Share location for emergency services',
              Icons.location_on,
              const Color(0xFFF59E0B),
              _locationSharingEnabled,
              (value) => setState(() => _locationSharingEnabled = value),
              userType,
              isPremiumOnly: true,
            ),
            const SizedBox(height: 24),

            // Data Management Section
            _buildSectionHeader(context, theme, isDark, 'Data Management'),
            const SizedBox(height: 16),
            _buildActionCard(
              context,
              theme,
              isDark,
              'Download My Data',
              'Get a copy of all your data',
              Icons.download,
              const Color(0xFF3B82F6),
              () => _downloadData(context),
              userType,
              isPremiumOnly: true,
            ),
            const SizedBox(height: 16),
            _buildActionCard(
              context,
              theme,
              isDark,
              'Delete My Data',
              'Permanently delete all your data',
              Icons.delete_forever,
              const Color(0xFFEF4444),
              () => _showDeleteDataDialog(context),
              userType,
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

  Widget _buildPrivacyCard(
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
                  'Premium Privacy Features',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Advanced privacy controls, health data sharing options, location services, and comprehensive data management.',
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
                  'Upgrade for Advanced Privacy',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Unlock advanced privacy controls, health data sharing, location services, and comprehensive data management.',
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

  void _downloadData(BuildContext context) {
    final userType = ref.read(userTypeProvider);
    if (userType != UserType.premium) {
      _showUpgradeDialog(context);
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Download Data'),
            content: const Text(
              'Your data will be prepared for download. You will receive an email when it\'s ready.',
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
                      content: Text(
                        'Data download initiated. Check your email.',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text('Download'),
              ),
            ],
          ),
    );
  }

  void _showDeleteDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete All Data'),
            content: const Text(
              'This action cannot be undone. All your data will be permanently deleted from our servers.',
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
                      content: Text('Data deletion initiated.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Delete'),
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
                  'This feature is only available for Premium users. Upgrade to unlock advanced privacy controls.',
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

  Future<void> _savePrivacySettings() async {
    setState(() => _isLoading = true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Privacy settings updated successfully!'),
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
