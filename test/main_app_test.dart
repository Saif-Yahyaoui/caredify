import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:caredify/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('CaredifyApp renders without crashing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CaredifyApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.byType(CaredifyApp), findsOneWidget);
  });
}
