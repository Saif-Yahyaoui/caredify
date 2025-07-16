import 'package:flutter/material.dart';

class CoachCard extends StatelessWidget {
  final String message;
  final String? userName;
  final VoidCallback? onVoice;
  final VoidCallback? onText;

  const CoachCard({
    super.key,
    required this.message,
    this.userName,
    this.onVoice,
    this.onText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
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
                    : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0)],
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
                      ? Colors.black.withAlpha((0.3 * 255).toInt())
                      : const Color(0xFF64748B).withAlpha((0.1 * 255).toInt()),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with AI avatar and title
              Row(
                children: [
                  // AI Avatar with gradient
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF6366F1,
                          ).withAlpha((0.3 * 255).toInt()),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.psychology_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Coach Cardio-AI',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color:
                                isDark ? Colors.white : const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Assistant personnel',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.hintColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status indicator
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF10B981,
                          ).withAlpha((0.4 * 255).toInt()),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Message content
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? const Color(
                            0xFF334155,
                          ).withAlpha((0.5 * 255).toInt())
                          : Colors.white.withAlpha((0.7 * 255).toInt()),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        isDark
                            ? const Color(
                              0xFF475569,
                            ).withAlpha((0.2 * 255).toInt())
                            : const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 20,
                      color: theme.hintColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        userName != null
                            ? 'Bonjour $userName ! $message'
                            : message,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color:
                              isDark
                                  ? Colors.white.withAlpha((0.9 * 255).toInt())
                                  : const Color(0xFF475569),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.mic_rounded,
                      label: 'Voice',
                      onPressed: onVoice,
                      isPrimary: true,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.chat_bubble_rounded,
                      label: 'Texte',
                      onPressed: onText,
                      isPrimary: false,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isDark;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.isPrimary,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        gradient:
            isPrimary
                ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                )
                : null,
        color:
            isPrimary
                ? null
                : isDark
                ? const Color(0xFF475569).withAlpha((0.3 * 255).toInt())
                : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border:
            isPrimary
                ? null
                : Border.all(
                  color:
                      isDark
                          ? const Color(
                            0xFF64748B,
                          ).withAlpha((0.3 * 255).toInt())
                          : const Color(0xFFCBD5E1),
                  width: 1,
                ),
        boxShadow:
            isPrimary
                ? [
                  BoxShadow(
                    color: const Color(
                      0xFF6366F1,
                    ).withAlpha((0.3 * 255).toInt()),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
                : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color:
                    isPrimary
                        ? Colors.white
                        : isDark
                        ? Colors.white.withAlpha((0.8 * 255).toInt())
                        : const Color(0xFF64748B),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color:
                      isPrimary
                          ? Colors.white
                          : isDark
                          ? Colors.white.withAlpha((0.8 * 255).toInt())
                          : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
