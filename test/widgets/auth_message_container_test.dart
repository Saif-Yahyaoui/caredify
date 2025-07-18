import 'package:caredify/features/auth/widgets/auth_message_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthMessageContainer Widget Tests', () {
    testWidgets('renders error message with icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: AuthMessageContainer(message: 'Error occurred')),
      );
      expect(find.text('Error occurred'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('renders success message with icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AuthMessageContainer(message: 'Success!', isError: false),
        ),
      );
      expect(find.text('Success!'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });

    testWidgets('applies custom margin', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AuthMessageContainer(
            message: 'With margin',
            margin: EdgeInsets.all(32),
          ),
        ),
      );
      expect(find.text('With margin'), findsOneWidget);
    });
  });
}
