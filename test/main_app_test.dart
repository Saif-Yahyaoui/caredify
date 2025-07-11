import 'package:flutter_test/flutter_test.dart';
import 'package:caredify/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('CaredifyApp renders without crashing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: CaredifyApp()));
    await tester.pumpAndSettle();
    expect(find.byType(CaredifyApp), findsOneWidget);
  });
}
