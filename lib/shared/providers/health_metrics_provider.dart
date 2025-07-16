import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/health_metrics.dart';

class HealthMetricsNotifier extends StateNotifier<HealthMetrics> {
  HealthMetricsNotifier()
    : super(
        HealthMetrics(
          steps: 9999,
          calories: 111,
          distance: 1.2,
          activeMinutes: 30,
          waterIntake: 0.5,
          sleepHours: 7,
          heartRate: 0,
        ),
      );

  // Add update methods as needed
}

final healthMetricsProvider =
    StateNotifierProvider<HealthMetricsNotifier, HealthMetrics>(
      (ref) => HealthMetricsNotifier(),
    );
