import 'package:flutter_test/flutter_test.dart';
import 'package:caredify/providers/health_metrics_provider.dart';

void main() {
  test('HealthMetricsProvider has default values', () {
    final notifier = HealthMetricsNotifier();
    final metrics = notifier.state;
    expect(metrics.steps, isNonZero);
    expect(metrics.calories, isNonZero);
  });
}
