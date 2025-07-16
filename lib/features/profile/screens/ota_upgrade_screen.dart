import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/user_type_provider.dart';
import '../../../shared/services/auth_service.dart';

class OTAUpgradeScreen extends ConsumerStatefulWidget {
  const OTAUpgradeScreen({super.key});

  @override
  ConsumerState<OTAUpgradeScreen> createState() => _OTAUpgradeScreenState();
}

class _OTAUpgradeScreenState extends ConsumerState<OTAUpgradeScreen> {
  bool _isCheckingUpdate = false;
  bool _isDownloading = false;
  bool _isInstalling = false;
  double _downloadProgress = 0.0;
  double _installProgress = 0.0;
  String _currentVersion = 'v2.1.4';
  String _latestVersion = 'v2.2.0';
  bool _updateAvailable = false;
  String _updateSize = '15.2 MB';
  String _updateDescription = 'Bug fixes and performance improvements';
  List<Map<String, String>> _updateHistory = [];

  @override
  void initState() {
    super.initState();
    _loadUpdateHistory();
  }

  @override
  Widget build(BuildContext context) {
    final userType = ref.watch(userTypeProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('OTA Upgrade'),
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
            IconButton(
              onPressed: _checkForUpdates,
              icon:
                  _isCheckingUpdate
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Icon(Icons.refresh),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current Version Status
            _buildCurrentVersionCard(context, theme, isDark),
            const SizedBox(height: 24),

            // Update Status
            if (_updateAvailable)
              _buildUpdateAvailableCard(context, theme, isDark),
            if (_updateAvailable) const SizedBox(height: 24),

            // Update Progress
            if (_isDownloading || _isInstalling)
              _buildProgressCard(context, theme, isDark),
            if (_isDownloading || _isInstalling) const SizedBox(height: 24),

            // Update Actions
            _buildUpdateActionsCard(context, theme, isDark),
            const SizedBox(height: 24),

            // Update History
            _buildUpdateHistoryCard(context, theme, isDark),
            const SizedBox(height: 24),

            // Device Information
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

  Widget _buildCurrentVersionCard(
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
                    : [const Color(0xFFF8FAFC), const Color(0xFFF1F5F9)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryBlue.withAlpha((0.3 * 255).toInt()),
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
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primaryBlue,
                        AppColors.primaryBlue.withAlpha((0.8 * 255).toInt()),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryBlue.withAlpha(
                          (0.3 * 255).toInt(),
                        ),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.system_update,
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
                        'Current Version',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _currentVersion,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Text(
                  'System is up to date',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateAvailableCard(
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
                      const Color(0xFF064E3B).withAlpha((0.8 * 255).toInt()),
                      const Color(0xFF065F46).withAlpha((0.6 * 255).toInt()),
                    ]
                    : [const Color(0xFFF0FDF4), const Color(0xFFDCFCE7)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF10B981).withAlpha((0.3 * 255).toInt()),
            width: 1,
          ),
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
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF10B981),
                        Color(0xFF059669),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFF10B981,
                        ).withAlpha((0.3 * 255).toInt()),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.new_releases,
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
                        'Update Available',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Version $_latestVersion',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _updateDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white70 : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.download, color: Color(0xFF10B981), size: 16),
                const SizedBox(width: 4),
                Text(
                  'Size: $_updateSize',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF10B981),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(
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
                Icon(
                  _isDownloading ? Icons.download : Icons.install_desktop,
                  color: AppColors.primaryBlue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  _isDownloading ? 'Downloading Update' : 'Installing Update',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: _isDownloading ? _downloadProgress : _installProgress,
              backgroundColor: Colors.grey.withAlpha((0.3 * 255).toInt()),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
            ),
            const SizedBox(height: 8),
            Text(
              '${((_isDownloading ? _downloadProgress : _installProgress) * 100).toInt()}%',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),
            if (_isDownloading) ...[
              const SizedBox(height: 8),
              Text(
                'Please keep your device connected and do not turn it off.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateActionsCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    final userType = ref.watch(userTypeProvider);

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
                const Icon(Icons.settings, color: AppColors.primaryBlue, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Update Actions',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (userType == UserType.premium) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed:
                      _updateAvailable && !_isDownloading && !_isInstalling
                          ? _startUpdate
                          : null,
                  icon: const Icon(Icons.system_update),
                  label: const Text('Download & Install Update'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _checkForUpdates,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Check for Updates'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryBlue,
                    side: const BorderSide(color: AppColors.primaryBlue),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha((0.1 * 255).toInt()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.lock, color: Colors.grey, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'Premium Feature',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Upgrade to Premium to access automatic updates and advanced firmware features.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateHistoryCard(
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
                const Icon(Icons.history, color: AppColors.primaryBlue, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Update History',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_updateHistory.isEmpty)
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.history, color: Colors.grey, size: 48),
                    const SizedBox(height: 8),
                    Text(
                      'No update history',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...(_updateHistory.map(
                (update) =>
                    _buildUpdateHistoryItem(context, theme, isDark, update),
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateHistoryItem(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    Map<String, String> update,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            isDark
                ? Colors.grey.withAlpha((0.1 * 255).toInt())
                : Colors.grey.withAlpha((0.05 * 255).toInt()),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withAlpha((0.1 * 255).toInt()),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.system_update,
              color: AppColors.primaryBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  update['version'] ?? '',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  update['date'] ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
        ],
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
            _buildInfoRow('Current Version', _currentVersion),
            _buildInfoRow('Build Number', '2024.1.4.1234'),
            _buildInfoRow('Last Update', '2024-01-15'),
            _buildInfoRow('Update Channel', 'Stable'),
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
                  'Premium Update Features',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Automatic updates, update history, advanced firmware features, and priority update notifications.',
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
                  'Upgrade for Advanced Updates',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Unlock automatic updates, update history, advanced firmware features, and priority update notifications.',
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

  void _loadUpdateHistory() {
    _updateHistory = [
      {'version': 'v2.1.4', 'date': '2024-01-15'},
      {'version': 'v2.1.3', 'date': '2024-01-10'},
      {'version': 'v2.1.2', 'date': '2024-01-05'},
    ];
  }

  Future<void> _checkForUpdates() async {
    setState(() => _isCheckingUpdate = true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      setState(() {
        _updateAvailable = true;
        _latestVersion = 'v2.2.0';
        _updateSize = '15.2 MB';
        _updateDescription = 'Bug fixes and performance improvements';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Update check completed!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to check for updates: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isCheckingUpdate = false);
      }
    }
  }

  Future<void> _startUpdate() async {
    setState(() => _isDownloading = true);

    try {
      // Simulate download
      for (int i = 0; i <= 100; i++) {
        await Future.delayed(const Duration(milliseconds: 50));
        if (!mounted) return;
        setState(() => _downloadProgress = i / 100);
      }

      setState(() {
        _isDownloading = false;
        _isInstalling = true;
        _installProgress = 0.0;
      });

      // Simulate installation
      for (int i = 0; i <= 100; i++) {
        await Future.delayed(const Duration(milliseconds: 30));
        if (!mounted) return;
        setState(() => _installProgress = i / 100);
      }

      if (!mounted) return;

      setState(() {
        _isInstalling = false;
        _currentVersion = _latestVersion;
        _updateAvailable = false;
      });

      // Add to update history
      _updateHistory.insert(0, {
        'version': _latestVersion,
        'date': DateTime.now().toString().split(' ')[0],
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Update completed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isDownloading = false;
        _isInstalling = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Update failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
