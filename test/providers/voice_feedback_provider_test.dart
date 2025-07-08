import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caredify/providers/voice_feedback_provider.dart';

void main() {
  test('VoiceFeedbackProvider toggles', () {
    final container = ProviderContainer();
    expect(container.read(voiceFeedbackProvider), true);
    container.read(voiceFeedbackProvider.notifier).state = false;
    expect(container.read(voiceFeedbackProvider), false);
  });
}
