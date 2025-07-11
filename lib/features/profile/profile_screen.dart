import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_tts/flutter_tts.dart';
import '../../providers/voice_feedback_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final voiceFeedbackEnabled = ref.read(voiceFeedbackProvider);
      if (voiceFeedbackEnabled) {
        await _tts.speak(
          'Profile screen. The watch is disconnected. Please make sure to wear your watch and connect it to the app.',
        );
      }
    });
  }

  @override
  void dispose() {
    _tts.stop();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final isRtl = intl.Bidi.isRtlLanguage(locale.languageCode);
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Watch disconnected banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.watch_off,
                        size: 40,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'The watch is disconnected !',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Please make sure to wear your watch and connect it to the app',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: double.infinity,
                              child: CustomButton.secondary(
                                text: 'CLICK HERE TO CONNECT',
                                onPressed: () {},
                                icon: Icons.bluetooth_connected,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Search bar
                CustomTextField(
                  controller: _searchController,
                  hint: 'SEARCH...',
                  prefixIcon: Icons.search,
                ),
                const SizedBox(height: 16),
                // Settings list
                const _ProfileOption(
                  icon: Icons.person,
                  label: 'Account Settings',
                ),
                const _ProfileOption(
                  icon: Icons.notifications,
                  label: 'Notification',
                ),
                const _ProfileOption(
                  icon: Icons.message,
                  label: 'Message Push',
                ),
                const _ProfileOption(
                  icon: Icons.restart_alt,
                  label: 'Reset device',
                ),
                const _ProfileOption(icon: Icons.delete, label: 'Remove'),
                const _ProfileOption(icon: Icons.more_horiz, label: 'Other'),
                const _ProfileOption(
                  icon: Icons.camera_alt,
                  label: 'Remote Shutter',
                ),
                const _ProfileOption(
                  icon: Icons.system_update,
                  label: 'OTA upgrade',
                ),
                // Accessibility option
                _ProfileOption(
                  icon: Icons.accessibility_new,
                  label: 'Accessibility Controls',
                  onTap: () => context.push('/accessibility-settings'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ProfileOption({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(label, style: theme.textTheme.bodyLarge),
        onTap: onTap ?? () {},
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
