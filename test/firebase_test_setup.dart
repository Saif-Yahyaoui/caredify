import 'package:firebase_core/firebase_core.dart';
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

void setupFirebaseMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with test options
  Firebase.initializeApp(options: TestFirebaseOptions.android);
}
