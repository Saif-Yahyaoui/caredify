import 'package:caredify/features/auth/widgets/auth_floating_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthFloatingCard Widget Tests', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: AuthFloatingCard(child: Text('Test Child'))),
      );
      expect(find.text('Test Child'), findsOneWidget);
    });

    testWidgets('applies primary style', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AuthFloatingCard(isPrimary: true, child: Text('Primary')),
        ),
      );
      expect(find.text('Primary'), findsOneWidget);
    });

    testWidgets('applies form card style', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AuthFloatingCard(isFormCard: true, child: Text('Form')),
        ),
      );
      expect(find.text('Form'), findsOneWidget);
    });

    testWidgets('applies custom padding and margin', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AuthFloatingCard(
            padding: EdgeInsets.all(32),
            margin: EdgeInsets.all(16),
            child: Text('Custom'),
          ),
        ),
      );
      expect(find.text('Custom'), findsOneWidget);
    });
  });
}
