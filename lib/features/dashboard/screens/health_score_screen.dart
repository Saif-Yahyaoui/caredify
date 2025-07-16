import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/services/auth_service.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/role_based_access.dart';
import '../../../shared/widgets/premium_tabbar.dart';
import '../../../shared/widgets/premium_recommendation_card.dart';

class HealthScoreScreen extends ConsumerStatefulWidget {
  const HealthScoreScreen({super.key});

  @override
  ConsumerState<HealthScoreScreen> createState() => _HealthScoreScreenState();
}

class _HealthScoreScreenState extends ConsumerState<HealthScoreScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  double _overallScore = 87.0;
  String _currentGrade = 'B+';
  bool _isLoading = false;
  int _selectedTab = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedTab = index;
      _tabController.animateTo(index);
    });
  }

  final List<_PremiumTabData> _tabs = const [
    _PremiumTabData('Overview', Icons.dashboard),
    _PremiumTabData('Breakdown', Icons.bar_chart),
    _PremiumTabData('Trends', Icons.trending_up),
  ];

  final Map<String, double> _categoryScores = {
    'Heart Health': 92.0,
    'Physical Activity': 78.0,
    'Sleep Quality': 85.0,
    'Nutrition': 82.0,
    'Stress Management': 75.0,
    'Hydration': 90.0,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() {
        _selectedTab = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return RoleBasedAccess(
      allowedUserTypes: const [UserType.premium],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Health Score'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
            onPressed: () => context.go('/main/dashboard'),
          ),
          foregroundColor: theme.colorScheme.onSurface,
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: PremiumTabBar(
              tabs: _tabs.map((t) => TabData(t.label, t.icon)).toList(),
              selectedIndex: _selectedTab,
              onTabSelected: _onTabSelected,
              isDark: isDark,
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(context, isDark),
            _buildBreakdownTab(context, isDark),
            _buildTrendsTab(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildScoreHeader(context, isDark),
          const SizedBox(height: 16),
          _buildGradeCard(context, isDark),
          const SizedBox(height: 16),
          _buildScoreExplanation(context, isDark),
          const SizedBox(height: 16),
          _buildQuickActions(context, isDark),
          const SizedBox(height: 16),
          _buildRecommendations(context, isDark),
        ],
      ),
    );
  }

  Widget _buildScoreHeader(BuildContext context, bool isDark) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Container(
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
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              'Your Health Score',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: _overallScore / 100,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getScoreColor(_overallScore),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _overallScore.toStringAsFixed(0),
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getScoreColor(_overallScore),
                        ),
                      ),
                      Text(
                        'out of 100',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              isDark ? Colors.white70 : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Last updated: Today at 10:30 AM',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark ? Colors.white70 : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeCard(BuildContext context, bool isDark) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.grade,
                  color: _getScoreColor(_overallScore),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Health Grade',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _getScoreColor(
                  _overallScore,
                ).withAlpha((0.1 * 255).toInt()),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getScoreColor(
                    _overallScore,
                  ).withAlpha((0.3 * 255).toInt()),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _getScoreColor(_overallScore),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        _currentGrade,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getGradeDescription(_currentGrade),
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _getScoreColor(_overallScore),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getGradeMessage(_currentGrade),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Theme.of(context).hintColor),
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
    );
  }

  Widget _buildScoreExplanation(BuildContext context, bool isDark) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info, color: AppColors.primaryBlue, size: 24),
                const SizedBox(width: 8),
                Text(
                  'How Your Score is Calculated',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _ScoreFactorItem(
              factor: 'Heart Health',
              weight: '25%',
              description: 'Heart rate, blood pressure, ECG readings',
              score: _categoryScores['Heart Health']!,
            ),
            const SizedBox(height: 8),
            _ScoreFactorItem(
              factor: 'Physical Activity',
              weight: '20%',
              description: 'Steps, exercise, movement patterns',
              score: _categoryScores['Physical Activity']!,
            ),
            const SizedBox(height: 8),
            _ScoreFactorItem(
              factor: 'Sleep Quality',
              weight: '20%',
              description: 'Sleep duration, quality, consistency',
              score: _categoryScores['Sleep Quality']!,
            ),
            const SizedBox(height: 8),
            _ScoreFactorItem(
              factor: 'Nutrition & Hydration',
              weight: '15%',
              description: 'Water intake, eating patterns',
              score:
                  (_categoryScores['Nutrition']! +
                      _categoryScores['Hydration']!) /
                  2,
            ),
            const SizedBox(height: 8),
            _ScoreFactorItem(
              factor: 'Stress Management',
              weight: '20%',
              description: 'Stress levels, relaxation practices',
              score: _categoryScores['Stress Management']!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isDark) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomButton.secondary(
                    text: 'Update Data',
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                      });
                      Future.delayed(const Duration(seconds: 2), () {
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                            _overallScore = 89.0;
                            _currentGrade = 'A-';
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Health score updated!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      });
                    },
                    isLoading: _isLoading,
                    icon: Icons.refresh,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton.secondary(
                    text: 'Share Score',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Health score shared!'),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    },
                    icon: Icons.share,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendations(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Improvement Recommendations',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        PremiumRecommendationCard(
          icon: Icons.directions_walk,
          title: 'Increase Physical Activity',
          description:
              'Your activity level is below optimal. Aim for 10,000 steps daily.',
          priority: 'High',
          priorityColor: Colors.orange,
          actionText: 'Start Activity Tracker',
          onAction: () {
            // TODO: Implement action
          },
        ),
        PremiumRecommendationCard(
          icon: Icons.bedtime,
          title: 'Improve Sleep Consistency',
          description: 'Maintain a regular sleep schedule for better quality.',
          priority: 'Medium',
          priorityColor: Colors.blue,
          actionText: 'View Sleep Tips',
          onAction: () {
            // TODO: Implement action
          },
        ),
        PremiumRecommendationCard(
          icon: Icons.self_improvement,
          title: 'Stress Management',
          description: 'Practice daily meditation or deep breathing exercises.',
          priority: 'Medium',
          priorityColor: Colors.green,
          actionText: 'Start Meditation',
          onAction: () {
            // TODO: Implement action
          },
        ),
      ],
    );
  }

  Widget _buildBreakdownTab(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCategoryBreakdown(context, isDark),
          const SizedBox(height: 16),
          _buildDetailedMetrics(context, isDark),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown(BuildContext context, bool isDark) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Breakdown',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ..._categoryScores.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _CategoryScoreItem(
                  category: entry.key,
                  score: entry.value,
                  color: _getScoreColor(entry.value),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedMetrics(BuildContext context, bool isDark) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detailed Metrics',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const _DetailedMetricItem(
              metric: 'Resting Heart Rate',
              value: '72 BPM',
              status: 'Excellent',
              color: Colors.green,
              trend: '↓2 BPM this week',
            ),
            const SizedBox(height: 8),
            const _DetailedMetricItem(
              metric: 'Daily Steps',
              value: '8,500',
              status: 'Good',
              color: Colors.orange,
              trend: '↑500 steps this week',
            ),
            const SizedBox(height: 8),
            const _DetailedMetricItem(
              metric: 'Sleep Duration',
              value: '7.5 hours',
              status: 'Good',
              color: Colors.blue,
              trend: '↑0.3 hours this week',
            ),
            const SizedBox(height: 8),
            const _DetailedMetricItem(
              metric: 'Water Intake',
              value: '2.1L',
              status: 'Excellent',
              color: Colors.cyan,
              trend: '↑0.2L this week',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendsTab(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildScoreTrend(context, isDark),
          const SizedBox(height: 16),
          _buildGradeHistory(context, isDark),
          const SizedBox(height: 16),
          _buildImprovementAreas(context, isDark),
        ],
      ),
    );
  }

  Widget _buildScoreTrend(BuildContext context, isDark) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Score Trend (30 Days)',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: CustomPaint(
                size: const Size(double.infinity, double.infinity),
                painter: ScoreTrendPainter(isDark: isDark),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _TrendMetric(
                  title: 'Current',
                  value: '87',
                  color: AppColors.primaryBlue,
                ),
                _TrendMetric(title: 'Average', value: '84', color: Colors.grey),
                _TrendMetric(title: 'Best', value: '92', color: Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeHistory(BuildContext context, bool isDark) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Grade History',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _GradeHistoryItem(
              date: 'Today',
              grade: 'B+',
              score: 87,
              color: _getScoreColor(87),
            ),
            const SizedBox(height: 8),
            _GradeHistoryItem(
              date: '1 week ago',
              grade: 'B',
              score: 82,
              color: _getScoreColor(82),
            ),
            const SizedBox(height: 8),
            _GradeHistoryItem(
              date: '2 weeks ago',
              grade: 'B-',
              score: 78,
              color: _getScoreColor(78),
            ),
            const SizedBox(height: 8),
            _GradeHistoryItem(
              date: '1 month ago',
              grade: 'C+',
              score: 75,
              color: _getScoreColor(75),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImprovementAreas(BuildContext context, bool isDark) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Areas for Improvement',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const _ImprovementAreaItem(
              area: 'Physical Activity',
              currentScore: 78,
              targetScore: 90,
              improvement: '+12 points',
              action: 'Increase daily steps to 10,000',
            ),
            const SizedBox(height: 8),
            const _ImprovementAreaItem(
              area: 'Stress Management',
              currentScore: 75,
              targetScore: 85,
              improvement: '+10 points',
              action: 'Practice daily meditation',
            ),
            const SizedBox(height: 8),
            const _ImprovementAreaItem(
              area: 'Sleep Consistency',
              currentScore: 85,
              targetScore: 95,
              improvement: '+10 points',
              action: 'Maintain regular sleep schedule',
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 90) return Colors.green;
    if (score >= 80) return Colors.blue;
    if (score >= 70) return Colors.orange;
    if (score >= 60) return Colors.red;
    return Colors.red[700]!;
  }

  String _getGradeDescription(String grade) {
    switch (grade) {
      case 'A+':
      case 'A':
      case 'A-':
        return 'Excellent Health';
      case 'B+':
      case 'B':
      case 'B-':
        return 'Good Health';
      case 'C+':
      case 'C':
      case 'C-':
        return 'Fair Health';
      case 'D+':
      case 'D':
      case 'D-':
        return 'Poor Health';
      case 'F':
        return 'Critical Health';
      default:
        return 'Unknown';
    }
  }

  String _getGradeMessage(String grade) {
    switch (grade) {
      case 'A+':
      case 'A':
      case 'A-':
        return 'Keep up the excellent work!';
      case 'B+':
      case 'B':
      case 'B-':
        return 'You\'re doing well, with room for improvement.';
      case 'C+':
      case 'C':
      case 'C-':
        return 'Focus on improving key health areas.';
      case 'D+':
      case 'D':
      case 'D-':
        return 'Consider consulting a healthcare provider.';
      case 'F':
        return 'Immediate medical attention recommended.';
      default:
        return 'Unknown';
    }
  }
}

