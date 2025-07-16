import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/services/auth_service.dart';
import '../../../shared/widgets/alert_card.dart';
import '../../../shared/widgets/emergency_button.dart';
import '../../../shared/widgets/premium_components.dart';
import '../../../shared/widgets/role_based_access.dart';
import '../../../shared/widgets/unified_vital_cards.dart';
import '../../../shared/widgets/user_header.dart';
import '../../../shared/providers/health_metrics_provider.dart';
import '../../../shared/providers/ecg_analysis_provider.dart';
import '../../../shared/widgets/section_header.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const RoleBasedAccess(
      allowedUserTypes: [UserType.premium],
      child: _DashboardHome(),
    );
  }
}

class _DashboardHome extends ConsumerWidget {
  const _DashboardHome();

  Widget _buildMetricItem(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.bodySmall?.copyWith(color: color)),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 200,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- UserHeader at the top ---
            const UserHeader(),
            const SizedBox(height: 16),

            // Premium Dashboard Header
            _buildPremiumHeader(context, theme, isDark),

            // 1. VITAL SIGNS & HEALTH METRICS SECTION
            const SectionHeader(
              title: 'Vital Signs & Health Metrics',
              icon: Icons.favorite_rounded,
              iconColor: Color(0xFFEF4444),
            ),
            const SizedBox(height: 16),

            // Unified Vital Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: UnifiedVitalCards(
                onEcgTap: () => context.go('/main/dashboard/ecg-analysis'),
                onSpO2Tap: () => context.go('/main/dashboard/spo2-graph'),
                onBloodPressureTap:
                    () => context.go('/main/dashboard/bp-graph'),
                onHealthScoreTap:
                    () => context.go('/main/dashboard/health-score'),
              ),
            ),
            const SizedBox(height: 16),

            // 2. ACTIVITY & FITNESS SECTION
            const SectionHeader(
              title: 'Activity & Fitness',
              icon: Icons.directions_run_rounded,
              iconColor: Color(0xFF10B981),
            ),

            // --- 2x2 Grid of Premium Cards ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  _PremiumMetricCard(
                    title: 'Heart Rate',
                    value:
                        ref.watch(healthMetricsProvider).heartRate.toString() +
                        ' bpm',
                    iconAsset: 'assets/icons/heart.svg',
                    color: const Color(0xFFFF6B81),
                    onTap: () => context.go('/main/heart'),
                    isActive: ref.watch(healthMetricsProvider).heartRate > 100,
                  ),
                  _PremiumMetricCard(
                    title: 'Sleep',
                    value:
                        ref.watch(healthMetricsProvider).sleepHours.toString() +
                        ' h',
                    iconAsset: 'assets/icons/moon.svg',
                    color: const Color(0xFF8B5CF6),
                    onTap: () => context.go('/main/sleep'),
                  ),
                  _PremiumMetricCard(
                    title: 'Water Intake',
                    value:
                        (ref.watch(healthMetricsProvider).waterIntake * 1000)
                            .toStringAsFixed(0) +
                        ' ml',
                    iconAsset: 'assets/icons/water.svg',
                    color: const Color(0xFF22D3EE),
                    onTap: () => context.go('/main/water'),
                  ),
                  _PremiumMetricCard(
                    title: 'Workout Tracker',
                    value:
                        ref
                            .watch(healthMetricsProvider)
                            .activeMinutes
                            .toString() +
                        ' min',
                    iconAsset: 'assets/icons/exercise.svg',
                    color: const Color(0xFF4ADE80),
                    onTap: () => context.go('/main/workout'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. AI & ANALYTICS SECTION
            const SectionHeader(
              title: 'AI & Analytics',
              icon: Icons.psychology_rounded,
              iconColor: Color(0xFF6366F1),
            ),
            const SizedBox(height: 16),

            // AI Health Coach
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: InkWell(
                  onTap: () => context.go('/main/dashboard/advanced-coach-ai'),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.psychology,
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
                                'AI Health Coach',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Personalized health guidance and goals',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.hintColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: theme.hintColor),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Advanced Analytics
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: InkWell(
                  onTap: () => context.go('/main/dashboard/advanced-analytics'),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF0EA5E9), Color(0xFF2563EB)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.analytics,
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
                                'Advanced Analytics',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Deep insights, predictions, and custom reports',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.hintColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: theme.hintColor),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 4. ALERTS & NOTIFICATIONS SECTION
            const SectionHeader(
              title: 'Alerts & Notifications',
              icon: Icons.notifications_active_rounded,
              iconColor: Color(0xFFF59E0B),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AiAlertsCard(
                onTap: () => context.go('/main/dashboard/ai-alerts'),
              ),
            ),
            AlertCard(
              text: 'Rythme irrégulier détecté',
              color: const Color(0xFFEF4444),
              icon: Icons.favorite_rounded,
              time: 'Il y a 5 min',
              onTap: () {
                // Handle irregular rhythm alert
              },
            ),
            AlertCard(
              text: 'Rappel de médicament : cardiostat 5mg',
              color: const Color(0xFFF59E0B),
              icon: Icons.medication_rounded,
              time: 'Dans 30 min',
              onTap: () {
                // Handle medication reminder
              },
            ),
            AlertCard(
              text: 'Conseil : Marchez 10 minutes',
              color: const Color(0xFF10B981),
              icon: Icons.directions_walk_rounded,
              time: 'Il y a 2h',
              onTap: () {
                // Handle activity advice
              },
            ),

            // 5. SUPPORT & TOOLS SECTION
            const SectionHeader(
              title: 'Support & Tools',
              icon: Icons.support_agent,
              iconColor: Color(0xFFF59E42),
            ),
            const SizedBox(height: 16),

            // Data Export Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ExportDataCard(
                onTap: () => context.go('/main/dashboard/data-export'),
              ),
            ),
            const SizedBox(height: 16),

            // Emergency Call Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: EmergencyButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Emergency Call'),
                          content: const Text(
                            'Do you want to make an emergency call?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Emergency call initiated'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Call Emergency'),
                            ),
                          ],
                        ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumHeader(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDark
                  ? [
                    const Color(0xFF1E293B).withAlpha((0.8 * 255).toInt()),
                    const Color(0xFF334155).withAlpha((0.6 * 255).toInt()),
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
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF59E0B).withAlpha((0.3 * 255).toInt()),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.star_rounded,
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
                  "Premium Dashboard",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Accès complet aux fonctionnalités avancées',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF59E0B).withAlpha((0.3 * 255).toInt()),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_rounded, color: Colors.white, size: 16),
                SizedBox(width: 6),
                Text(
                  'PREMIUM',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Premium metric card for grid
class _PremiumMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String iconAsset;
  final Color color;
  final VoidCallback onTap;
  final bool isActive;
  const _PremiumMetricCard({
    required this.title,
    required this.value,
    required this.iconAsset,
    required this.color,
    required this.onTap,
    this.isActive = false,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.12), color.withOpacity(0.06)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.18), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.18),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
          backgroundBlendMode: BlendMode.overlay,
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [color, color.withOpacity(0.7)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.18),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: SvgPicture.asset(
                            iconAsset,
                            colorFilter: ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                            width: 22,
                            height: 22,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      flex: 2,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          value,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Flexible(
                      flex: 2,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.hintColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
