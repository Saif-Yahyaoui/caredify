import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../shared/providers/user_type_provider.dart';
import '../../../shared/widgets/custom_button.dart';

class UpgradeScreen extends ConsumerStatefulWidget {
  const UpgradeScreen({super.key});

  @override
  ConsumerState<UpgradeScreen> createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends ConsumerState<UpgradeScreen> {
  bool _isLoading = false;
  String? _selectedPlan = 'monthly';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final upgradeBenefits = ref.watch(upgradeBenefitsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade to Premium'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => context.go('/main/profile'),
        ),
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section
            _buildHeader(context, isDark),
            const SizedBox(height: 24),

            // Plan Selection
            _buildPlanSelection(context, isDark),
            const SizedBox(height: 24),

            // Benefits Section
            _buildBenefitsSection(context, upgradeBenefits, isDark),
            const SizedBox(height: 24),

            // Upgrade Button
            _buildUpgradeButton(context),
            const SizedBox(height: 24),

            // Feature Comparison Section
            _buildFeatureComparisonSection(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
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
      ),
      child: Column(
        children: [
          // Premium Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD700).withAlpha((0.3 * 255).toInt()),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_rounded, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'PREMIUM',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            'Unlock Your Full Health Potential',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1E293B),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            'Get advanced analytics, AI insights, and comprehensive health monitoring',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.white70 : const Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPlanSelection(BuildContext context, bool isDark) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Your Plan',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _PlanOption(
                    title: 'Monthly',
                    price: '\$9.99',
                    period: 'per month',
                    isSelected: _selectedPlan == 'monthly',
                    onTap: () => setState(() => _selectedPlan = 'monthly'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PlanOption(
                    title: 'Yearly',
                    price: '\$99.99',
                    period: 'per year',
                    isSelected: _selectedPlan == 'yearly',
                    onTap: () => setState(() => _selectedPlan = 'yearly'),
                    isRecommended: true,
                  ),
                ),
              ],
            ),
            if (_selectedPlan == 'yearly')
              Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.savings, color: Colors.green[700], size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Save 17% with yearly plan',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitsSection(
    BuildContext context,
    List<Map<String, String>> benefits,
    bool isDark,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Premium Benefits',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...benefits.map(
              (benefit) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withAlpha(
                          (0.1 * 255).toInt(),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getIconForBenefit(benefit['icon']!),
                        color: AppColors.primaryBlue,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            benefit['title']!,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            benefit['description']!,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Theme.of(context).hintColor),
                          ),
                        ],
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

  Widget _buildUpgradeButton(BuildContext context) {
    return CustomButton.primary(
      text: _isLoading ? 'Processing...' : 'Upgrade to Premium',
      onPressed: _isLoading ? null : _handleUpgrade,
      isLoading: _isLoading,
      icon: Icons.star,
    );
  }

  Widget _buildFeatureComparisonSection(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    return Container(
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
                  : [Colors.white, const Color(0xFFF8FAFC)],
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
                    ? Colors.black.withAlpha((0.2 * 255).toInt())
                    : const Color(0xFF64748B).withAlpha((0.1 * 255).toInt()),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF0092DF), Color(0xFF0077CC)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF0092DF,
                          ).withAlpha((0.3 * 255).toInt()),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.compare_arrows_rounded,
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
                          'Feature Comparison',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color:
                                isDark ? Colors.white : const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'See what you\'re missing with Premium',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color:
                                isDark
                                    ? Colors.white70
                                    : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Quick comparison preview
              Row(
                children: [
                  Expanded(
                    child: _ComparisonPreviewCard(
                      title: 'Basic',
                      color: const Color(0xFF0092DF),
                      features: ['Basic ECG', 'Simple Metrics', 'Basic Alerts'],
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ComparisonPreviewCard(
                      title: 'Premium',
                      color: const Color(0xFFFFD700),
                      features: [
                        'Advanced AI',
                        'Full Analytics',
                        'Priority Support',
                      ],
                      isDark: isDark,
                      isPremium: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Enhanced button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0092DF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 4,
                    shadowColor: const Color(
                      0xFF0092DF,
                    ).withAlpha((0.3 * 255).toInt()),
                    textStyle: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    _showEnhancedFeatureComparison(context, isDark);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.visibility_rounded, size: 22),
                      const SizedBox(width: 10),
                      const Text('View Detailed Comparison'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEnhancedFeatureComparison(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    // Fallback feature comparison data if provider is not available
    final Map<String, Map<String, dynamic>> featureComparison = {
      'ECG Analysis': {
        'basic': 'Simple Normal/Abnormal display',
        'premium': 'Advanced AI analysis with detailed insights',
        'basic_icon': Icons.favorite,
        'premium_icon': Icons.psychology,
      },
      'Data History': {
        'basic': 'Current readings only',
        'premium': 'Historical data with trend analysis',
        'basic_icon': Icons.today,
        'premium_icon': Icons.history,
      },
      'Health Insights': {
        'basic': 'Basic recommendations',
        'premium': 'AI-powered personalized insights',
        'basic_icon': Icons.lightbulb_outline,
        'premium_icon': Icons.lightbulb,
      },
      'Data Export': {
        'basic': 'Not available',
        'premium': 'Full data export for medical use',
        'basic_icon': Icons.block,
        'premium_icon': Icons.download,
      },
      'Health Score': {
        'basic': 'Not available',
        'premium': 'Comprehensive health scoring system',
        'basic_icon': Icons.block,
        'premium_icon': Icons.health_and_safety,
      },
      'AI Coach': {
        'basic': 'Basic recommendations',
        'premium': 'Advanced AI coaching with personalization',
        'basic_icon': Icons.support_agent,
        'premium_icon': Icons.psychology,
      },
    };

    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors:
                      isDark
                          ? [const Color(0xFF1E293B), const Color(0xFF334155)]
                          : [Colors.white, const Color(0xFFF8FAFC)],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF0092DF), Color(0xFF0077CC)],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.compare_arrows_rounded,
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
                                'Basic vs Premium Features',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Comprehensive feature comparison',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: Colors.white),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.2),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // Feature comparison table
                          Container(
                            decoration: BoxDecoration(
                              color:
                                  isDark
                                      ? const Color(0xFF1E293B).withOpacity(0.8)
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color:
                                    isDark
                                        ? const Color(
                                          0xFF475569,
                                        ).withOpacity(0.3)
                                        : const Color(0xFFE2E8F0),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      isDark
                                          ? Colors.black.withOpacity(0.3)
                                          : Colors.grey.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Enhanced table header
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors:
                                          isDark
                                              ? [
                                                const Color(
                                                  0xFF475569,
                                                ).withOpacity(0.4),
                                                const Color(
                                                  0xFF334155,
                                                ).withOpacity(0.4),
                                              ]
                                              : [
                                                const Color(0xFFF8FAFC),
                                                const Color(0xFFF1F5F9),
                                              ],
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Feature',
                                          style: theme.textTheme.titleLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    isDark
                                                        ? Colors.white
                                                        : const Color(
                                                          0xFF1E293B,
                                                        ),
                                              ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF0092DF),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: const Color(
                                                      0xFF0092DF,
                                                    ).withOpacity(0.15),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.person_outline,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Flexible(
                                                    child: Text(
                                                      'Basic',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: theme
                                                          .textTheme
                                                          .labelMedium
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xFFFFD700),
                                                    Color(0xFFFFA500),
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: const Color(
                                                      0xFFFFA500,
                                                    ).withOpacity(0.15),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.star,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Flexible(
                                                    child: Text(
                                                      'Premium',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: theme
                                                          .textTheme
                                                          .labelMedium
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Enhanced feature rows
                                ...featureComparison.entries.map(
                                  (entry) => Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color:
                                              isDark
                                                  ? const Color(
                                                    0xFF475569,
                                                  ).withOpacity(0.2)
                                                  : const Color(0xFFE2E8F0),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      isDark
                                                          ? const Color(
                                                            0xFF475569,
                                                          ).withOpacity(0.3)
                                                          : const Color(
                                                            0xFFF1F5F9,
                                                          ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Icon(
                                                  _getFeatureIcon(entry.key),
                                                  color:
                                                      isDark
                                                          ? Colors.white70
                                                          : const Color(
                                                            0xFF64748B,
                                                          ),
                                                  size: 20,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  entry.key,
                                                  style: theme
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            isDark
                                                                ? Colors.white
                                                                : const Color(
                                                                  0xFF1E293B,
                                                                ),
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  12,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFF0092DF,
                                                  ).withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: const Color(
                                                      0xFF0092DF,
                                                    ).withOpacity(0.2),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Icon(
                                                  entry.value['basic_icon']
                                                      as IconData,
                                                  color: const Color(
                                                    0xFF0092DF,
                                                  ),
                                                  size: 28,
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              Text(
                                                entry.value['basic'] as String,
                                                style: theme
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color:
                                                          isDark
                                                              ? Colors.white70
                                                              : const Color(
                                                                0xFF64748B,
                                                              ),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  12,
                                                ),
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                        colors: [
                                                          Color(0xFFFFD700),
                                                          Color(0xFFFFA500),
                                                        ],
                                                      ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color(
                                                        0xFFFFA500,
                                                      ).withOpacity(0.2),
                                                      blurRadius: 8,
                                                      offset: const Offset(
                                                        0,
                                                        4,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: const Icon(
                                                  Icons.star,
                                                  color: Colors.white,
                                                  size: 28,
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              Text(
                                                entry.value['premium']
                                                    as String,
                                                style: theme
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color:
                                                          isDark
                                                              ? Colors.white70
                                                              : const Color(
                                                                0xFF64748B,
                                                              ),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          Center(
                            child: SizedBox(
                              width: 220,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _handleUpgrade,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 6,
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFFFFA500),
                                  shadowColor: const Color(
                                    0xFFFFA500,
                                  ).withOpacity(0.2),
                                  textStyle: theme.textTheme.titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.1,
                                      ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.workspace_premium,
                                      color: Color(0xFFFFA500),
                                    ),
                                    const SizedBox(width: 10),
                                    Text('Upgrade to Premium'),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  IconData _getIconForBenefit(String iconName) {
    switch (iconName) {
      case 'favorite':
        return Icons.favorite;
      case 'timeline':
        return Icons.timeline;
      case 'psychology':
        return Icons.psychology;
      case 'download':
        return Icons.download;
      case 'dashboard':
        return Icons.dashboard;
      case 'health_and_safety':
        return Icons.health_and_safety;
      case 'support_agent':
        return Icons.support_agent;
      default:
        return Icons.star;
    }
  }

  IconData _getFeatureIcon(String featureName) {
    switch (featureName) {
      case 'ECG Analysis':
        return Icons.favorite;
      case 'Data History':
        return Icons.history;
      case 'Health Insights':
        return Icons.lightbulb_outline;
      case 'Data Export':
        return Icons.download;
      case 'Health Score':
        return Icons.health_and_safety;
      case 'AI Coach':
        return Icons.psychology;
      default:
        return Icons.info_outline;
    }
  }

  Future<void> _handleUpgrade() async {
    setState(() => _isLoading = true);

    try {
      // Simulate upgrade process
      await Future.delayed(const Duration(seconds: 2));

      // Update user type to premium
      await ref.read(authStateProvider.notifier).upgradeToPremium();

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully upgraded to Premium!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to dashboard
      context.go('/main/dashboard');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upgrade failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

class _PlanOption extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isRecommended;

  const _PlanOption({
    required this.title,
    required this.price,
    required this.period,
    required this.isSelected,
    required this.onTap,
    this.isRecommended = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            if (isRecommended)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'RECOMMENDED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (isRecommended) const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              period,
              style: TextStyle(
                color: isSelected ? Colors.white70 : Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComparisonPreviewCard extends StatelessWidget {
  final String title;
  final Color color;
  final List<String> features;
  final bool isDark;
  final bool isPremium;

  const _ComparisonPreviewCard({
    required this.title,
    required this.color,
    required this.features,
    required this.isDark,
    this.isPremium = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF334155).withOpacity(0.3) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha((0.1 * 255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient:
                  isPremium
                      ? const LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                      )
                      : null,
              color: isPremium ? null : color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              title,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(
                    isPremium ? Icons.star : Icons.check,
                    color: color,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      feature,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            isDark ? Colors.white70 : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
