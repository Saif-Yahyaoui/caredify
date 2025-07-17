import 'package:flutter/material.dart';

import '../../../shared/models/auth_models.dart';
import 'auth_floating_card.dart';
import 'auth_logo_header.dart';

class AuthOnboardingCard extends StatelessWidget {
  final OnboardingCardData data;
  const AuthOnboardingCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Center(
      child: AuthFloatingCard(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        borderRadius: 24.0,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image or Icon
              if (data.imageAsset != null)
                AuthLogoHeader(
                  isDark: isDark,
                  // Only show logo, no title/subtitle
                )
              else if (data.icon != null)
                Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: (data.iconColor ??
                            (isDark
                                ? const Color(0xFF60A5FA)
                                : theme.primaryColor))
                        .withAlpha(
                          isDark ? (0.2 * 255).toInt() : (0.15 * 255).toInt(),
                        ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    data.icon,
                    color:
                        data.iconColor ??
                        (isDark ? const Color(0xFF60A5FA) : theme.primaryColor),
                    size: 30.0,
                  ),
                ),

              const SizedBox(height: 20.0),

              // Title
              Text(
                data.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12.0),

              // Subtitle
              Text(
                data.subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color:
                      isDark
                          ? Colors.white.withAlpha((0.8 * 255).toInt())
                          : const Color(0xFF64748B),
                  fontSize: 14.0,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              // Features section
              if (data.features.isNotEmpty) ...[
                const SizedBox(height: 20.0),

                if (data.featuresTitle != null) ...[
                  Text(
                    data.featuresTitle!,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12.0),
                ],

                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? Colors.white.withAlpha((0.05 * 255).toInt())
                            : theme.primaryColor.withAlpha(
                              (0.05 * 255).toInt(),
                            ),
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color:
                          isDark
                              ? Colors.white.withAlpha((0.1 * 255).toInt())
                              : theme.primaryColor.withAlpha(
                                (0.1 * 255).toInt(),
                              ),
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        data.features
                            .map(
                              (feature) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 6.0),
                                      width: 6.0,
                                      height: 6.0,
                                      decoration: BoxDecoration(
                                        color:
                                            data.iconColor ??
                                            (isDark
                                                ? const Color(0xFF60A5FA)
                                                : theme.primaryColor),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Expanded(
                                      child: Text(
                                        feature,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color:
                                                  isDark
                                                      ? Colors.white.withAlpha(
                                                        (0.9 * 255).toInt(),
                                                      )
                                                      : const Color(0xFF475569),
                                              fontSize: 13.0,
                                              height: 1.3,
                                            ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ],

              // Bottom text
              if (data.bottomText != null) ...[
                const SizedBox(height: 16.0),
                Text(
                  data.bottomText!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color:
                        isDark
                            ? Colors.white.withAlpha((0.7 * 255).toInt())
                            : const Color(0xFF64748B),
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
