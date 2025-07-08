import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier()
    : super(
        UserProfile(
          age: 25,
          gender: 'Male',
          height: 177,
          weight: 65,
          bmi: 22.4,
          bodyFatRate: 18.4,
        ),
      );

  // Add update methods as needed
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>(
      (ref) => UserProfileNotifier(),
    );
