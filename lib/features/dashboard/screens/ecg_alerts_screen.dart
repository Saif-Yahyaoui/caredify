import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/ecg_analysis_provider.dart';

class EcgAlertsScreen extends ConsumerWidget {
  const EcgAlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = ref.watch(ecgAlertsProvider);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI ECG Alerts'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body:
          alerts.isEmpty
              ? Center(
                child: Text(
                  'No active AI alerts',
                  style: theme.textTheme.bodyLarge,
                ),
              )
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: alerts.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final alert = alerts[index];
                  return ListTile(
                    leading: Icon(
                      _getAlertIcon(alert['priority'] as String),
                      color: _getAlertColor(alert['priority'] as String),
                    ),
                    title: Text(alert['title'] as String),
                    subtitle: Text(alert['message'] as String),
                    trailing: Text(
                      alert['priority'].toString().toUpperCase(),
                      style: TextStyle(
                        color: _getAlertColor(alert['priority'] as String),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
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
