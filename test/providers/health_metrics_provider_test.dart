import 'package:caredify/shared/providers/health_metrics_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('HealthMetricsProvider Tests', () {
    test('HealthMetricsProvider has default values', () {
      final notifier = HealthMetricsNotifier();
      final metrics = notifier.state;
      expect(metrics.steps, isNonZero);
      expect(metrics.calories, isNonZero);
    });
  });
}
