import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../models/ecg_analysis_result.dart';

/// Widget to display ECG AI analysis results
class EcgAiAnalysisCard extends ConsumerWidget {
  final EcgAnalysisResult? result;
  final VoidCallback? onAnalyzeTap;
  final bool showAnalyzeButton;

  const EcgAiAnalysisCard({
    super.key,
    this.result,
    this.onAnalyzeTap,
    this.showAnalyzeButton = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.psychology, color: AppColors.primaryBlue, size: 24),
                const SizedBox(width: 8),
                Text(
                  'AI ECG Analysis',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (result != null) _buildStatusChip(result!, theme),
              ],
            ),
            const SizedBox(height: 16),

            // Analysis Results
            if (result != null) ...[
              _buildAnalysisResult(context, theme),
              const SizedBox(height: 16),
              _buildRecommendations(context, theme),
              const SizedBox(height: 16),
              _buildMetrics(context, theme),
            ] else ...[
              // No analysis yet
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.analytics_outlined,
                      size: 48,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No ECG analysis available',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap analyze to get AI-powered insights',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],

            // Analyze Button
            if (showAnalyzeButton) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onAnalyzeTap,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Analyze ECG'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build status chip based on classification
  Widget _buildStatusChip(EcgAnalysisResult result, ThemeData theme) {
    final isAbnormal = result.isAbnormal;
    final isHighConfidence = result.isHighConfidence;

    Color chipColor;
    String label;

    if (isAbnormal && isHighConfidence) {
      chipColor = Colors.red;
      label = 'Abnormal';
    } else if (isAbnormal) {
      chipColor = Colors.orange;
      label = 'Suspicious';
    } else {
      chipColor = Colors.green;
      label = 'Normal';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor.withAlpha((0.3 * 255).toInt())),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: chipColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Build analysis result section
  Widget _buildAnalysisResult(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Classification',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                result!.classification,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: result!.isAbnormal ? Colors.red : Colors.green,
                ),
              ),
              const Spacer(),
              Text(
                '${result!.confidencePercentage}% confidence',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: result!.confidence,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              result!.isHighConfidence ? Colors.green : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  /// Build recommendations section
  Widget _buildRecommendations(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommendations',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...result!.recommendations.map(
            (recommendation) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: Colors.green[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      recommendation,
                      style: theme.textTheme.bodySmall,
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

  /// Build additional metrics section
  Widget _buildMetrics(BuildContext context, ThemeData theme) {
    final metrics = result!.additionalMetrics;
    if (metrics == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Signal Quality',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  'Quality',
                  '${((metrics['signal_quality'] as double?) ?? 0.0 * 100).round()}%',
                  theme,
                ),
              ),
              if (metrics['normal_probability'] != null)
                Expanded(
                  child: _buildMetricItem(
                    'Normal Prob',
                    '${((metrics['normal_probability'] as double) * 100).round()}%',
                    theme,
                  ),
                ),
              if (metrics['abnormal_probability'] != null)
                Expanded(
                  child: _buildMetricItem(
                    'Abnormal Prob',
                    '${((metrics['abnormal_probability'] as double) * 100).round()}%',
                    theme,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build individual metric item
  Widget _buildMetricItem(String label, String value, ThemeData theme) {
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
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
}
