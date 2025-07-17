import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/ecg_analysis_provider.dart';
import '../../../shared/widgets/buttons/custom_button.dart';
import '../../../shared/widgets/cards/ecg_ai_analysis_card.dart';
import '../../../shared/widgets/cards/premium_recommendation_card.dart';
import '../../../shared/widgets/navigation/premium_tabbar.dart';
import '../../../shared/widgets/sections/section_header.dart';

class EcgAnalysisScreen extends ConsumerStatefulWidget {
  final int initialTab;
  const EcgAnalysisScreen({super.key, this.initialTab = 0});

  @override
  ConsumerState<EcgAnalysisScreen> createState() => _EcgAnalysisScreenState();
}

class _EcgAnalysisScreenState extends ConsumerState<EcgAnalysisScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedTab = index;
      _tabController.animateTo(index);
    });
  }

  final List<_PremiumTabData> _tabs = const [
    _PremiumTabData('Overview', Icons.insights),
    _PremiumTabData('History', Icons.history),
    _PremiumTabData('Trends', Icons.show_chart),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTab,
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() {
        _selectedTab = _tabController.index;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ecgAnalysisResultProvider.notifier).initialize();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('ECG Analysis'),
        backgroundColor: Colors.transparent,
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
          _buildOverviewTab(context, theme, isDark),
          _buildHistoryTab(context, theme, isDark),
          _buildTrendsTab(context, theme, isDark),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, ThemeData theme, bool isDark) {
    final analysisState = ref.watch(ecgAnalysisResultProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPremiumSignalCard(context, theme, isDark),
          const SizedBox(height: 16),
          analysisState.when(
            data:
                (result) => EcgAiAnalysisCard(
                  result: result,
                  onAnalyzeTap: _performEcgAnalysis,
                  showAnalyzeButton: result == null,
                ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error:
                (error, stack) => Column(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Analysis Error',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Unable to analyze ECG signal. Please try again.',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    CustomButton.primary(
                      text: 'Retry Analysis',
                      onPressed: _performEcgAnalysis,
                      icon: Icons.refresh,
                    ),
                  ],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumSignalCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
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
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.show_chart, color: AppColors.primaryBlue, size: 24),
                const SizedBox(width: 8),
                Text(
                  'ECG Signal',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'PREMIUM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(height: 200, child: _buildEcgChart(context, theme)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSignalMetric(
                    'Heart Rate',
                    '72 BPM',
                    Icons.favorite,
                  ),
                ),
                Expanded(
                  child: _buildSignalMetric(
                    'Signal Quality',
                    '95%',
                    Icons.signal_cellular_alt,
                  ),
                ),
                Expanded(
                  child: _buildSignalMetric('Duration', '30s', Icons.timer),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEcgChart(BuildContext context, ThemeData theme) {
    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: _EcgChartPainter(),
    );
  }

  Widget _buildSignalMetric(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryBlue, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildHistoryTab(BuildContext context, ThemeData theme, bool isDark) {
    final history = ref.watch(ecgAnalysisHistoryProvider);
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final result = history[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 3,
          child: ListTile(
            leading: Icon(
              result.isAbnormal ? Icons.warning : Icons.check_circle,
              color: result.isAbnormal ? Colors.red : Colors.green,
            ),
            title: Text(result.classification),
            subtitle: Text(
              '${result.confidencePercentage}% confidence - ${result.timestamp.toString().substring(0, 16)}',
            ),
            trailing: Text(
              result.isAbnormal ? 'Abnormal' : 'Normal',
              style: TextStyle(
                color: result.isAbnormal ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrendsTab(BuildContext context, ThemeData theme, bool isDark) {
    final stats = ref.watch(ecgAnalysisStatsProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.analytics,
                        color: AppColors.primaryBlue,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Analysis Statistics',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          'Total Analyses',
                          '${stats['totalAnalyses']}',
                          Icons.assessment,
                        ),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          'Abnormal Rate',
                          '${(stats['abnormalRate'] * 100).round()}%',
                          Icons.warning,
                        ),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          'Avg Confidence',
                          '${(stats['averageConfidence'] * 100).round()}%',
                          Icons.verified,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Personalized AI Advice Section
          const SectionHeader(
            title: 'Personalized AI Advice',
            icon: Icons.psychology,
            iconColor: Colors.deepPurple,
          ),
          const SizedBox(height: 8),
          PremiumRecommendationCard(
            icon: Icons.favorite,
            title: 'Monitor Irregularities',
            description:
                'Your abnormal ECG rate is slightly elevated. Consider consulting a cardiologist if you notice symptoms.',
            priority: 'High',
            priorityColor: Colors.orange,
            actionText: 'Find a Specialist',
            onAction: () {},
          ),
          PremiumRecommendationCard(
            icon: Icons.directions_walk,
            title: 'Stay Active',
            description:
                'Regular physical activity can help maintain a healthy heart rhythm.',
            priority: 'Medium',
            priorityColor: Colors.green,
            actionText: 'View Activity Tips',
            onAction: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryBlue, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Future<void> _performEcgAnalysis() async {
    // Generate mock ECG data for demonstration
    final mockEcgData = _generateMockEcgData();
    ref.read(ecgSignalDataProvider.notifier).setSignalData(mockEcgData);
    await ref
        .read(ecgAnalysisResultProvider.notifier)
        .analyzeEcgSignal(mockEcgData);
    final result = ref.read(ecgAnalysisResultProvider).value;
    if (result != null) {
      ref.read(ecgAnalysisHistoryProvider.notifier).addResult(result);
    }
  }

  List<double> _generateMockEcgData() {
    final random = Random();
    final data = <double>[];
    for (int i = 0; i < 1000; i++) {
      final t = i / 100.0;
      final signal =
          0.5 * sin(2 * pi * 1.2 * t) +
          0.1 * sin(2 * pi * 2.4 * t) +
          0.05 * random.nextDouble();
      data.add(signal);
    }
    return data;
  }
}

class _PremiumTabData {
  final String label;
  final IconData icon;
  const _PremiumTabData(this.label, this.icon);
}

class _EcgChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppColors.primaryBlue
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;
    final path = Path();
    final random = Random(42);
    for (int i = 0; i < size.width.toInt(); i++) {
      final x = i.toDouble();
      final t = i / 50.0;
      final signal =
          0.3 * sin(2 * pi * 1.2 * t) +
          0.1 * sin(2 * pi * 2.4 * t) +
          0.05 * random.nextDouble();
      final y = size.height / 2 + signal * size.height / 2;
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
