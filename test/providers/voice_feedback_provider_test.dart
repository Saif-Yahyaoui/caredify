import 'package:caredify/shared/providers/voice_feedback_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('VoiceFeedbackProvider Tests', () {
    test('VoiceFeedbackProvider toggles', () {
      final ProviderContainer container = TestSetup.createTestContainer();
      expect(container.read(voiceFeedbackProvider), true);
      container.read(voiceFeedbackProvider.notifier).state = false;
      expect(container.read(voiceFeedbackProvider), false);
    });
  });
}
