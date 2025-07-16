import 'package:flutter/material.dart';

class AlertCard extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;
  final String? time;
  final VoidCallback? onTap;

  const AlertCard({
    required this.text,
    required this.color,
    this.icon,
    this.time,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Determine appropriate colors based on theme and alert type
    final backgroundColor =
        isDark
            ? color.withAlpha((0.12 * 255).toInt())
            : color.withAlpha((0.08 * 255).toInt());

    final borderColor =
        isDark
            ? color.withAlpha((0.3 * 255).toInt())
            : color.withAlpha((0.2 * 255).toInt());

    final textColor =
        isDark
            ? color.withAlpha((0.9 * 255).toInt())
            : color.withAlpha((0.8 * 255).toInt());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color:
                    isDark
                        ? Colors.black.withAlpha((0.2 * 255).toInt())
                        : color.withAlpha((0.1 * 255).toInt()),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon container with gradient background
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color.withAlpha((0.8 * 255).toInt()),
                        color.withAlpha((0.6 * 255).toInt()),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: color.withAlpha((0.3 * 255).toInt()),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon ?? _getDefaultIcon(color),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                      if (time != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          time!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.hintColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Action indicator
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getDefaultIcon(Color color) {
    // Return appropriate icon based on color
    if (color == Colors.red || color == Colors.redAccent) {
      return Icons.warning_rounded;
    } else if (color == Colors.orange || color == Colors.orangeAccent) {
      return Icons.medication_rounded;
    } else if (color == Colors.green || color == Colors.greenAccent) {
      return Icons.lightbulb_rounded;
    } else if (color == Colors.blue || color == Colors.blueAccent) {
      return Icons.info_rounded;
    } else {
      return Icons.notifications_rounded;
    }
  }
}
