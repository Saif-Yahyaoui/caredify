import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caredify/features/profile/profile_screen.dart';
import 'test_helpers.dart';

void main() {
  testWidgets('ProfileScreen renders and shows options', (tester) async {
    await tester.pumpWidget(
      ProviderScope(child: localizedTestableWidget(const ProfileScreen())),
    );
    expect(
      find.textContaining('Account Settings', findRichText: true),
      findsWidgets,
    );
  });
}
