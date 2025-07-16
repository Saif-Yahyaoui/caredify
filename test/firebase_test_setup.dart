import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

class TestFirebaseOptions {
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'test-api-key',
    appId: 'test-app-id',
    messagingSenderId: 'test-sender-id',
    projectId: 'test-project-id',
    storageBucket: 'test-project-id.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'test-api-key',
    appId: 'test-app-id',
    messagingSenderId: 'test-sender-id',
    projectId: 'test-project-id',
    storageBucket: 'test-project-id.appspot.com',
    iosBundleId: 'com.example.caredify',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'test-api-key',
    appId: 'test-app-id',
    messagingSenderId: 'test-sender-id',
    projectId: 'test-project-id',
    authDomain: 'test-project-id.firebaseapp.com',
    storageBucket: 'test-project-id.appspot.com',
  );
}

/// Setup Firebase mocks for testing
Future<void> setupFirebaseMocks() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with test options
  try {
    await Firebase.initializeApp(options: TestFirebaseOptions.android);
  } catch (e) {
    // Firebase might already be initialized
    if (!e.toString().contains('duplicate-app')) {
      // For tests, we can ignore Firebase initialization errors
      debugPrint('Firebase setup error (ignored in tests): $e');
    }
  }
}

/// Mock Firebase app for testing
class MockFirebaseApp {
  static Future<void> initialize() async {
    // This is a mock implementation for testing
    await Future.delayed(const Duration(milliseconds: 10));
  }
}