class _ScoreFactorItem extends StatelessWidget {
  final String factor;
  final String weight;
  final String description;
  final double score;

  const _ScoreFactorItem({
    required this.factor,
    required this.weight,
    required this.description,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                factor,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          weight,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 8),
        Text(
          score.toStringAsFixed(0),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: _getScoreColor(score),
          ),
        ),
      ],
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 90) return Colors.green;
    if (score >= 80) return Colors.blue;
    if (score >= 70) return Colors.orange;
    if (score >= 60) return Colors.red;
    return Colors.red[700]!;
  }
}

class _RecommendationItem extends StatelessWidget {
  final String title;
  final String description;
  final String priority;
  final String impact;

  const _RecommendationItem({
    required this.title,
    required this.description,
    required this.priority,
    required this.impact,
  });

  @override
  Widget build(BuildContext context) {
    final priorityColor =
        priority == 'High'
            ? Colors.red
            : priority == 'Medium'
            ? Colors.orange
            : Colors.green;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: priorityColor.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: priorityColor.withAlpha((0.3 * 255).toInt())),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  priority,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
          ),
          const SizedBox(height: 4),
          Text(
            'Potential impact: $impact',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: priorityColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryScoreItem extends StatelessWidget {
  final String category;
  final double score;
  final Color color;

  const _CategoryScoreItem({
    required this.category,
    required this.score,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha((0.3 * 255).toInt())),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: score / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            score.toStringAsFixed(0),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailedMetricItem extends StatelessWidget {
  final String metric;
  final String value;
  final String status;
  final Color color;
  final String trend;

  const _DetailedMetricItem({
    required this.metric,
    required this.value,
    required this.status,
    required this.color,
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha((0.3 * 255).toInt())),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metric,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                status,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                trend,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).hintColor,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ScoreTrendPainter extends CustomPainter {
  final bool isDark;

  ScoreTrendPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppColors.primaryBlue
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;

    final path = Path();
    final data = [75, 78, 82, 85, 87, 89, 87];
    final stepX = size.width / (data.length - 1);
    final maxValue = data.reduce((a, b) => a > b ? a : b).toDouble();
    final minValue = data.reduce((a, b) => a < b ? a : b).toDouble();

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final normalizedValue = (data[i] - minValue) / (maxValue - minValue);
      final y = size.height - (normalizedValue * size.height * 0.8);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TrendMetric extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _TrendMetric({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _GradeHistoryItem extends StatelessWidget {
  final String date;
  final String grade;
  final int score;
  final Color color;

  const _GradeHistoryItem({
    required this.date,
    required this.grade,
    required this.score,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha((0.3 * 255).toInt())),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                grade,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Score: $score',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  date,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
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

class _ImprovementAreaItem extends StatelessWidget {
  final String area;
  final int currentScore;
  final int targetScore;
  final String improvement;
  final String action;

  const _ImprovementAreaItem({
    required this.area,
    required this.currentScore,
    required this.targetScore,
    required this.improvement,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withAlpha((0.3 * 255).toInt())),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  area,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                improvement,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$currentScore → $targetScore',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
          ),
          const SizedBox(height: 4),
          Text(
            action,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.orange,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumTabData {
  final String label;
  final IconData icon;
  const _PremiumTabData(this.label, this.icon);
}
