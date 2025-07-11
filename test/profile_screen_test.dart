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
    await tester.pumpAndSettle();

    // Check for the disconnected banner
    expect(find.text('The watch is disconnected !'), findsOneWidget);
    expect(
      find.text(
        'Please make sure to wear your watch and connect it to the app',
      ),
      findsOneWidget,
    );
    expect(find.text('CLICK HERE TO CONNECT'), findsOneWidget);

    // Check for all profile options
    expect(find.text('Account Settings'), findsOneWidget);
    expect(find.text('Notification'), findsOneWidget);
    expect(find.text('Message Push'), findsOneWidget);
    expect(find.text('Reset device'), findsOneWidget);
    expect(find.text('Remove'), findsOneWidget);
    expect(find.text('Other'), findsOneWidget);
    expect(find.text('Remote Shutter'), findsOneWidget);
    expect(find.text('OTA upgrade'), findsOneWidget);

    // Check that there are 8 ListTiles (one for each option)
    expect(find.byType(ListTile), findsNWidgets(8));
  });
}
