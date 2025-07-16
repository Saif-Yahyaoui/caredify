import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/user_type_provider.dart';
import '../../../shared/services/auth_service.dart';

class RemoteShutterScreen extends ConsumerStatefulWidget {
  const RemoteShutterScreen({super.key});

  @override
  ConsumerState<RemoteShutterScreen> createState() =>
      _RemoteShutterScreenState();
}

class _RemoteShutterScreenState extends ConsumerState<RemoteShutterScreen> {
  bool _isLoading = false;
  bool _remoteShutterEnabled = true;
  bool _cameraConnected = false;
  double _shutterDelay = 3.0;
  bool _burstModeEnabled = false;
  int _burstCount = 3;
  bool _autoFocusEnabled = true;
  bool _flashEnabled = false;
  String _selectedResolution = '4K';

  @override
  Widget build(BuildContext context) {
    final userType = ref.watch(userTypeProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Shutter'),
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
              onPressed: _saveSettings,
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
            // Connection Status
            _buildConnectionStatusCard(context, theme, isDark),
            const SizedBox(height: 24),

            // Basic Settings
            _buildSectionHeader(context, theme, isDark, 'Basic Settings'),
            const SizedBox(height: 16),
            _buildSettingCard(
              context,
              theme,
              isDark,
              'Remote Shutter',
              'Enable remote camera control',
              Icons.camera_alt,
              const Color(0xFF3B82F6),
              _remoteShutterEnabled,
              (value) => setState(() => _remoteShutterEnabled = value),
              userType,
            ),
            const SizedBox(height: 16),
            _buildSettingCard(
              context,
              theme,
              isDark,
              'Auto Focus',
              'Enable automatic focus',
              Icons.center_focus_strong,
              const Color(0xFF10B981),
              _autoFocusEnabled,
              (value) => setState(() => _autoFocusEnabled = value),
              userType,
            ),
            const SizedBox(height: 16),
            _buildSettingCard(
              context,
              theme,
              isDark,
              'Flash',
              'Enable camera flash',
              Icons.flash_on,
              const Color(0xFFFFD700),
              _flashEnabled,
              (value) => setState(() => _flashEnabled = value),
              userType,
            ),
            const SizedBox(height: 24),

            // Advanced Settings
            _buildSectionHeader(context, theme, isDark, 'Advanced Settings'),
            const SizedBox(height: 16),
            _buildSliderCard(
              context,
              theme,
              isDark,
              'Shutter Delay',
              'Delay before taking photo (${_shutterDelay.toInt()}s)',
              Icons.timer,
              const Color(0xFF8B5CF6),
              _shutterDelay,
              0.0,
              10.0,
              (value) => setState(() => _shutterDelay = value),
              userType,
              isPremiumOnly: true,
            ),
            const SizedBox(height: 16),
            _buildSettingCard(
              context,
              theme,
              isDark,
              'Burst Mode',
              'Take multiple photos rapidly',
              Icons.burst_mode,
              const Color(0xFFEF4444),
              _burstModeEnabled,
              (value) => setState(() => _burstModeEnabled = value),
              userType,
              isPremiumOnly: true,
            ),
            if (_burstModeEnabled) ...[
              const SizedBox(height: 16),
              _buildSliderCard(
                context,
                theme,
                isDark,
                'Burst Count',
                'Number of photos ($_burstCount)',
                Icons.photo_library,
                const Color(0xFF06B6D4),
                _burstCount.toDouble(),
                2.0,
                10.0,
                (value) => setState(() => _burstCount = value.toInt()),
                userType,
                isPremiumOnly: true,
              ),
            ],
            const SizedBox(height: 24),

            // Camera Settings
            _buildSectionHeader(context, theme, isDark, 'Camera Settings'),
            const SizedBox(height: 16),
            _buildResolutionCard(context, theme, isDark),
            const SizedBox(height: 24),

            // Test Camera
            _buildTestCameraCard(context, theme, isDark),
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

  Widget _buildConnectionStatusCard(
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
                _cameraConnected
                    ? (isDark
                        ? [
                          const Color(
                            0xFF064E3B,
                          ).withAlpha((0.8 * 255).toInt()),
                          const Color(
                            0xFF065F46,
                          ).withAlpha((0.5 * 255).toInt()),
                        ]
                        : [const Color(0xFFF0FDF4), const Color(0xFFDCFCE7)])
                    : (isDark
                        ? [
                          const Color(
                            0xFF7F1D1D,
                          ).withAlpha((0.8 * 255).toInt()),
                          const Color(
                            0xFF991B1B,
                          ).withAlpha((0.5 * 255).toInt()),
                        ]
                        : [const Color(0xFFFEF2F2), const Color(0xFFFEE2E2)]),
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                _cameraConnected
                    ? const Color(0xFF10B981).withAlpha((0.3 * 255).toInt())
                    : const Color(0xFFEF4444).withAlpha((0.3 * 255).toInt()),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color:
                        _cameraConnected
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    _cameraConnected
                        ? Icons.camera_alt
                        : Icons.camera_alt_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _cameraConnected
                            ? 'Camera Connected'
                            : 'Camera Disconnected',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _cameraConnected
                            ? 'Remote shutter is ready to use'
                            : 'Connect to camera to enable remote shutter',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color:
                              isDark ? Colors.white70 : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _toggleCameraConnection(),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _cameraConnected
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _cameraConnected ? 'Disconnect Camera' : 'Connect Camera',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
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

  Widget _buildSettingCard(
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

  Widget _buildSliderCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
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
              ],
            ),
            const SizedBox(height: 16),
            Slider(
              value: value,
              min: min,
              max: max,
              divisions: (max - min).toInt(),
              onChanged: isEnabled ? onChanged : null,
              activeColor: color,
              inactiveColor: Colors.grey.withAlpha((0.3 * 255).toInt()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResolutionCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    final userType = ref.watch(userTypeProvider);
    final resolutions =
        userType == UserType.premium ? ['1080p', '4K', '8K'] : ['1080p'];

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
                  Icons.high_quality,
                  color: AppColors.primaryBlue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Resolution',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                if (userType != UserType.premium) ...[
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
            const SizedBox(height: 16),
            ...resolutions.map(
              (resolution) => RadioListTile<String>(
                title: Text(resolution),
                value: resolution,
                groupValue: _selectedResolution,
                onChanged:
                    userType == UserType.premium
                        ? (value) =>
                            setState(() => _selectedResolution = value!)
                        : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestCameraCard(
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
                const Icon(Icons.camera_alt, color: AppColors.primaryBlue, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Test Camera',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Test your remote shutter settings with a sample photo.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _cameraConnected ? _testCamera : null,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Take Test Photo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
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
                  'Premium Camera Features',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Advanced camera controls including shutter delay, burst mode, high-resolution options, and detailed camera settings.',
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
                  'Upgrade for Advanced Camera',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Unlock advanced camera controls including shutter delay, burst mode, high-resolution options, and detailed settings.',
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

  void _toggleCameraConnection() {
    setState(() {
      _cameraConnected = !_cameraConnected;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _cameraConnected ? 'Camera connected!' : 'Camera disconnected',
        ),
        backgroundColor: _cameraConnected ? Colors.green : Colors.orange,
      ),
    );
  }

  void _testCamera() {
    if (!_cameraConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please connect to camera first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Test photo taken successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _saveSettings() async {
    setState(() => _isLoading = true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera settings saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save settings: ${e.toString()}'),
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
