import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../models/ecg_analysis_result.dart';
import '../../providers/ecg_analysis_provider.dart';

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
    final analysisState = ref.watch(ecgAnalysisResultProvider);
    final isLoading = analysisState.isLoading;
    final hasError = analysisState.hasError;
    final error = hasError ? analysisState.asError?.error : null;
    final result = analysisState.value;

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
                const Icon(
                  Icons.psychology,
                  color: AppColors.primaryBlue,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'AI ECG Analysis',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (result != null) _buildStatusChip(result, theme),
              ],
            ),
            const SizedBox(height: 16),

            if (isLoading) ...[
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 12),
              Text('Analyzing ECG...', style: theme.textTheme.bodyMedium),
            ] else if (hasError) ...[
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 12),
              Text(
                'Analysis Error',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error?.toString() ?? 'Unknown error',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ] else if (result != null) ...[
              // Custom result display
              _buildAnalysisResult(context, theme, result),
              const SizedBox(height: 16),
              _buildRecommendations(context, theme, result),
              const SizedBox(height: 16),
              _buildMetrics(context, theme, result),
            ] else ...[
              // Redesigned no analysis state
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[900] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.analytics_outlined,
                      size: 32,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'No analysis yet.\nRecord and tap Analyze ECG.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Analyze/Re-analyze and Clear buttons
            if (showAnalyzeButton && !isLoading) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onAnalyzeTap,
                      icon: const Icon(Icons.play_arrow),
                      label: Text(
                        result == null ? 'Analyze ECG' : 'Re-analyze',
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (result != null)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Clear the result using the provider
                          ref
                              .read(ecgAnalysisResultProvider.notifier)
                              .clearResult();
                        },
                        icon: const Icon(Icons.clear),
                        label: const Text('Clear Result'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
            if (result != null) ...[
              const SizedBox(height: 10),
              Text(
                'Full details and previous analyses are available in the History tab below.',
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(EcgAnalysisResult result, ThemeData theme) {
    final isAbnormal = result.isAbnormal;
    return Chip(
      label: Text(isAbnormal ? 'Abnormal' : 'Normal'),
      backgroundColor: isAbnormal ? Colors.red[100] : Colors.green[100],
      labelStyle: theme.textTheme.labelMedium?.copyWith(
        color: isAbnormal ? Colors.red : Colors.green,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildAnalysisResult(
    BuildContext context,
    ThemeData theme,
    EcgAnalysisResult result,
  ) {
    final isAbnormal = result.isAbnormal;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isAbnormal ? Icons.warning : Icons.check_circle,
              color: isAbnormal ? Colors.red : Colors.green,
              size: 32,
            ),
            const SizedBox(width: 8),
            Text(
              isAbnormal
                  ? 'Abnormal ECG Pattern Detected'
                  : 'Normal ECG Pattern',
              style: theme.textTheme.titleMedium?.copyWith(
                color: isAbnormal ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text('Confidence:', style: theme.textTheme.bodyMedium),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: result.confidence,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            isAbnormal ? Colors.red : Colors.green,
          ),
          minHeight: 8,
        ),
        const SizedBox(height: 4),
        Text(
          '${(result.confidence * 100).toStringAsFixed(1)}%',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildRecommendations(
    BuildContext context,
    ThemeData theme,
    EcgAnalysisResult result,
  ) {
    if (result.recommendations.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommendations:',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        ...result.recommendations.map(
          (rec) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                const Icon(Icons.arrow_right, size: 18, color: AppColors.primaryBlue),
                const SizedBox(width: 4),
                Expanded(child: Text(rec, style: theme.textTheme.bodySmall)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetrics(
    BuildContext context,
    ThemeData theme,
    EcgAnalysisResult result,
  ) {
    if (result.additionalMetrics == null || result.additionalMetrics!.isEmpty) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Metrics:',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        ...result.additionalMetrics!.entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                const Icon(Icons.analytics, size: 16, color: AppColors.primaryBlue),
                const SizedBox(width: 4),
                Text(
                  '${entry.key}: ',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${entry.value}',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
