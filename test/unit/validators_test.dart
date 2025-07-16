import 'package:caredify/core/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('Validators', () {
    group('validatePhone', () {
      testWidgets('should return null for valid phone numbers', (tester) async {
        await tester.pumpWidget(
          TestSetup.createTestWidget(
            Builder(
              builder: (context) {
                expect(Validators.validatePhone('20947998', context), isNull);
                expect(
                  Validators.validatePhone('+216 20 947 998', context),
                  isNull,
                );
                expect(
                  Validators.validatePhone('20 94 79 98', context),
                  isNull,
                );
                return const Text('Test');
              },
            ),
          ),
        );
      });

      testWidgets('should return error for empty or null phone numbers', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestSetup.createTestWidget(
            Builder(
              builder: (context) {
                expect(Validators.validatePhone('', context), isNotNull);
                expect(Validators.validatePhone(null, context), isNotNull);
                expect(Validators.validatePhone('   ', context), isNotNull);
                return const Text('Test');
              },
            ),
          ),
        );
      });

      testWidgets('should return error for invalid phone formats', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestSetup.createTestWidget(
            Builder(
              builder: (context) {
                expect(
                  Validators.validatePhone('123', context),
                  isNotNull,
                ); // Too short
                expect(
                  Validators.validatePhone('12345678901234567890', context),
                  isNotNull,
                ); // Too long
                expect(
                  Validators.validatePhone('abc123def', context),
                  isNotNull,
                ); // Invalid characters
                return const Text('Test');
              },
            ),
          ),
        );
      });
    });

    group('validatePassword', () {
      testWidgets('should return null for valid passwords', (tester) async {
        await tester.pumpWidget(
          TestSetup.createTestWidget(
            Builder(
              builder: (context) {
                expect(
                  Validators.validatePassword('password123', context),
                  isNull,
                );
                expect(
                  Validators.validatePassword('basic', context),
                  isNull,
                ); // Test password
                expect(
                  Validators.validatePassword('premium', context),
                  isNull,
                ); // Test password
                return const Text('Test');
              },
            ),
          ),
        );
      });

      testWidgets('should return error for empty or null passwords', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestSetup.createTestWidget(
            Builder(
              builder: (context) {
                expect(Validators.validatePassword('', context), isNotNull);
                expect(Validators.validatePassword(null, context), isNotNull);
                return const Text('Test');
              },
            ),
          ),
        );
      });

      testWidgets('should return error for weak passwords', (tester) async {
        await tester.pumpWidget(
          TestSetup.createTestWidget(
            Builder(
              builder: (context) {
                expect(
                  Validators.validatePassword('123', context),
                  isNotNull,
                ); // Too short
                expect(
                  Validators.validatePassword('abc', context),
                  isNotNull,
                ); // Too short
                return const Text('Test');
              },
            ),
          ),
        );
      });
    });

    group('validateEmail', () {
      testWidgets('should return null for valid email addresses', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestSetup.createTestWidget(
            Builder(
              builder: (context) {
                expect(
                  Validators.validateEmail('test@example.com', context),
                  isNull,
                );
                expect(
                  Validators.validateEmail('user.name@domain.co.uk', context),
                  isNull,
                );
                expect(
                  Validators.validateEmail('test123@test.org', context),
                  isNull,
                );
                return const Text('Test');
              },
            ),
          ),
        );
      });

      testWidgets('should return error for empty or null email addresses', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestSetup.createTestWidget(
            Builder(
              builder: (context) {
                expect(Validators.validateEmail('', context), isNotNull);
                expect(Validators.validateEmail(null, context), isNotNull);
                expect(Validators.validateEmail('   ', context), isNotNull);
                return const Text('Test');
              },
            ),
          ),
        );
      });

      testWidgets('should return error for invalid email formats', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestSetup.createTestWidget(
            Builder(
              builder: (context) {
                expect(
                  Validators.validateEmail('invalid-email', context),
                  isNotNull,
                );
                expect(Validators.validateEmail('test@', context), isNotNull);
                expect(
                  Validators.validateEmail('@example.com', context),
                  isNotNull,
                );
                expect(
                  Validators.validateEmail('test..test@example.com', context),
                  isNotNull,
                );
                return const Text('Test');
              },
            ),
          ),
        );
      });
    });

    group('validateRequired', () {
      testWidgets('should return null for valid values', (tester) async {
        await tester.pumpWidget(
          TestSetup.createTestWidget(
            Builder(
              builder: (context) {
                expect(
                  Validators.validateRequired('test', 'Name', context),
                  isNull,
                );
                expect(
                  Validators.validateRequired('some value', 'Field', context),
                  isNull,
                );
                return const Text('Test');
              },
            ),
          ),
        );
      });

      testWidgets('should return error for empty or null values', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestSetup.createTestWidget(
            Builder(
              builder: (context) {
                expect(
                  Validators.validateRequired('', 'Name', context),
                  isNotNull,
                );
                expect(
                  Validators.validateRequired(null, 'Name', context),
                  isNotNull,
                );
                expect(
                  Validators.validateRequired('   ', 'Name', context),
                  isNotNull,
                );
                return const Text('Test');
              },
            ),
          ),
        );
      });

      testWidgets('should include field name in error message', (tester) async {
        await tester.pumpWidget(
          TestSetup.createTestWidget(
            Builder(
              builder: (context) {
                final error = Validators.validateRequired('', 'Name', context);
                expect(error, contains('Name'));
                return const Text('Test');
              },
            ),
          ),
        );
      });
    });

    group('validateName', () {
      testWidgets('should return null for valid names', (tester) async {
        await tester.pumpWidget(
          TestSetup.createTestWidget(
            Builder(
              builder: (context) {
                // Test with names that should pass validation
                expect(Validators.validateName('John', context), isNull);
                expect(Validators.validateName('John Doe', context), isNull);
                expect(Validators.validateName('Jean-Pierre', context), isNull);
                return const Text('Test');
              },
            ),
          ),
        );
      });

      testWidgets('should return error for empty or null names', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestSetup.createTestWidget(
            Builder(
              builder: (context) {
                expect(Validators.validateName('', context), isNotNull);
                expect(Validators.validateName(null, context), isNotNull);
                expect(Validators.validateName('   ', context), isNotNull);
                return const Text('Test');
              },
            ),
          ),
        );
      });

      testWidgets('should return error for names that are too short', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestSetup.createTestWidget(
            Builder(
              builder: (context) {
                expect(Validators.validateName('A', context), isNotNull);
                expect(Validators.validateName('a', context), isNotNull);
                return const Text('Test');
              },
            ),
          ),
        );
      });

      testWidgets('should return error for names with invalid characters', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestSetup.createTestWidget(
            Builder(
              builder: (context) {
                expect(Validators.validateName('John123', context), isNotNull);
                expect(Validators.validateName('John@Doe', context), isNotNull);
                expect(Validators.validateName('John_Doe', context), isNotNull);
                return const Text('Test');
              },
            ),
          ),
        );
      });
    });
  });
}
