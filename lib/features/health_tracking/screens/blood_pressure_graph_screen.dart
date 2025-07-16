import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BloodPressureGraphScreen extends ConsumerStatefulWidget {
  const BloodPressureGraphScreen({super.key});

  @override
  ConsumerState<BloodPressureGraphScreen> createState() =>
      _BloodPressureGraphScreenState();
}

class _BloodPressureGraphScreenState
    extends ConsumerState<BloodPressureGraphScreen> {
  final List<int> _systolicData = [
    120,
    118,
    117,
    119,
    117,
    116,
    117,
    118,
    119,
    120,
    118,
    117,
  ];
  final List<int> _diastolicData = [
    80,
    78,
    75,
    77,
    75,
    74,
    75,
    76,
    77,
    78,
    76,
    75,
  ];
  final List<String> _timeLabels = [
    '00:00',
    '02:00',
    '04:00',
    '06:00',
    '08:00',
    '10:00',
    '12:00',
    '14:00',
    '16:00',
    '18:00',
    '20:00',
    '22:00',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Blood Pressure Analysis'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => context.go('/main/dashboard'),
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
            // Current Blood Pressure Status Card
            _buildCurrentStatusCard(context, theme, isDark),
            const SizedBox(height: 24),

            // Blood Pressure Graph Card
            _buildGraphCard(context, theme, isDark),
            const SizedBox(height: 24),

            // Analysis Card
            _buildAnalysisCard(context, theme, isDark),
            const SizedBox(height: 24),

            // Recommendations Card
            _buildRecommendationsCard(context, theme, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStatusCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    final currentSystolic = _systolicData.last;
    final currentDiastolic = _diastolicData.last;
    final status = _getBloodPressureStatus(currentSystolic, currentDiastolic);
    final statusColor = _getStatusColor(status);

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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF8B5CF6),
                        Color(0xFF7C3AED),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFF8B5CF6,
                        ).withAlpha((0.3 * 255).toInt()),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
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
                        'Current Blood Pressure',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Last updated: ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color:
                              isDark
                                  ? Colors.white.withAlpha((0.7 * 255).toInt())
                                  : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '$currentSystolic',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFEF4444),
                      ),
                    ),
                    Text(
                      'Systolic',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            isDark
                                ? Colors.white.withAlpha((0.7 * 255).toInt())
                                : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                Text(
                  '/',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color:
                        isDark
                            ? Colors.white.withAlpha((0.5 * 255).toInt())
                            : const Color(0xFF64748B),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '$currentDiastolic',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF3B82F6),
                      ),
                    ),
                    Text(
                      'Diastolic',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            isDark
                                ? Colors.white.withAlpha((0.7 * 255).toInt())
                                : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha((0.1 * 255).toInt()),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: statusColor.withAlpha((0.3 * 255).toInt()),
                    ),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGraphCard(BuildContext context, ThemeData theme, bool isDark) {
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '24-Hour Blood Pressure Trend',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: _buildBloodPressureChart(context, theme, isDark),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(context, theme, isDark, 'Avg Systolic', '117.8'),
                _buildStatItem(context, theme, isDark, 'Avg Diastolic', '76.2'),
                _buildStatItem(
                  context,
                  theme,
                  isDark,
                  'Pulse Pressure',
                  '41.6',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBloodPressureChart(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: BloodPressureChartPainter(
        systolicData: _systolicData,
        diastolicData: _diastolicData,
        timeLabels: _timeLabels,
        isDark: isDark,
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8B5CF6),
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color:
                isDark
                    ? Colors.white.withAlpha((0.7 * 255).toInt())
                    : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalysisCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.analytics_rounded,
                  color: Color(0xFF3B82F6),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Analysis',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Your blood pressure readings are within the normal range. The systolic pressure (top number) averages around 118 mmHg, and the diastolic pressure (bottom number) averages around 76 mmHg. Both values indicate healthy cardiovascular function.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color:
                    isDark
                        ? Colors.white.withAlpha((0.8 * 255).toInt())
                        : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.lightbulb_rounded,
                  color: Color(0xFFF59E0B),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Recommendations',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildRecommendationItem(
              context,
              theme,
              isDark,
              'Maintain regular exercise',
              'Physical activity helps keep blood pressure in check',
            ),
            const SizedBox(height: 12),
            _buildRecommendationItem(
              context,
              theme,
              isDark,
              'Reduce salt intake',
              'Lower sodium consumption can help maintain healthy BP',
            ),
            const SizedBox(height: 12),
            _buildRecommendationItem(
              context,
              theme,
              isDark,
              'Manage stress levels',
              'Stress management techniques can help regulate BP',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFF8B5CF6),
            shape: BoxShape.circle,
          ),
          margin: const EdgeInsets.only(top: 6),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color:
                      isDark
                          ? Colors.white.withAlpha((0.7 * 255).toInt())
                          : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getBloodPressureStatus(int systolic, int diastolic) {
    if (systolic < 120 && diastolic < 80) return 'Normal';
    if (systolic < 130 && diastolic < 80) return 'Elevated';
    if (systolic < 140 && diastolic < 90) return 'High Normal';
    if (systolic >= 140 || diastolic >= 90) return 'High';
    return 'Normal';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Normal':
        return Colors.green;
      case 'Elevated':
        return Colors.orange;
      case 'High Normal':
        return Colors.deepOrange;
      case 'High':
        return Colors.red;
      default:
        return Colors.green;
    }
  }
}

