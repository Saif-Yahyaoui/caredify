import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caredify/main.dart';

void main() {
  testWidgets('CaredifyApp renders without crashing', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: CaredifyApp()));
    await tester.pumpAndSettle();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
