import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HealthCardsGrid extends StatelessWidget {
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

  const HealthCardsGrid({
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.1,
        children: [
          GestureDetector(
            onTap: onHeartTap,
            child: _HealthMetricCard(
              iconPath: 'assets/icons/heart.svg',
              mainValue: '$heartRate bpm',
              subValue: '$heartRateMax bpm',
              label: AppLocalizations.of(context)!.heart,
              color: const Color(0xFFFF6B81),
            ),
          ),
          GestureDetector(
            onTap: onWaterTap,
            child: _HealthMetricCard(
              iconPath: 'assets/icons/water.svg',
              mainValue: '${waterIntake.toStringAsFixed(0)} ml',
              subValue: '${waterGoal.toStringAsFixed(0)} ml',
              label: AppLocalizations.of(context)!.water,
              color: const Color(0xFF22D3EE),
            ),
          ),
          GestureDetector(
            onTap: onSleepTap,
            child: _HealthMetricCard(
              iconPath: 'assets/icons/moon.svg',
              mainValue: '${sleepHours.toStringAsFixed(1)} h',
              subValue: '${sleepGoal.toStringAsFixed(1)} h',
              label: AppLocalizations.of(context)!.sleep,
              color: const Color(0xFF8B5CF6),
            ),
          ),
          GestureDetector(
            onTap: onWorkoutTap,
            child: _HealthMetricCard(
              iconPath: 'assets/icons/exercise.svg',
              mainValue: '$workoutMinutes min',
              subValue: '$workoutGoal min',
              label: AppLocalizations.of(context)!.workout,
              color: const Color(0xFF4ADE80),
            ),
          ),
          GestureDetector(
            onTap: onHabitsTap,
            child: _HealthMetricCard.icon(
              icon: Icons.check_circle_outline,
              mainValue: AppLocalizations.of(context)!.habits,
              subValue: AppLocalizations.of(context)!.track,
              label: AppLocalizations.of(context)!.healthyHabits,
              color: Colors.green,
            ),
          ),
          GestureDetector(
            onTap: onHealthIndexTap,
            child: _HealthMetricCard.icon(
              icon: Icons.stars,
              mainValue: AppLocalizations.of(context)!.index,
              subValue: AppLocalizations.of(context)!.score,
              label: AppLocalizations.of(context)!.myHealthIndex,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthMetricCard extends StatelessWidget {
  final String? iconPath;
  final IconData? icon;
  final String mainValue;
  final String subValue;
  final String label;
  final Color color;

  const _HealthMetricCard({
    this.iconPath,
    this.icon,
    required this.mainValue,
    required this.subValue,
    required this.label,
    required this.color,
  });

  factory _HealthMetricCard.icon({
    required IconData icon,
    required String mainValue,
    required String subValue,
    required String label,
    required Color color,
  }) {
    return _HealthMetricCard(
      icon: icon,
      mainValue: mainValue,
      subValue: subValue,
      label: label,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (iconPath != null)
                  SvgPicture.asset(
                    iconPath!,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                    placeholderBuilder:
                        (context) =>
                            Icon(Icons.help_outline, size: 24, color: color),
                  )
                else if (icon != null)
                  Icon(icon, size: 24, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              mainValue,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              subValue,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
