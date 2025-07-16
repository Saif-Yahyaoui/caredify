import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final Color? textColor;
  final double? spacing;
  final double? iconSize;

  const SectionHeader({
    super.key,
    required this.title,
    required this.icon,
    this.iconColor,
    this.textColor,
    this.spacing,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 370),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors:
                  isDark
                      ? [const Color(0xFF232946), const Color(0xFF1E293B)]
                      : [const Color(0xFFF1F5F9), const Color(0xFFE0EAFC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: (iconColor ?? theme.primaryColor).withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (iconColor ?? theme.primaryColor).withOpacity(0.9),
                      (iconColor ?? theme.primaryColor).withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(icon, color: Colors.white, size: iconSize ?? 24),
              ),
              SizedBox(width: spacing ?? 16),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color:
                        textColor ??
                        (isDark ? Colors.white : const Color(0xFF1E293B)),
                    letterSpacing: 0.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Optional accent bar for extra premium feel
              Container(
                width: 6,
                height: 32,
                margin: const EdgeInsets.only(left: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [
                      (iconColor ?? theme.primaryColor),
                      (iconColor ?? theme.primaryColor).withOpacity(0.5),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
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
