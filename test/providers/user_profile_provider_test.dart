import 'package:caredify/shared/providers/user_profile_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('UserProfileProvider Tests', () {
    test('UserProfileProvider has default values', () {
      final notifier = UserProfileNotifier();
      final profile = notifier.state;
      expect(profile.age, 25);
      expect(profile.gender, 'Male');
    });
  });
}
