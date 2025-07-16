import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/user_type_provider.dart';
import '../../../shared/services/auth_service.dart';
import '../../../shared/widgets/custom_text_field.dart';

class SecuritySettingsScreen extends ConsumerStatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  ConsumerState<SecuritySettingsScreen> createState() =>
      _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState
    extends ConsumerState<SecuritySettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _twoFactorEnabled = false;
  bool _biometricEnabled = false;
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userType = ref.watch(userTypeProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Settings'),
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
            // Password Change Section
            _buildSectionCard(
              context,
              theme,
              isDark,
              'Change Password',
              'Update your account password',
              Icons.lock_outline,
              const Color(0xFFEF4444),
              () => _showPasswordChangeDialog(context),
            ),
            const SizedBox(height: 16),

            // Two-Factor Authentication
            _buildSectionCard(
              context,
              theme,
              isDark,
              'Two-Factor Authentication',
              'Add an extra layer of security',
              Icons.security,
              const Color(0xFF3B82F6),
              () => _showTwoFactorDialog(context),
              trailing: Switch(
                value: _twoFactorEnabled,
                onChanged:
                    userType == UserType.premium
                        ? (value) => setState(() => _twoFactorEnabled = value)
                        : null,
              ),
            ),
            const SizedBox(height: 16),

            // Biometric Authentication
            _buildSectionCard(
              context,
              theme,
              isDark,
              'Biometric Authentication',
              'Use fingerprint or face recognition',
              Icons.fingerprint,
              const Color(0xFF10B981),
              () => _showBiometricDialog(context),
              trailing: Switch(
                value: _biometricEnabled,
                onChanged:
                    userType == UserType.premium
                        ? (value) => setState(() => _biometricEnabled = value)
                        : null,
              ),
            ),
            const SizedBox(height: 16),

            // Login History
            _buildSectionCard(
              context,
              theme,
              isDark,
              'Login History',
              'View recent login activity',
              Icons.history,
              const Color(0xFF8B5CF6),
              () => _showLoginHistory(context),
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

  Widget _buildSectionCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    Widget? trailing,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
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
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
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
              if (trailing != null)
                trailing
              else
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
                  'Premium Security Features',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Advanced security options including biometric authentication, detailed login history, and enhanced 2FA.',
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
                  'Upgrade for Advanced Security',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Unlock biometric authentication, detailed login history, and enhanced two-factor authentication.',
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

  void _showPasswordChangeDialog(BuildContext context) {
    final userType = ref.read(userTypeProvider);
    if (userType != UserType.premium) {
      _showUpgradeDialog(context);
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Change Password'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(
                    controller: _currentPasswordController,
                    label: 'Current Password',
                    hint: 'Enter current password',
                    prefixIcon: Icons.lock,
                    obscureText: !_showCurrentPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showCurrentPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed:
                          () => setState(
                            () => _showCurrentPassword = !_showCurrentPassword,
                          ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter current password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _newPasswordController,
                    label: 'New Password',
                    hint: 'Enter new password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: !_showNewPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showNewPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed:
                          () => setState(
                            () => _showNewPassword = !_showNewPassword,
                          ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter new password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    hint: 'Confirm new password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: !_showConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed:
                          () => setState(
                            () => _showConfirmPassword = !_showConfirmPassword,
                          ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm password';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _changePassword,
                child:
                    _isLoading
                        ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Text('Change Password'),
              ),
            ],
          ),
    );
  }

  void _showTwoFactorDialog(BuildContext context) {
    final userType = ref.read(userTypeProvider);
    if (userType != UserType.premium) {
      _showUpgradeDialog(context);
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Two-Factor Authentication'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.security, size: 48, color: AppColors.primaryBlue),
                const SizedBox(height: 16),
                const Text(
                  'Add an extra layer of security to your account by enabling two-factor authentication.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Enable 2FA'),
                  subtitle: const Text('Use authenticator app or SMS'),
                  value: _twoFactorEnabled,
                  onChanged: (value) {
                    setState(() => _twoFactorEnabled = value);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  void _showBiometricDialog(BuildContext context) {
    final userType = ref.read(userTypeProvider);
    if (userType != UserType.premium) {
      _showUpgradeDialog(context);
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Biometric Authentication'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.fingerprint, size: 48, color: AppColors.primaryBlue),
                const SizedBox(height: 16),
                const Text(
                  'Use your fingerprint or face recognition to quickly and securely access your account.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Enable Biometric'),
                  subtitle: const Text('Use fingerprint or face ID'),
                  value: _biometricEnabled,
                  onChanged: (value) {
                    setState(() => _biometricEnabled = value);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  void _showLoginHistory(BuildContext context) {
    final userType = ref.read(userTypeProvider);
    if (userType != UserType.premium) {
      _showUpgradeDialog(context);
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Login History'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLoginHistoryItem(
                    'iPhone 14 Pro',
                    'New York, NY',
                    '2 minutes ago',
                    true,
                  ),
                  _buildLoginHistoryItem(
                    'MacBook Pro',
                    'San Francisco, CA',
                    '1 hour ago',
                    false,
                  ),
                  _buildLoginHistoryItem(
                    'iPhone 13',
                    'Los Angeles, CA',
                    '2 days ago',
                    false,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  Widget _buildLoginHistoryItem(
    String device,
    String location,
    String time,
    bool isCurrent,
  ) {
    return ListTile(
      leading: Icon(
        isCurrent ? Icons.phone_android : Icons.computer,
        color: isCurrent ? AppColors.primaryBlue : Colors.grey,
      ),
      title: Text(device),
      subtitle: Text('$location • $time'),
      trailing:
          isCurrent
              ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Current',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
              : null,
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
                  'This feature is only available for Premium users. Upgrade to unlock advanced security features.',
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

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password changed successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to change password: ${e.toString()}'),
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
