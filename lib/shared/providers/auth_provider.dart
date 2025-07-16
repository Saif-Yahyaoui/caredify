import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider<IAuthService>((ref) => AuthService());

// Authentication state provider
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((
  ref,
) {
  return AuthStateNotifier(ref.read(authServiceProvider));
});

// Authentication state
class AuthState {
  final bool isLoggedIn;
  final UserType userType;
  final bool isLoading;

  const AuthState({
    this.isLoggedIn = false,
    this.userType = UserType.none,
    this.isLoading = false,
  });

  AuthState copyWith({bool? isLoggedIn, UserType? userType, bool? isLoading}) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      userType: userType ?? this.userType,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Authentication state notifier
class AuthStateNotifier extends StateNotifier<AuthState> {
  final IAuthService _authService;

  AuthStateNotifier(this._authService) : super(const AuthState()) {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    debugPrint('AuthProvider: Initializing auth state');
    state = state.copyWith(isLoading: true);

    // Check if user is logged in
    final isLoggedIn = _authService.isLoggedIn;
    final userType = _authService.currentUserType;

    debugPrint('AuthProvider: isLoggedIn = $isLoggedIn, userType = $userType');

    state = state.copyWith(
      isLoggedIn: isLoggedIn,
      userType: userType,
      isLoading: false,
    );

    debugPrint('AuthProvider: Auth state initialized');
  }

  Future<void> login(String phone, String password) async {
    state = state.copyWith(isLoading: true);

    try {
      final userType = await _authService.loginWithCredentials(phone, password);
      state = state.copyWith(
        isLoggedIn: userType != UserType.none,
        userType: userType,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _authService.signOut();
      state = state.copyWith(
        isLoggedIn: false,
        userType: UserType.none,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> upgradeToPremium() async {
    state = state.copyWith(isLoading: true);

    try {
      // Simulate upgrade process
      await Future.delayed(const Duration(seconds: 1));

      // Update user type to premium
      state = state.copyWith(userType: UserType.premium, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }
}
