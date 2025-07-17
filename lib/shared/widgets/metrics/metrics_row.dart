import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MetricsRow extends StatelessWidget {
  final double calories;
  final double distance;
  final int minutes;

  const MetricsRow({
    super.key,
    required this.calories,
    required this.distance,
    required this.minutes,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _MetricCircle(
            iconPath: 'assets/icons/fire.svg',
            value: calories.toStringAsFixed(0),
            label: 'kcal',
            color: const Color(0xFFFFA726), // Orange
            percent: (calories / 200).clamp(0.0, 1.0),
          ),
          _MetricCircle(
            iconPath: 'assets/icons/distance.svg',
            value: distance.toStringAsFixed(1),
            label: 'km',
            color: const Color(0xFF42A5F5), // Blue
            percent: (distance / 5).clamp(0.0, 1.0),
          ),
          _MetricCircle(
            iconPath: 'assets/icons/timer.svg',
            value: minutes.toString(),
            label: 'min',
            color: const Color(0xFFAB47BC), // Purple
            percent: (minutes / 60).clamp(0.0, 1.0),
          ),
        ],
      ),
    );
  }
}

class _MetricCircle extends StatelessWidget {
  final String iconPath;
  final String value;
  final String label;
  final Color color;
  final double percent;

  const _MetricCircle({
    required this.iconPath,
    required this.value,
    required this.label,
    required this.color,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 28,
          lineWidth: 5,
          percent: percent,
          animation: true,
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: color.withAlpha((0.15 * 255).round()),
          progressColor: color,
          center: SvgPicture.asset(
            iconPath,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            placeholderBuilder:
                (context) => Icon(Icons.help_outline, size: 20, color: color),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
