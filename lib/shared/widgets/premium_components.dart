import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/user_type_provider.dart';
import '../providers/ecg_analysis_provider.dart';
import '../models/ecg_analysis_result.dart';
import 'ecg_ai_analysis_card.dart';
import '../../core/theme/app_colors.dart';

/// Premium ECG Analysis Card
class PremiumEcgAnalysisCard extends ConsumerStatefulWidget {
  final VoidCallback? onTap;
  final bool showDetails;

  const PremiumEcgAnalysisCard({
    super.key,
    this.onTap,
    this.showDetails = true,
  });

  @override
  ConsumerState<PremiumEcgAnalysisCard> createState() =>
      _PremiumEcgAnalysisCardState();
}

class _PremiumEcgAnalysisCardState
    extends ConsumerState<PremiumEcgAnalysisCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentResult = ref.watch(ecgAnalysisResultProvider).value;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: widget.onTap ?? () => context.go('/main/dashboard/enhanced-ecg'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.psychology,
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
                          'ECG Analysis',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'AI-powered cardiac monitoring',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (currentResult != null)
                    _buildStatusIndicator(currentResult, theme),
                ],
              ),
              const SizedBox(height: 16),

              // Analysis Preview
              if (currentResult != null && widget.showDetails) ...[
                _buildAnalysisPreview(currentResult, theme),
                const SizedBox(height: 16),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.analytics_outlined,
                        color: Colors.grey[600],
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'No recent analysis',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Tap to analyze your ECG',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey[400],
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],

              // Action Button
              if (widget.showDetails) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/main/dashboard/enhanced-ecg'),
                    icon: const Icon(Icons.play_arrow, size: 18),
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
      ),
    );
  }

  /// Build status indicator
  Widget _buildStatusIndicator(EcgAnalysisResult result, ThemeData theme) {
    final isAbnormal = result.isAbnormal;
    final isHighConfidence = result.isHighConfidence;

    Color indicatorColor;
    IconData indicatorIcon;

    if (isAbnormal && isHighConfidence) {
      indicatorColor = Colors.red;
      indicatorIcon = Icons.warning;
    } else if (isAbnormal) {
      indicatorColor = Colors.orange;
      indicatorIcon = Icons.info;
    } else {
      indicatorColor = Colors.green;
      indicatorIcon = Icons.check_circle;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: indicatorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: indicatorColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(indicatorIcon, color: indicatorColor, size: 16),
          const SizedBox(width: 4),
          Text(
            result.classification,
            style: theme.textTheme.bodySmall?.copyWith(
              color: indicatorColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Build analysis preview
  Widget _buildAnalysisPreview(EcgAnalysisResult result, ThemeData theme) {
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
          Row(
            children: [
              Text(
                'Latest Analysis',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${result.confidencePercentage}% confidence',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: result.confidence,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              result.isHighConfidence ? Colors.green : Colors.orange,
            ),
          ),
          const SizedBox(height: 8),
          if (result.recommendations.isNotEmpty)
            Text(
              result.recommendations.first,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}

/// Historical Data Card
class HistoricalDataCard extends ConsumerWidget {
  final VoidCallback? onTap;

  const HistoricalDataCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final stats = ref.watch(ecgAnalysisStatsProvider);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap:
            onTap ??
            () => Navigator.of(context).pushNamed(
              '/main/dashboard/ecg-analysis',
              arguments: {'initialTab': 1},
            ),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.healthGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.history,
                      color: AppColors.healthGreen,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Historical Data',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Trends and patterns',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey[400],
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'Total',
                      '${stats['totalAnalyses']}',
                      Icons.assessment,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'Abnormal',
                      '${(stats['abnormalRate'] * 100).round()}%',
                      Icons.warning,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'Confidence',
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
}

/// AI Alerts Card
class AiAlertsCard extends ConsumerWidget {
  final VoidCallback? onTap;

  const AiAlertsCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final alerts = ref.watch(ecgAlertsProvider);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap:
            onTap ??
            () => Navigator.of(context).pushNamed('/main/dashboard/ecg-alerts'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.alertRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.notifications_active,
                      color: AppColors.alertRed,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Alerts',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Smart health notifications',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (alerts.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.alertRed,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${alerts.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              if (alerts.isNotEmpty) ...[
                ...alerts
                    .take(2)
                    .map(
                      (alert) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _getAlertColor(
                              alert['priority'] as String,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _getAlertColor(
                                alert['priority'] as String,
                              ).withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _getAlertIcon(alert['priority'] as String),
                                color: _getAlertColor(
                                  alert['priority'] as String,
                                ),
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  alert['title'] as String,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green[600],
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'No active alerts',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getAlertColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  IconData _getAlertIcon(String priority) {
    switch (priority) {
      case 'high':
        return Icons.warning;
      case 'medium':
        return Icons.info;
      default:
        return Icons.check_circle;
    }
  }
}

/// Export Data Card
class ExportDataCard extends ConsumerWidget {
  final VoidCallback? onTap;

  const ExportDataCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.download,
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
                          'Export Data',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Share with healthcare providers',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey[400],
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildExportOption(
                      'PDF Report',
                      Icons.picture_as_pdf,
                    ),
                  ),
                  Expanded(
                    child: _buildExportOption('CSV Data', Icons.table_chart),
                  ),
                  Expanded(child: _buildExportOption('Share', Icons.share)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExportOption(String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryBlue, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
