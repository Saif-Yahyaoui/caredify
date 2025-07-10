import 'package:flutter_test/flutter_test.dart';
import 'package:caredify/features/dashboard/circular_step_counter.dart';
import 'test_helpers.dart';

void main() {
  testWidgets('CircularStepCounter renders with steps', (tester) async {
    await tester.pumpWidget(
      localizedTestableWidget(CircularStepCounter(steps: 5000, goal: 10000)),
    );
    expect(find.text('5000'), findsOneWidget);
    expect(find.text('steps'), findsOneWidget);
  });
}
