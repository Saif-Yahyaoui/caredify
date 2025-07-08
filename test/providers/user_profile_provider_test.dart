import 'package:flutter_test/flutter_test.dart';
import 'package:caredify/providers/user_profile_provider.dart';

void main() {
  test('UserProfileProvider has default values', () {
    final notifier = UserProfileNotifier();
    final profile = notifier.state;
    expect(profile.age, 25);
    expect(profile.gender, 'Male');
  });
}
