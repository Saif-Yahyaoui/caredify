import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/services/auth_service.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/role_based_access.dart';
import '../../../shared/widgets/premium_tabbar.dart';
import '../../../shared/widgets/premium_recommendation_card.dart';
import '../../../shared/widgets/section_header.dart';

class AdvancedCoachAiScreen extends ConsumerStatefulWidget {
  const AdvancedCoachAiScreen({super.key});

  @override
  ConsumerState<AdvancedCoachAiScreen> createState() =>
      _AdvancedCoachAiScreenState();
}

class _AdvancedCoachAiScreenState extends ConsumerState<AdvancedCoachAiScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedGoal = 'Improve Heart Health';
  int _selectedTab = 0;

  final List<String> _availableGoals = [
    'Improve Heart Health',
    'Increase Physical Activity',
    'Better Sleep Quality',
    'Manage Stress Levels',
    'Improve Hydration',
    'Weight Management',
    'Blood Pressure Control',
    'Diabetes Management',
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedTab = index;
      _tabController.animateTo(index);
    });
  }

  final List<_PremiumTabData> _tabs = const [
    _PremiumTabData('Dashboard', Icons.dashboard),
    _PremiumTabData('Goals', Icons.flag),
    _PremiumTabData('Progress', Icons.show_chart),
  ];

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
          title: const Text('AI Health Coach'),
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
            _buildDashboardTab(context, isDark),
            _buildGoalsTab(context, isDark),
            _buildProgressTab(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTab(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCoachHeader(context, isDark),
          const SizedBox(height: 16),
          _buildCurrentGoalCard(context, isDark),
          const SizedBox(height: 16),
          // Today's Recommendations Section
          const SectionHeader(
            title: "Today's Recommendations",
            icon: Icons.lightbulb,
            iconColor: Colors.amber,
          ),
          const SizedBox(height: 8),
          PremiumRecommendationCard(
            icon: Icons.favorite,
            title: 'Monitor Heart Rate',
            description: 'Check your heart rate after your next workout.',
            priority: 'High',
            priorityColor: Colors.red,
            actionText: 'Check Now',
            onAction: () {},
          ),
          PremiumRecommendationCard(
            icon: Icons.local_florist,
            title: 'Practice Gratitude',
            description: 'Write down 3 things you are grateful for today.',
            priority: 'Medium',
            priorityColor: Colors.blue,
            actionText: 'Start Journal',
            onAction: () {},
          ),
          PremiumRecommendationCard(
            icon: Icons.nightlight_round,
            title: 'Wind Down Early',
            description:
                'Aim to start your bedtime routine 30 minutes earlier.',
            priority: 'Low',
            priorityColor: Colors.green,
            actionText: 'View Sleep Tips',
            onAction: () {},
          ),
          const SizedBox(height: 16),
          _buildWeeklyInsights(context, isDark),
          const SizedBox(height: 16),
          _buildMotivationalQuote(context, isDark),
        ],
      ),
    );
  }

  Widget _buildCoachHeader(BuildContext context, bool isDark) {
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
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
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
                Icons.psychology,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your AI Health Coach',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Personalized guidance for better health',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.white70 : const Color(0xFF64748B),
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

  Widget _buildCurrentGoalCard(BuildContext context, bool isDark) {
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
                const Icon(Icons.flag, color: AppColors.primaryBlue, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Current Goal',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withAlpha((0.1 * 255).toInt()),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryBlue.withAlpha((0.3 * 255).toInt()),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedGoal,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: 0.75,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '75% Complete • 3 weeks remaining',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).hintColor,
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

  Widget _buildTodayRecommendations(BuildContext context, bool isDark) {
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
                const Icon(Icons.lightbulb, color: Colors.amber, size: 24),
                const SizedBox(width: 8),
                Text(
                  "Today's Recommendations",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const _RecommendationItem(
              title: 'Morning Walk',
              description: 'Take a 30-minute walk to improve heart health',
              icon: Icons.directions_walk,
              color: Colors.green,
              priority: 'High',
            ),
            const SizedBox(height: 8),
            const _RecommendationItem(
              title: 'Hydration Check',
              description: 'Drink 8 glasses of water today',
              icon: Icons.water_drop,
              color: Colors.blue,
              priority: 'Medium',
            ),
            const SizedBox(height: 8),
            const _RecommendationItem(
              title: 'Stress Management',
              description: 'Practice 10 minutes of meditation',
              icon: Icons.self_improvement,
              color: Colors.purple,
              priority: 'Medium',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyInsights(BuildContext context, bool isDark) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Weekly Insights',
              icon: Icons.analytics,
              iconColor: Colors.orange,
            ),
            const SizedBox(height: 16),
            const _InsightItem(
              title: 'Heart Rate Improvement',
              description:
                  'Your average heart rate decreased by 5 BPM this week',
              icon: Icons.trending_down,
              color: Colors.green,
            ),
            const SizedBox(height: 8),
            const _InsightItem(
              title: 'Sleep Quality',
              description: 'Sleep duration increased by 30 minutes on average',
              icon: Icons.bedtime,
              color: Colors.blue,
            ),
            const SizedBox(height: 8),
            const _InsightItem(
              title: 'Activity Level',
              description: 'You exceeded your daily step goal 5 out of 7 days',
              icon: Icons.directions_run,
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationalQuote(BuildContext context, bool isDark) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.withAlpha((0.1 * 255).toInt()),
              Colors.blue.withAlpha((0.1 * 255).toInt()),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            const Icon(Icons.format_quote, color: Colors.purple, size: 32),
            const SizedBox(height: 12),
            Text(
              '"The only bad workout is the one that didn\'t happen."',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '- Your AI Coach',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsTab(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildGoalSettingCard(context, isDark),
          const SizedBox(height: 16),
          _buildActiveGoalsList(context, isDark),
          const SizedBox(height: 16),
          _buildCompletedGoalsList(context, isDark),
        ],
      ),
    );
  }

  Widget _buildGoalSettingCard(BuildContext context, bool isDark) {
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
                const Icon(
                  Icons.add_circle,
                  color: AppColors.primaryBlue,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Set New Goal',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGoal,
              decoration: InputDecoration(
                labelText: 'Select Goal',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items:
                  _availableGoals.map((goal) {
                    return DropdownMenuItem(value: goal, child: Text(goal));
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedGoal = value);
                }
              },
            ),
            const SizedBox(height: 16),
            CustomButton.primary(
              text: 'Create Goal',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Goal "$_selectedGoal" created successfully!',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              icon: Icons.add,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveGoalsList(BuildContext context, bool isDark) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Active Goals',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const _GoalItem(
              title: 'Improve Heart Health',
              description: 'Reduce resting heart rate by 10 BPM',
              progress: 0.75,
              deadline: '3 weeks remaining',
              color: Colors.red,
            ),
            const SizedBox(height: 8),
            const _GoalItem(
              title: 'Increase Physical Activity',
              description: 'Achieve 10,000 steps daily',
              progress: 0.45,
              deadline: '5 weeks remaining',
              color: Colors.green,
            ),
            const SizedBox(height: 8),
            const _GoalItem(
              title: 'Better Sleep Quality',
              description: 'Get 8 hours of sleep nightly',
              progress: 0.60,
              deadline: '2 weeks remaining',
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedGoalsList(BuildContext context, bool isDark) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Completed Goals',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const _CompletedGoalItem(
              title: 'Improve Hydration',
              description: 'Drink 8 glasses of water daily',
              completedDate: '2 weeks ago',
              color: Colors.cyan,
            ),
            const SizedBox(height: 8),
            const _CompletedGoalItem(
              title: 'Stress Management',
              description: 'Practice daily meditation',
              completedDate: '1 month ago',
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressTab(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProgressOverview(context, isDark),
          const SizedBox(height: 16),
          _buildProgressCharts(context, isDark),
          const SizedBox(height: 16),
          _buildAchievementsList(context, isDark),
        ],
      ),
    );
  }

  Widget _buildProgressOverview(BuildContext context, bool isDark) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progress Overview',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(
                  child: _ProgressMetric(
                    title: 'Goals Completed',
                    value: '8',
                    subtitle: 'This month',
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _ProgressMetric(
                    title: 'Streak',
                    value: '12',
                    subtitle: 'Days',
                    icon: Icons.local_fire_department,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(
                  child: _ProgressMetric(
                    title: 'Health Score',
                    value: '87',
                    subtitle: 'Points',
                    icon: Icons.health_and_safety,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _ProgressMetric(
                    title: 'Improvement',
                    value: '+15%',
                    subtitle: 'This week',
                    icon: Icons.trending_up,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCharts(BuildContext context, bool isDark) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Progress',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: CustomPaint(
                size: const Size(double.infinity, double.infinity),
                painter: ProgressChartPainter(isDark: isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsList(BuildContext context, bool isDark) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Achievements',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const _AchievementItem(
              title: 'First Goal Completed',
              description: 'Successfully completed your first health goal',
              icon: Icons.emoji_events,
              color: Colors.amber,
              date: '2 days ago',
            ),
            const SizedBox(height: 8),
            const _AchievementItem(
              title: '7-Day Streak',
              description: 'Maintained daily activity for 7 consecutive days',
              icon: Icons.local_fire_department,
              color: Colors.orange,
              date: '1 week ago',
            ),
            const SizedBox(height: 8),
            const _AchievementItem(
              title: 'Heart Health Champion',
              description: 'Improved heart rate by 10 BPM',
              icon: Icons.favorite,
              color: Colors.red,
              date: '2 weeks ago',
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendationItem extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String priority;

  const _RecommendationItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.priority,
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
        color: color.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha((0.3 * 255).toInt())),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
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
                const SizedBox(height: 2),
                Text(
                  description,
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

class _InsightItem extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _InsightItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GoalItem extends StatelessWidget {
  final String title;
  final String description;
  final double progress;
  final String deadline;
  final Color color;

  const _GoalItem({
    required this.title,
    required this.description,
    required this.progress,
    required this.deadline,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flag, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          const SizedBox(height: 4),
          Text(
            deadline,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).hintColor,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletedGoalItem extends StatelessWidget {
  final String title;
  final String description;
  final String completedDate;
  final Color color;

  const _CompletedGoalItem({
    required this.title,
    required this.description,
    required this.completedDate,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withAlpha((0.3 * 255).toInt())),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),
          Text(
            completedDate,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).hintColor,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressMetric extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _ProgressMetric({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
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
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).hintColor,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressChartPainter extends CustomPainter {
  final bool isDark;

  ProgressChartPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppColors.primaryBlue
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;

    final path = Path();
    final data = [65, 70, 75, 80, 85, 87, 90];
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

class _AchievementItem extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String date;

  const _AchievementItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.date,
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
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),
          Text(
            date,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).hintColor,
              fontSize: 10,
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
