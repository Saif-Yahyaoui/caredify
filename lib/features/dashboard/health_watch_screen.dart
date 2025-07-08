import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/custom_button.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_tts/flutter_tts.dart';
import '../../providers/voice_feedback_provider.dart';

class HealthWatchScreen extends ConsumerStatefulWidget {
  const HealthWatchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HealthWatchScreen> createState() => _HealthWatchScreenState();
}

class _HealthWatchScreenState extends ConsumerState<HealthWatchScreen> {
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final voiceFeedbackEnabled = ref.read(voiceFeedbackProvider);
      if (voiceFeedbackEnabled) {
        try {
          var result = await _tts.setLanguage(
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
            'The watch is disconnected. Please make sure to wear your watch and connect it to the app.',
          );
        } catch (e) {}
      }
    });
  }

  @override
  void dispose() {
    _tts.stop();
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
                    color: const Color(0xFF7ED6D6), // close to screenshot color
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.watch_off, size: 40, color: Colors.white),
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
                            const SizedBox(height: 12),
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
                const SizedBox(height: 32),
                // Placeholder for connection controls
                Center(
                  child: Text(
                    'Connection controls go here',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
