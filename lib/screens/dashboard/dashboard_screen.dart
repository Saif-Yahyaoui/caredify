import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/floating_bottom_nav_bar.dart';
import '../../widgets/accessibility_controls.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final FlutterTts _tts = FlutterTts();

  // Example: Replace with real health data provider
  final int healthScore = 0;
  final String ecgStatus = 'Average';
  final String bpmStatus = 'Low';
  final String spo2Status = 'High';
  final String tempStatus = 'Medium';

  @override
  void initState() {
    super.initState();
    if (AccessibilityControls.voiceFeedbackEnabled) {
      _speakTab(_selectedIndex);
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (AccessibilityControls.voiceFeedbackEnabled) {
      _speakTab(index);
    }
  }

  /// 🔈 Speak tab info in localized TTS voice
  Future<void> _speakTab(int index) async {
    final context = this.context;
    final t = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    // Detect language
    String ttsLang;
    switch (locale) {
      case 'ar':
        ttsLang = 'ar-SA';
        break;
      case 'fr':
        ttsLang = 'fr-FR';
        break;
      default:
        ttsLang = 'en-US';
    }
    await _tts.setLanguage(ttsLang);

    String message;
    switch (index) {
      case 0:
        message =
            '${t.dangerHealthScore.replaceAll('\n', ' ')}: $healthScore percent. '
            'ECG: $ecgStatus, BPM: $bpmStatus, SPO2: $spo2Status, ${t.temperature}: $tempStatus.';
        break;
      case 1:
        message = t.chatTab; // Localize if you add keys
        break;
      case 2:
        message = t.appointmentsTab; // Localize if you add keys
        break;
      case 3:
        message = t.profileTab; // Localize if you add keys
        break;
      default:
        message = '';
    }

    await _tts.speak(message);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 90),
              child: _tabContents[_selectedIndex],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: FloatingBottomNavBar(
                  selectedIndex: _selectedIndex,
                  onTabSelected: _onTabSelected,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> get _tabContents => [
        _DashboardHome(
          healthScore: healthScore,
          ecgStatus: ecgStatus,
          bpmStatus: bpmStatus,
          spo2Status: spo2Status,
          tempStatus: tempStatus,
        ),
        Center(child: Text('Chat')), // Placeholder
        Center(child: Text('Appointments')), // Placeholder
        Center(child: Text('Profile')), // Placeholder
      ];
}

class _DashboardHome extends StatelessWidget {
  final int healthScore;
  final String ecgStatus;
  final String bpmStatus;
  final String spo2Status;
  final String tempStatus;

  const _DashboardHome({
    required this.healthScore,
    required this.ecgStatus,
    required this.bpmStatus,
    required this.spo2Status,
    required this.tempStatus,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Center(
          child: Column(
            children: [
              Text(
                t.dangerHealthScore,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.alertRed,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '$healthScore%',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppColors.alertRed,
                      fontWeight: FontWeight.bold,
                      fontSize: 48,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _VitalsCard(
                icon: Icons.monitor_heart,
                label: 'ECG',
                value: ecgStatus,
                change: '+8% from yesterday',
                color: AppColors.primaryBlue,
              ),
              _VitalsCard(
                icon: Icons.favorite,
                label: 'BPM',
                value: bpmStatus,
                change: '-11% from yesterday',
                color: AppColors.alertRed,
              ),
              _VitalsCard(
                icon: Icons.bloodtype,
                label: 'SPO2',
                value: spo2Status,
                change: '+6% from yesterday',
                color: Colors.purple,
              ),
              _VitalsCard(
                icon: Icons.thermostat,
                label: t.temperature,
                value: tempStatus,
                change: '+4% from yesterday',
                color: AppColors.healthGreen,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VitalsCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String change;
  final Color color;

  const _VitalsCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.change,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 36),
            const SizedBox(height: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              change,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primaryBlue,
                    fontSize: 14,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
