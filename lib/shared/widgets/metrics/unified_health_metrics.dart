import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UnifiedHealthMetrics extends ConsumerWidget {
  final int heartRate;
  final int heartRateMax;
  final double waterIntake;
  final double waterGoal;
  final double sleepHours;
  final double sleepGoal;
  final int workoutMinutes;
  final int workoutGoal;
  final VoidCallback? onHeartTap;
  final VoidCallback? onWaterTap;
  final VoidCallback? onSleepTap;
  final VoidCallback? onWorkoutTap;
  final VoidCallback? onHabitsTap;
  final VoidCallback? onHealthIndexTap;

  const UnifiedHealthMetrics({
    super.key,
    required this.heartRate,
    required this.heartRateMax,
    required this.waterIntake,
    required this.waterGoal,
    required this.sleepHours,
    required this.sleepGoal,
    required this.workoutMinutes,
    required this.workoutGoal,
    this.onHeartTap,
    this.onWaterTap,
    this.onSleepTap,
    this.onWorkoutTap,
    this.onHabitsTap,
    this.onHealthIndexTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Activity Metrics Grid
        Row(
          children: [
            Expanded(
              child: _buildActivityCard(
                context,
                theme,
                isDark,
                'Pas',
                '9999',
                '8000',
                'assets/icons/walking.svg',
                const Color(0xFF4ADE80),
                null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActivityCard(
                context,
                theme,
                isDark,
                'Calories',
                '111',
                '200',
                'assets/icons/fire.svg',
                const Color(0xFFFFA726),
                null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActivityCard(
                context,
                theme,
                isDark,
                'Distance',
                '1.2',
                '2',
                'assets/icons/distance.svg',
                const Color(0xFF42A5F5),
                null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActivityCard(
                context,
                theme,
                isDark,
                'Exercice',
                '30',
                '60',
                'assets/icons/exercise.svg',
                const Color(0xFF8B5CF6),
                null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Health Metrics Grid
        Row(
          children: [
            Expanded(
              child: _buildHealthMetricCard(
                context,
                theme,
                isDark,
                'Heart Rate',
                '$heartRate',
                '$heartRateMax',
                'assets/icons/heart.svg',
                const Color(0xFFFF6B81),
                'bpm',
                onHeartTap,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildHealthMetricCard(
                context,
                theme,
                isDark,
                'Water Intake',
                waterIntake.toStringAsFixed(0),
                waterGoal.toStringAsFixed(0),
                'assets/icons/water.svg',
                const Color(0xFF22D3EE),
                'ml',
                onWaterTap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildHealthMetricCard(
                context,
                theme,
                isDark,
                'Sleep',
                sleepHours.toStringAsFixed(1),
                sleepGoal.toStringAsFixed(1),
                'assets/icons/moon.svg',
                const Color(0xFF8B5CF6),
                'h',
                onSleepTap,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildHealthMetricCard(
                context,
                theme,
                isDark,
                'Workout',
                '$workoutMinutes',
                '$workoutGoal',
                'assets/icons/exercise.svg',
                const Color(0xFF4ADE80),
                'min',
                onWorkoutTap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Full Width Cards
        _buildFullWidthCard(
          context,
          theme,
          isDark,
          'Healthy Habits',
          'Track your daily habits',
          Icons.check_circle_outline_rounded,
          const Color(0xFF10B981),
          onHabitsTap,
        ),
        const SizedBox(height: 12),
        _buildFullWidthCard(
          context,
          theme,
          isDark,
          'Health Index',
          'Your overall health score',
          Icons.stars_rounded,
          const Color(0xFFF59E0B),
          onHealthIndexTap,
        ),
      ],
    );
  }

  Widget _buildActivityCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    String title,
    String value,
    String goal,
    String iconAsset,
    Color color,
    VoidCallback? onTap,
  ) {
    final double progress =
        (double.tryParse(value) ?? 0) / (double.tryParse(goal) ?? 1);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDark
                  ? [
                    const Color(0xFF1E293B).withAlpha((0.8 * 255).toInt()),
                    const Color(0xFF334155).withAlpha((0.5 * 255).toInt()),
                  ]
                  : [Colors.white, const Color(0xFFF8FAFC)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              isDark
                  ? const Color(0xFF475569).withAlpha((0.3 * 255).toInt())
                  : const Color(0xFFCBD5E1).withAlpha((0.5 * 255).toInt()),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withAlpha((0.2 * 255).toInt())
                    : const Color(0xFF64748B).withAlpha((0.1 * 255).toInt()),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [color, color.withAlpha((0.8 * 255).toInt())],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: color.withAlpha((0.3 * 255).toInt()),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(
                        iconAsset,
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  value,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Goal: $goal',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color:
                        isDark
                            ? Colors.white.withAlpha((0.7 * 255).toInt())
                            : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  backgroundColor:
                      isDark
                          ? Colors.white.withAlpha((0.1 * 255).toInt())
                          : color.withAlpha((0.2 * 255).toInt()),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHealthMetricCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    String title,
    String value,
    String goal,
    String iconAsset,
    Color color,
    String unit,
    VoidCallback? onTap,
  ) {
    final double progress =
        (double.tryParse(value) ?? 0) / (double.tryParse(goal) ?? 1);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDark
                  ? [
                    const Color(0xFF1E293B).withAlpha((0.8 * 255).toInt()),
                    const Color(0xFF334155).withAlpha((0.5 * 255).toInt()),
                  ]
                  : [Colors.white, const Color(0xFFF8FAFC)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              isDark
                  ? const Color(0xFF475569).withAlpha((0.3 * 255).toInt())
                  : const Color(0xFFCBD5E1).withAlpha((0.5 * 255).toInt()),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withAlpha((0.2 * 255).toInt())
                    : const Color(0xFF64748B).withAlpha((0.1 * 255).toInt()),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [color, color.withAlpha((0.8 * 255).toInt())],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: color.withAlpha((0.3 * 255).toInt()),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(
                        iconAsset,
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      unit,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            isDark
                                ? Colors.white.withAlpha((0.7 * 255).toInt())
                                : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Goal: $goal $unit',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color:
                        isDark
                            ? Colors.white.withAlpha((0.7 * 255).toInt())
                            : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  backgroundColor:
                      isDark
                          ? Colors.white.withAlpha((0.1 * 255).toInt())
                          : color.withAlpha((0.2 * 255).toInt()),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFullWidthCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback? onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDark
                  ? [
                    const Color(0xFF1E293B).withAlpha((0.8 * 255).toInt()),
                    const Color(0xFF334155).withAlpha((0.5 * 255).toInt()),
                  ]
                  : [Colors.white, const Color(0xFFF8FAFC)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              isDark
                  ? const Color(0xFF475569).withAlpha((0.3 * 255).toInt())
                  : const Color(0xFFCBD5E1).withAlpha((0.5 * 255).toInt()),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withAlpha((0.2 * 255).toInt())
                    : const Color(0xFF64748B).withAlpha((0.1 * 255).toInt()),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [color, color.withAlpha((0.8 * 255).toInt())],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: color.withAlpha((0.3 * 255).toInt()),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color:
                              isDark
                                  ? Colors.white.withAlpha((0.7 * 255).toInt())
                                  : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color:
                      isDark
                          ? Colors.white.withAlpha((0.6 * 255).toInt())
                          : const Color(0xFF64748B),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
