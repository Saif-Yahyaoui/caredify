import 'package:caredify/shared/widgets/sections/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SectionHeader', () {
    testWidgets('renders with given title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SectionHeader(title: 'Vitals', icon: Icons.favorite),
        ),
      );
      expect(find.text('Vitals'), findsOneWidget);
      expect(find.byType(SectionHeader), findsOneWidget);
    });
  });
}
