import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart' as intl;

import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/voice_feedback_provider.dart';
import '../../../shared/widgets/buttons/custom_button.dart';

class HealthWatchScreen extends ConsumerStatefulWidget {
  const HealthWatchScreen({super.key});

  @override
  ConsumerState<HealthWatchScreen> createState() => _HealthWatchScreenState();
}

class _HealthWatchScreenState extends ConsumerState<HealthWatchScreen>
    with TickerProviderStateMixin {
  final FlutterTts _tts = FlutterTts();
  late AnimationController _pulseController;
  late AnimationController _scanController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scanAnimation;

  bool _isConnected = false;
  bool _isConnecting = false;
  final int _batteryLevel = 85;
  final int _signalStrength = 4;
  DateTime? _lastSyncTime;
  final String _watchName = "Caredify Watch";
  final String _watchModel = "CW-2024";

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _scanController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final voiceFeedbackEnabled = ref.read(voiceFeedbackProvider);
      if (voiceFeedbackEnabled) {
        try {
          final result = await _tts.setLanguage(
            Localizations.localeOf(context).languageCode == 'ar'
                ? 'ar-SA'
                : Localizations.localeOf(context).languageCode == 'fr'
                ? 'fr-FR'
                : 'en-US',
          );
          if (result != 1) {
            await _tts.setLanguage('en-US');
          }
        } catch (e) {
          await _tts.setLanguage('en-US');
        }
        try {
          await _tts.speak(
            _isConnected
                ? 'Your watch is connected and ready to monitor your health.'
                : 'The watch is disconnected. Please connect your watch to start monitoring.',
          );
        } catch (e) {
          // Ignored: TTS error is non-critical
        }
      }
    });
  }

  @override
  void dispose() {
    _tts.stop();
    _pulseController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  void _toggleConnection() async {
    if (_isConnected) {
      _disconnectWatch();
    } else {
      _connectWatch();
    }
  }

  void _connectWatch() async {
    setState(() {
      _isConnecting = true;
    });

    _scanController.repeat();

    // Simulate connection process
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isConnected = true;
      _isConnecting = false;
      _lastSyncTime = DateTime.now();
    });

    _scanController.stop();
    _pulseController.repeat();

    // Update TTS
    final voiceFeedbackEnabled = ref.read(voiceFeedbackProvider);
    if (voiceFeedbackEnabled) {
      try {
        await _tts.speak('Watch connected successfully!');
      } catch (e) {
        // Ignored: TTS error is non-critical
      }
    }
  }

  void _disconnectWatch() async {
    setState(() {
      _isConnected = false;
      _lastSyncTime = null;
    });

    _pulseController.stop();

    // Update TTS
    final voiceFeedbackEnabled = ref.read(voiceFeedbackProvider);
    if (voiceFeedbackEnabled) {
      try {
        await _tts.speak('Watch disconnected.');
      } catch (e) {
        // Ignored: TTS error is non-critical
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final isRtl = intl.Bidi.isRtlLanguage(locale.languageCode);
    final isDark = theme.brightness == Brightness.dark;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Health Watch'),
          foregroundColor: theme.colorScheme.onSurface,
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Main Watch Status Card
                _buildWatchStatusCard(context, theme, isDark),
                const SizedBox(height: 24),

                // Watch Information Section
                if (_isConnected) ...[
                  _buildWatchInfoSection(context, theme, isDark),
                  const SizedBox(height: 24),
                ],

                // Connection Controls Section
                _buildConnectionControlsSection(context, theme, isDark),
                const SizedBox(height: 24),

                // Features Section
                _buildFeaturesSection(context, theme, isDark),
                const SizedBox(height: 24),

                // Troubleshooting Section
                _buildTroubleshootingSection(context, theme, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWatchStatusCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              _isConnected
                  ? [const Color(0xFF10B981), const Color(0xFF059669)]
                  : [const Color(0xFF7ED6D6), const Color(0xFF5BC0DE)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (_isConnected
                    ? const Color(0xFF10B981)
                    : const Color(0xFF7ED6D6))
                .withAlpha((0.3 * 255).toInt()),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Watch Icon with Animation
          AnimatedBuilder(
            animation: _isConnected ? _pulseAnimation : _scanAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _isConnected ? _pulseAnimation.value : 1.0,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha((0.2 * 255).toInt()),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(
                    _isConnected ? Icons.watch : Icons.watch_off,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Status Text
          Text(
            _isConnected ? 'Watch Connected!' : 'Watch Disconnected',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            _isConnected
                ? 'Your watch is actively monitoring your health'
                : 'Connect your watch to start monitoring',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withAlpha((0.9 * 255).toInt()),
            ),
            textAlign: TextAlign.center,
          ),

          if (_isConnected) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatusIndicator(
                  'Battery',
                  '$_batteryLevel%',
                  Icons.battery_full,
                ),
                _buildStatusIndicator(
                  'Signal',
                  '$_signalStrength/5',
                  Icons.signal_cellular_4_bar,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withAlpha((0.8 * 255).toInt()),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildWatchInfoSection(
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
                  'Watch Information',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Device Name', _watchName),
            _buildInfoRow('Model', _watchModel),
            _buildInfoRow('Battery Level', '$_batteryLevel%'),
            _buildInfoRow('Signal Strength', '$_signalStrength/5'),
            if (_lastSyncTime != null)
              _buildInfoRow(
                'Last Sync',
                intl.DateFormat('MMM dd, HH:mm').format(_lastSyncTime!),
              ),
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
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionControlsSection(
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
                  Icons.bluetooth,
                  color: AppColors.primaryBlue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Connection Controls',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text:
                    _isConnected
                        ? 'Disconnect Watch'
                        : _isConnecting
                        ? 'Connecting...'
                        : 'Connect Watch',
                onPressed: _isConnecting ? null : _toggleConnection,
                icon:
                    _isConnected
                        ? Icons.bluetooth_disabled
                        : Icons.bluetooth_connected,
                backgroundColor:
                    _isConnected ? Colors.red : AppColors.primaryBlue,
              ),
            ),
            if (_isConnecting) ...[
              const SizedBox(height: 16),
              const LinearProgressIndicator(),
              const SizedBox(height: 8),
              Text(
                'Searching for your watch...',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesSection(
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
                  Icons.featured_play_list,
                  color: AppColors.primaryBlue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Watch Features',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              'ECG Monitoring',
              'Real-time heart rhythm analysis',
              Icons.favorite,
            ),
            _buildFeatureItem(
              'Heart Rate',
              'Continuous heart rate tracking',
              Icons.monitor_heart,
            ),
            _buildFeatureItem(
              'Activity Tracking',
              'Steps, calories, and distance',
              Icons.directions_run,
            ),
            _buildFeatureItem(
              'Sleep Monitoring',
              'Sleep quality and duration',
              Icons.bedtime,
            ),
            _buildFeatureItem(
              'Notifications',
              'Health alerts and reminders',
              Icons.notifications,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withAlpha((0.1 * 255).toInt()),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primaryBlue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  description,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTroubleshootingSection(
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
                  Icons.help_outline,
                  color: AppColors.primaryBlue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Troubleshooting',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTroubleshootingItem(
              'Make sure your watch is turned on and within range',
              Icons.power_settings_new,
            ),
            _buildTroubleshootingItem(
              'Check that Bluetooth is enabled on your device',
              Icons.bluetooth,
            ),
            _buildTroubleshootingItem(
              'Ensure your watch is not connected to another device',
              Icons.devices,
            ),
            _buildTroubleshootingItem(
              'Try restarting both your watch and the app',
              Icons.refresh,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTroubleshootingItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
