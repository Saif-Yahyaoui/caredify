import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircularStepCounter extends StatelessWidget {
  final int steps;
  final int goal;
  final double size;

  const CircularStepCounter({
    super.key,
    required this.steps,
    required this.goal,
    this.size = 180,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (steps / goal).clamp(0.0, 1.0);
    final theme = Theme.of(context);
    return SizedBox(
      width: size,
      height: size,
      child: CircularPercentIndicator(
        radius: size / 2,
        lineWidth: 14,
        percent: percent,
        animation: true,
        circularStrokeCap: CircularStrokeCap.round,
        backgroundColor: theme.colorScheme.surface.withAlpha((0.15 * 255).round()),
        linearGradient: const LinearGradient(
          colors: [Color(0xFF4ADE80), Color(0xFF22D3EE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: SvgPicture.asset(
                'assets/icons/walking.svg',
                width: 60,
                height: 60,
                placeholderBuilder:
                    (context) => Icon(
                      Icons.directions_walk,
                      size: 45,
                      color: theme.primaryColor,
                    ),
              ),
            ),

            const SizedBox(height: 10),
            Text(
              '$steps',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.lightGreen,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            Text(
              'steps',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.lightGreen,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
