import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/user_type_provider.dart';

class HelpFAQScreen extends ConsumerStatefulWidget {
  const HelpFAQScreen({super.key});

  @override
  ConsumerState<HelpFAQScreen> createState() => _HelpFAQScreenState();
}

class _HelpFAQScreenState extends ConsumerState<HelpFAQScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _isSearching = false;

  final List<Map<String, dynamic>> _faqCategories = [
    {
      'name': 'All',
      'icon': Icons.all_inclusive,
      'color': AppColors.primaryBlue,
    },
    {
      'name': 'Getting Started',
      'icon': Icons.play_circle_outline,
      'color': const Color(0xFF10B981),
    },
    {
      'name': 'Device Setup',
      'icon': Icons.watch,
      'color': const Color(0xFF8B5CF6),
    },
    {
      'name': 'Health Features',
      'icon': Icons.favorite,
      'color': const Color(0xFFEF4444),
    },
    {
      'name': 'Account & Billing',
      'icon': Icons.account_circle,
      'color': const Color(0xFFFF6B35),
    },
    {
      'name': 'Troubleshooting',
      'icon': Icons.build,
      'color': const Color(0xFF6B7280),
    },
  ];

  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'How do I connect my health watch?',
      'answer':
          'To connect your health watch, make sure Bluetooth is enabled on your phone. Open the app and go to Device Settings > Watch Connection. Follow the on-screen instructions to pair your device.',
      'category': 'Device Setup',
      'tags': ['watch', 'connection', 'bluetooth'],
    },
    {
      'question': 'How accurate are the health measurements?',
      'answer':
          'Our health measurements are clinically validated and provide accurate readings within industry standards. For best results, ensure your watch is properly fitted and calibrated.',
      'category': 'Health Features',
      'tags': ['accuracy', 'measurements', 'health'],
    },
    {
      'question': 'How do I upgrade to Premium?',
      'answer':
          'To upgrade to Premium, go to your Profile > Account Settings > Subscription. Choose your preferred plan and follow the payment process. Premium features will be available immediately after payment.',
      'category': 'Account & Billing',
      'tags': ['premium', 'upgrade', 'subscription'],
    },
    {
      'question': 'My watch is not syncing data',
      'answer':
          'If your watch is not syncing, try these steps: 1) Restart both your phone and watch, 2) Check Bluetooth connection, 3) Ensure the app has necessary permissions, 4) Update to the latest firmware.',
      'category': 'Troubleshooting',
      'tags': ['sync', 'bluetooth', 'troubleshooting'],
    },
    {
      'question': 'How do I set up health goals?',
      'answer':
          'Navigate to Dashboard > Health Goals. You can set daily targets for steps, heart rate, sleep, and other metrics. Goals can be customized based on your fitness level and preferences.',
      'category': 'Getting Started',
      'tags': ['goals', 'setup', 'dashboard'],
    },
    {
      'question': 'Can I export my health data?',
      'answer':
          'Yes, Premium users can export their health data in various formats. Go to Profile > Data Export to download your health records, activity logs, and measurements.',
      'category': 'Health Features',
      'tags': ['export', 'data', 'premium'],
    },
    {
      'question': 'How do I reset my device?',
      'answer':
          'To reset your device, go to Profile > Device Settings > Reset Device. Choose the type of reset you need: Settings Reset (preserves data) or Factory Reset (removes all data).',
      'category': 'Device Setup',
      'tags': ['reset', 'device', 'factory'],
    },
    {
      'question': 'What health metrics are tracked?',
      'answer':
          'The app tracks heart rate, blood pressure, ECG, sleep patterns, activity levels, steps, calories burned, and more. Premium users get access to advanced metrics and detailed analytics.',
      'category': 'Health Features',
      'tags': ['metrics', 'tracking', 'health'],
    },
    {
      'question': 'How do I change my password?',
      'answer':
          'Go to Profile > Account Settings > Security Settings > Change Password. Enter your current password and set a new one. Make sure to use a strong password for security.',
      'category': 'Account & Billing',
      'tags': ['password', 'security', 'account'],
    },
    {
      'question': 'The app is running slowly',
      'answer':
          'Try these solutions: 1) Clear app cache in your phone settings, 2) Restart the app, 3) Update to the latest version, 4) Check your internet connection, 5) Free up storage space.',
      'category': 'Troubleshooting',
      'tags': ['performance', 'slow', 'cache'],
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(userTypeProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filteredFaqs = _getFilteredFaqs();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & FAQ'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => context.go('/main/profile'),
        ),
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          _buildSearchBar(context, theme, isDark),

          // Categories
          _buildCategoriesSection(context, theme, isDark),

          // FAQ List
          Expanded(
            child:
                filteredFaqs.isEmpty
                    ? _buildEmptyState(context, theme, isDark)
                    : _buildFAQList(context, theme, isDark, filteredFaqs),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).toInt()),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
            _isSearching = value.isNotEmpty;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search FAQs...',
          prefixIcon: Icon(
            _isSearching ? Icons.search : Icons.search_outlined,
            color: theme.hintColor,
          ),
          suffixIcon:
              _isSearching
                  ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                        _isSearching = false;
                      });
                    },
                    icon: Icon(Icons.clear, color: theme.hintColor),
                  )
                  : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color:
                  isDark
                      ? Colors.grey.withAlpha((0.3 * 255).toInt())
                      : Colors.grey.withAlpha((0.2 * 255).toInt()),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color:
                  isDark
                      ? Colors.grey.withAlpha((0.3 * 255).toInt())
                      : Colors.grey.withAlpha((0.2 * 255).toInt()),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
          ),
          filled: true,
          fillColor:
              isDark
                  ? Colors.grey.withAlpha((0.1 * 255).toInt())
                  : Colors.grey.withAlpha((0.05 * 255).toInt()),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _faqCategories.length,
        itemBuilder: (context, index) {
          final category = _faqCategories[index];
          final isSelected = _selectedCategory == category['name'];

          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedCategory = category['name'];
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 80,
                height: 90,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient:
                      isSelected
                          ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              category['color'],
                              category['color'].withAlpha((0.8 * 255).toInt()),
                            ],
                          )
                          : null,
                  color:
                      isSelected
                          ? null
                          : (isDark
                              ? Colors.grey.withAlpha((0.1 * 255).toInt())
                              : Colors.grey.withAlpha((0.05 * 255).toInt())),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? category['color'] : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      category['icon'],
                      color: isSelected ? Colors.white : category['color'],
                      size: 20,
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: Text(
                        category['name'],
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isSelected ? Colors.white : theme.hintColor,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFAQList(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    List<Map<String, dynamic>> faqs,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: faqs.length,
      itemBuilder: (context, index) {
        final faq = faqs[index];
        return _buildFAQItem(context, theme, isDark, faq);
      },
    );
  }

  Widget _buildFAQItem(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    Map<String, dynamic> faq,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getCategoryColor(
              faq['category'],
            ).withAlpha((0.1 * 255).toInt()),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            _getCategoryIcon(faq['category']),
            color: _getCategoryColor(faq['category']),
            size: 20,
          ),
        ),
        title: Text(
          faq['question'],
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF1E293B),
          ),
        ),
        subtitle: Text(
          faq['category'],
          style: theme.textTheme.bodySmall?.copyWith(
            color: _getCategoryColor(faq['category']),
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  isDark
                      ? Colors.grey.withAlpha((0.05 * 255).toInt())
                      : Colors.grey.withAlpha((0.02 * 255).toInt()),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faq['answer'],
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.white70 : const Color(0xFF64748B),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children:
                      (faq['tags'] as List<String>)
                          .map(
                            (tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue.withAlpha(
                                  (0.1 * 255).toInt(),
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '#$tag',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.primaryBlue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No FAQs found',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or category filter',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              _searchController.clear();
              setState(() {
                _searchQuery = '';
                _selectedCategory = 'All';
                _isSearching = false;
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Clear Filters'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredFaqs() {
    List<Map<String, dynamic>> filtered = _faqs;

    // Filter by category
    if (_selectedCategory != 'All') {
      filtered =
          filtered
              .where((faq) => faq['category'] == _selectedCategory)
              .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered.where((faq) {
            final question = faq['question'].toString().toLowerCase();
            final answer = faq['answer'].toString().toLowerCase();
            final tags = (faq['tags'] as List<String>).join(' ').toLowerCase();
            final query = _searchQuery.toLowerCase();

            return question.contains(query) ||
                answer.contains(query) ||
                tags.contains(query);
          }).toList();
    }

    return filtered;
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Getting Started':
        return const Color(0xFF10B981);
      case 'Device Setup':
        return const Color(0xFF8B5CF6);
      case 'Health Features':
        return const Color(0xFFEF4444);
      case 'Account & Billing':
        return const Color(0xFFFF6B35);
      case 'Troubleshooting':
        return const Color(0xFF6B7280);
      default:
        return AppColors.primaryBlue;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Getting Started':
        return Icons.play_circle_outline;
      case 'Device Setup':
        return Icons.watch;
      case 'Health Features':
        return Icons.favorite;
      case 'Account & Billing':
        return Icons.account_circle;
      case 'Troubleshooting':
        return Icons.build;
      default:
        return Icons.help_outline;
    }
  }
}