class BloodPressureChartPainter extends CustomPainter {
  final List<int> systolicData;
  final List<int> diastolicData;
  final List<String> timeLabels;
  final bool isDark;

  BloodPressureChartPainter({
    required this.systolicData,
    required this.diastolicData,
    required this.timeLabels,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final systolicPaint =
        Paint()
          ..color = const Color(0xFFEF4444)
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    final diastolicPaint =
        Paint()
          ..color = const Color(0xFF3B82F6)
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    final gridPaint =
        Paint()
          ..color =
              isDark
                  ? Colors.white.withAlpha((0.1 * 255).toInt())
                  : Colors.grey.withAlpha((0.2 * 255).toInt())
          ..strokeWidth = 1;

    // Draw grid lines
    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw systolic data
    if (systolicData.isNotEmpty) {
      final path = Path();
      final points = <Offset>[];

      for (int i = 0; i < systolicData.length; i++) {
        final x = size.width * i / (systolicData.length - 1);
        final normalizedValue =
            (systolicData[i] - 80) / (180 - 80); // Normalize to 80-180 range
        final y = size.height * (1 - normalizedValue.clamp(0.0, 1.0));
        points.add(Offset(x, y));
      }

      if (points.length > 1) {
        path.moveTo(points.first.dx, points.first.dy);
        for (int i = 1; i < points.length; i++) {
          path.lineTo(points[i].dx, points[i].dy);
        }
        canvas.drawPath(path, systolicPaint);
      }

      for (final point in points) {
        canvas.drawCircle(point, 4, Paint()..color = const Color(0xFFEF4444));
      }
    }

    // Draw diastolic data
    if (diastolicData.isNotEmpty) {
      final path = Path();
      final points = <Offset>[];

      for (int i = 0; i < diastolicData.length; i++) {
        final x = size.width * i / (diastolicData.length - 1);
        final normalizedValue =
            (diastolicData[i] - 50) / (120 - 50); // Normalize to 50-120 range
        final y = size.height * (1 - normalizedValue.clamp(0.0, 1.0));
        points.add(Offset(x, y));
      }

      if (points.length > 1) {
        path.moveTo(points.first.dx, points.first.dy);
        for (int i = 1; i < points.length; i++) {
          path.lineTo(points[i].dx, points[i].dy);
        }
        canvas.drawPath(path, diastolicPaint);
      }

      for (final point in points) {
        canvas.drawCircle(point, 4, Paint()..color = const Color(0xFF3B82F6));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
