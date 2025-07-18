import 'package:caredify/features/dashboard/screens/advanced_coach_ai_screen.dart';
import 'package:caredify/shared/providers/auth_provider.dart';
import 'package:caredify/shared/services/auth_service.dart';
import 'package:caredify/shared/widgets/navigation/premium_tabbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthService implements IAuthService {
  @override
  bool get isLoggedIn => true;
  @override
  UserType get currentUserType => UserType.premium;
  @override
  Future<void> signOut() async => throw UnimplementedError();
  @override
  Future<UserType> loginWithCredentials(String phone, String password) async =>
      UserType.premium;
  @override
  Future<UserCredential?> signInWithGoogle() async => null;
  @override
  Future<UserCredential?> signInWithFacebook() async => null;
  @override
  Future<bool> loginWithBiometrics(type, context) async =>
      throw UnimplementedError();
}

class TestAuthStateNotifier extends AuthStateNotifier {
  TestAuthStateNotifier() : super(FakeAuthService()) {
    state = const AuthState(isLoggedIn: true, userType: UserType.premium);
  }
}

Widget testableWidget(Widget child) {
  return ProviderScope(
    overrides: [
      authStateProvider.overrideWith((ref) => TestAuthStateNotifier()),
    ],
    child: MaterialApp(
      home: MediaQuery(
        data: const MediaQueryData(size: Size(1200, 2000)),
        child: child,
      ),
    ),
  );
}

void printAllTexts(WidgetTester tester) {
  final texts = find.byType(Text);
  for (final t in texts.evaluate()) {
    final widget = t.widget as Text;
    debugPrint('VISIBLE TEXT: "${widget.data}"');
  }
}

Finder findTabWithLabel(WidgetTester tester, String label) {
  final tabBar = find.byType(PremiumTabBar);
  final tab = find.descendant(of: tabBar, matching: find.text(label));
  if (tester.widgetList(tab).isEmpty) {
    debugPrint('DEBUG: No tab found for "$label". TabBar children:');
    for (final t in tabBar.evaluate()) {
      debugPrint('TABBAR WIDGET: \\${t.widget}');
    }
  }
  return tab;
}

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('renders and displays all tabs', (tester) async {
    await tester.pumpWidget(testableWidget(const AdvancedCoachAiScreen()));
    await tester.pumpAndSettle();
    printAllTexts(tester);
    final tabBar = find.byType(PremiumTabBar);
    expect(tabBar, findsOneWidget);
    final tabWidgets = find.descendant(
      of: tabBar,
      matching: find.byType(GestureDetector),
    );
    expect(tabWidgets, findsNWidgets(3)); // 3 tabs
  });

  testWidgets('switches between tabs and displays content', (tester) async {
    await tester.pumpWidget(testableWidget(const AdvancedCoachAiScreen()));
    await tester.pumpAndSettle();
    printAllTexts(tester);
    // Tab 1
    expect(find.textContaining('Your AI Health Coach'), findsOneWidget);
    // Tab 2
    final tabBar = find.byType(PremiumTabBar);
    final tabWidgets = find.descendant(
      of: tabBar,
      matching: find.byType(GestureDetector),
    );
    expect(tabWidgets, findsNWidgets(3));
    await tester.tap(tabWidgets.at(1)); // Tap Goals
    await tester.pumpAndSettle();
    printAllTexts(tester);
    expect(find.textContaining('Set New Goal'), findsOneWidget);
    // Tab 3
    await tester.tap(tabWidgets.at(2)); // Tap Progress
    await tester.pumpAndSettle();
    printAllTexts(tester);
    expect(find.textContaining('Progress Overview'), findsOneWidget);
  });
}
