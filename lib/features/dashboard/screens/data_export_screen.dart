import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/services/auth_service.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/role_based_access.dart';


class DataExportScreen extends ConsumerStatefulWidget {
  const DataExportScreen({super.key});

  @override
  ConsumerState<DataExportScreen> createState() => _DataExportScreenState();
}

class _DataExportScreenState extends ConsumerState<DataExportScreen> {
  String _selectedFormat = 'PDF';
  String _selectedDateRange = 'Last 30 days';
  List<String> _selectedDataTypes = ['ECG', 'Heart Rate', 'Blood Pressure'];
  bool _isExporting = false;
  double _exportProgress = 0.0;

  final List<String> _formats = ['PDF', 'CSV', 'JSON', 'XML'];
  final List<String> _dateRanges = [
    'Last 7 days',
    'Last 30 days',
    'Last 3 months',
    'Last 6 months',
    'Last year',
    'All time',
  ];
  final List<String> _dataTypes = [
    'ECG',
    'Heart Rate',
    'Blood Pressure',
    'SpO2',
    'Activity',
    'Sleep',
    'Water Intake',
    'Medication',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return RoleBasedAccess(
      allowedUserTypes: const [UserType.premium],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Export Health Data'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
            onPressed: () => context.go('/main/dashboard'),
          ),
          foregroundColor: theme.colorScheme.onSurface,
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context, isDark),
              const SizedBox(height: 24),
              _buildFormatSelection(context, isDark),
              const SizedBox(height: 16),
              _buildDateRangeSelection(context, isDark),
              const SizedBox(height: 16),
              _buildDataTypeSelection(context, isDark),
              const SizedBox(height: 24),
              _buildExportButton(context),
              const SizedBox(height: 16),
              _buildExportHistory(context, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
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
                      const Color(0xFF1E293B).withAlpha(
                            (0.8 * 255).toInt()),
                      const Color(0xFF334155).withAlpha(
                            (0.6 * 255).toInt()),
                    ]
                    : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withAlpha(
                            (0.1 * 255).toInt()),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.download,
                color: AppColors.primaryBlue,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Export Your Health Data',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Download your health data for medical consultations or personal records',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white70 : const Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatSelection(BuildContext context, bool isDark) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.file_present,
                  color: AppColors.primaryBlue,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Export Format',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  _formats.map((format) {
                    final isSelected = _selectedFormat == format;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedFormat = format),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? AppColors.primaryBlue
                                  : isDark
                                  ? const Color(0xFF374151)
                                  : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                isSelected
                                    ? AppColors.primaryBlue
                                    : isDark
                                    ? const Color(0xFF4B5563)
                                    : Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          format,
                          style: TextStyle(
                            color: isSelected ? Colors.white : null,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangeSelection(BuildContext context, bool isDark) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: AppColors.primaryBlue,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Date Range',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedDateRange,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items:
                  _dateRanges.map((range) {
                    return DropdownMenuItem(value: range, child: Text(range));
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedDateRange = value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTypeSelection(BuildContext context, bool isDark) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.data_usage, color: AppColors.primaryBlue, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Data Types',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Select the types of data you want to export',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).hintColor,
              ),
            ),
            const SizedBox(height: 16),
            ..._dataTypes.map((dataType) {
              final isSelected = _selectedDataTypes.contains(dataType);
              return CheckboxListTile(
                title: Text(dataType),
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _selectedDataTypes.add(dataType);
                    } else {
                      _selectedDataTypes.remove(dataType);
                    }
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              );
            }),
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedDataTypes = List.from(_dataTypes);
                    });
                  },
                  child: const Text('Select All'),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedDataTypes.clear();
                    });
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportButton(BuildContext context) {
    return Column(
      children: [
        if (_isExporting) ...[
          LinearProgressIndicator(
            value: _exportProgress,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
          ),
          const SizedBox(height: 8),
          Text(
            'Exporting... ${(_exportProgress * 100).toStringAsFixed(0)}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).hintColor,
            ),
          ),
          const SizedBox(height: 16),
        ],
        CustomButton.primary(
          text: _isExporting ? 'Exporting...' : 'Export Data',
          onPressed: _isExporting ? null : _handleExport,
          isLoading: _isExporting,
          icon: Icons.download,
        ),
      ],
    );
  }

  Widget _buildExportHistory(BuildContext context, bool isDark) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.history, color: AppColors.primaryBlue, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Export History',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const _ExportHistoryItem(
              date: '2024-01-15',
              format: 'PDF',
              dataTypes: ['ECG', 'Heart Rate'],
              size: '2.3 MB',
            ),
            const SizedBox(height: 8),
            const _ExportHistoryItem(
              date: '2024-01-10',
              format: 'CSV',
              dataTypes: ['Blood Pressure', 'Activity'],
              size: '1.8 MB',
            ),
            const SizedBox(height: 8),
            const _ExportHistoryItem(
              date: '2024-01-05',
              format: 'PDF',
              dataTypes: ['All Data'],
              size: '5.2 MB',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleExport() async {
    if (_selectedDataTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one data type to export'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isExporting = true;
      _exportProgress = 0.0;
    });

    try {
      // Simulate export process
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(const Duration(milliseconds: 200));
        setState(() {
          _exportProgress = i / 100;
        });
      }

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data exported successfully as $_selectedFormat!'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'Download',
            textColor: Colors.white,
            onPressed: () {
              // Handle download action
            },
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
          _exportProgress = 0.0;
        });
      }
    }
  }
}

class _ExportHistoryItem extends StatelessWidget {
  final String date;
  final String format;
  final List<String> dataTypes;
  final String size;

  const _ExportHistoryItem({
    required this.date,
    required this.format,
    required this.dataTypes,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Icon(
            _getFormatIcon(format),
            color: _getFormatColor(format),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$date - $format',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  dataTypes.join(', '),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          ),
          Text(
            size,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
          ),
        ],
      ),
    );
  }

  IconData _getFormatIcon(String format) {
    switch (format) {
      case 'PDF':
        return Icons.picture_as_pdf;
      case 'CSV':
        return Icons.table_chart;
      case 'JSON':
        return Icons.code;
      case 'XML':
        return Icons.data_object;
      default:
        return Icons.file_present;
    }
  }

  Color _getFormatColor(String format) {
    switch (format) {
      case 'PDF':
        return Colors.red;
      case 'CSV':
        return Colors.green;
      case 'JSON':
        return Colors.orange;
      case 'XML':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
