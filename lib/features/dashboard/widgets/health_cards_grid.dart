import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    return Column(
      children: [
        // Heart, Water, Sleep, Workout cards in ActivityCard style
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: _HealthActivityCard(
                title: AppLocalizations.of(context)!.heart,
                value: '$heartRate',
                goal: '$heartRateMax',
                iconAsset: 'assets/icons/heart.svg',
                color: const Color(0xFFFF6B81),
                unit: 'bpm',
                onTap: onHeartTap,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _HealthActivityCard(
                title: AppLocalizations.of(context)!.water,
                value: waterIntake.toStringAsFixed(0),
                goal: waterGoal.toStringAsFixed(0),
                iconAsset: 'assets/icons/water.svg',
                color: const Color(0xFF22D3EE),
                unit: 'ml',
                onTap: onWaterTap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: _HealthActivityCard(
                title: AppLocalizations.of(context)!.sleep,
                value: sleepHours.toStringAsFixed(1),
                goal: sleepGoal.toStringAsFixed(1),
                iconAsset: 'assets/icons/moon.svg',
                color: const Color(0xFF8B5CF6),
                unit: 'h',
                onTap: onSleepTap,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _HealthActivityCard(
                title: AppLocalizations.of(context)!.workout,
                value: '$workoutMinutes',
                goal: '$workoutGoal',
                iconAsset: 'assets/icons/exercise.svg',
                color: const Color(0xFF4ADE80),
                unit: 'min',
                onTap: onWorkoutTap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Healthy Habits - Full width card
        _FullWidthHealthCard(
          title: AppLocalizations.of(context)!.healthyHabits,
          value: AppLocalizations.of(context)!.habits,
          goal: AppLocalizations.of(context)!.track,
          icon: Icons.check_circle_outline,
          color: Colors.green,
          onTap: onHabitsTap,
        ),
        const SizedBox(height: 12),

        // Health Index - Full width card
        _FullWidthHealthCard(
          title: AppLocalizations.of(context)!.myHealthIndex,
          value: AppLocalizations.of(context)!.index,
          goal: AppLocalizations.of(context)!.score,
          icon: Icons.stars,
          color: Colors.amber,
          onTap: onHealthIndexTap,
        ),
      ],
    );
  }
}

class _HealthActivityCard extends StatelessWidget {
  final String title;
  final String value;
  final String goal;
  final String? iconAsset;
  final Color color;
  final String unit;
  final VoidCallback? onTap;

  const _HealthActivityCard({
    required this.title,
    required this.value,
    required this.goal,
    this.iconAsset,
    required this.color,
    required this.unit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double progress =
        (double.tryParse(value) ?? 0) / (double.tryParse(goal) ?? 1);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withAlpha((0.15 * 255).toInt()),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child:
                          iconAsset != null
                              ? SvgPicture.asset(
                                iconAsset!,
                                width: 24,
                                height: 24,
                                colorFilter: ColorFilter.mode(
                                  color,
                                  BlendMode.srcIn,
                                ),
                              )
                              : Icon(
                                Icons.help_outline,
                                color: color,
                                size: 24,
                              ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      'Aujourd\'hui ',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      '$value $unit',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Text(
                'Objectif $goal $unit',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 120, // Fixed width to prevent infinite constraints
                height: 8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: color.withAlpha((0.08 * 255).toInt()),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FullWidthHealthCard extends StatelessWidget {
  final String title;
  final String value;
  final String goal;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _FullWidthHealthCard({
    required this.title,
    required this.value,
    required this.goal,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withAlpha((0.15 * 255).toInt()),
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: Icon(icon, color: color, size: 28)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      'Aujourd\'hui ',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      value,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Objectif $goal',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 12,
                decoration: BoxDecoration(
                  color: color.withAlpha((0.08 * 255).toInt()),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.7, // 70% progress for demo
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
