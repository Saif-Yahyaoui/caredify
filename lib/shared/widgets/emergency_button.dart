import 'package:flutter/material.dart';

class EmergencyButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData? icon;

  const EmergencyButton({
    super.key,
    required this.onPressed,
    this.text = 'Appeler aide',
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEF4444).withAlpha((0.4 * 255).toInt()),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withAlpha((0.2 * 255).toInt())
                    : const Color(0xFFEF4444).withAlpha((0.1 * 255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Pulsing emergency icon
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha((0.2 * 255).toInt()),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon ?? Icons.emergency_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),

                // Text content
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        text,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Appuyez pour appeler',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withAlpha((0.8 * 255).toInt()),
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Arrow indicator
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha((0.2 * 255).toInt()),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
