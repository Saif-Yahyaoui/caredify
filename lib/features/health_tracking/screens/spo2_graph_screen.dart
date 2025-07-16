import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SpO2GraphScreen extends ConsumerStatefulWidget {
  const SpO2GraphScreen({super.key});

  @override
  ConsumerState<SpO2GraphScreen> createState() => _SpO2GraphScreenState();
}

class _SpO2GraphScreenState extends ConsumerState<SpO2GraphScreen> {
  final List<double> _spo2Data = [
    92,
    91,
    90,
    92,
    93,
    92,
    92,
    91,
    93,
    94,
    92,
    91,
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
        title: const Text('SpO2 Analysis'),
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
            // Current SpO2 Status Card
            _buildCurrentStatusCard(context, theme, isDark),
            const SizedBox(height: 24),

            // SpO2 Graph Card
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
    final currentSpO2 = _spo2Data.last;
    final status =
        currentSpO2 >= 95
            ? 'Excellent'
            : currentSpO2 >= 90
            ? 'Good'
            : 'Low';
    final statusColor =
        currentSpO2 >= 95
            ? Colors.green
            : currentSpO2 >= 90
            ? Colors.orange
            : Colors.red;

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
                        Color(0xFF10B981),
                        Color(0xFF059669),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFF10B981,
                        ).withAlpha((0.3 * 255).toInt()),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.air_rounded,
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
                        'Current SpO2',
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
                      '${currentSpO2.toStringAsFixed(0)}%',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                    Text(
                      'SpO2 Level',
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
              '24-Hour SpO2 Trend',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: _buildSpO2Chart(context, theme, isDark),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(context, theme, isDark, 'Average', '92.3%'),
                _buildStatItem(context, theme, isDark, 'Min', '90%'),
                _buildStatItem(context, theme, isDark, 'Max', '94%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpO2Chart(BuildContext context, ThemeData theme, bool isDark) {
    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: SpO2ChartPainter(
        data: _spo2Data,
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
            color: const Color(0xFF10B981),
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
              'Your SpO2 levels are generally within normal range (95-100%). The slight variations throughout the day are normal and may be influenced by activity levels, breathing patterns, and environmental factors.',
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
              'Practice deep breathing exercises',
              'This can help improve oxygen saturation levels',
            ),
            const SizedBox(height: 12),
            _buildRecommendationItem(
              context,
              theme,
              isDark,
              'Maintain good posture',
              'Proper posture helps with optimal breathing',
            ),
            const SizedBox(height: 12),
            _buildRecommendationItem(
              context,
              theme,
              isDark,
              'Stay hydrated',
              'Adequate hydration supports healthy oxygen levels',
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
            color: Color(0xFF10B981),
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
}

class SpO2ChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> timeLabels;
  final bool isDark;

  SpO2ChartPainter({
    required this.data,
    required this.timeLabels,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFF10B981).withAlpha((0.1 * 255).toInt())
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

    // Draw data points and lines
    if (data.isNotEmpty) {
      final path = Path();
      final points = <Offset>[];

      for (int i = 0; i < data.length; i++) {
        final x = size.width * i / (data.length - 1);
        final normalizedValue =
            (data[i] - 85) / (100 - 85); // Normalize to 85-100 range
        final y = size.height * (1 - normalizedValue.clamp(0.0, 1.0));
        points.add(Offset(x, y));
      }

      // Draw line
      if (points.length > 1) {
        path.moveTo(points.first.dx, points.first.dy);
        for (int i = 1; i < points.length; i++) {
          path.lineTo(points[i].dx, points[i].dy);
        }
        canvas.drawPath(path, paint);
      }

      // Draw data points
      for (final point in points) {
        canvas.drawCircle(point, 4, Paint()..color = const Color(0xFF10B981));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
