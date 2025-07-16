import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActivityMetric {
  final String label;
  final String value;
  final String iconAsset;
  final Color color;
  ActivityMetric({
    required this.label,
    required this.value,
    required this.iconAsset,
    required this.color,
  });
}

class ActivityCard extends StatelessWidget {
  final String title;
  final List<ActivityMetric> metrics;
  final double progress; // Main progress (e.g. steps)
  final VoidCallback? onTap;
  const ActivityCard({
    super.key,
    required this.title,
    required this.metrics,
    required this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.directions_run_rounded,
                    color: theme.primaryColor,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                    metrics.map((m) => _buildMetricChip(m, theme)).toList(),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: theme.primaryColor.withAlpha(30),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.primaryColor,
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

  Widget _buildMetricChip(ActivityMetric m, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: m.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            m.iconAsset,
            width: 18,
            height: 18,
            colorFilter: ColorFilter.mode(m.color, BlendMode.srcIn),
          ),
          const SizedBox(width: 6),
          Text(
            m.value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: m.color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            m.label,
            style: theme.textTheme.bodySmall?.copyWith(color: m.color),
          ),
        ],
      ),
    );
  }
}
