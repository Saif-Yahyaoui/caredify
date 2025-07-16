import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/user_type_provider.dart';
import '../../../shared/services/auth_service.dart';

class AboutAppScreen extends ConsumerStatefulWidget {
  const AboutAppScreen({super.key});

  @override
  ConsumerState<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends ConsumerState<AboutAppScreen> {
  final String _appVersion = '2.1.4';
  final String _buildNumber = '2024.1.4.1234';
  final String _lastUpdated = 'January 15, 2024';

  final List<Map<String, dynamic>> _appFeatures = [
    {
      'title': 'Health Monitoring',
      'description':
          'Track heart rate, blood pressure, ECG, and sleep patterns',
      'icon': Icons.favorite,
      'color': const Color(0xFFEF4444),
      'isPremium': false,
    },
    {
      'title': 'Activity Tracking',
      'description': 'Monitor steps, calories, and daily activity levels',
      'icon': Icons.directions_walk,
      'color': const Color(0xFF10B981),
      'isPremium': false,
    },
    {
      'title': 'AI Health Assistant',
      'description': 'Get personalized health insights and recommendations',
      'icon': Icons.psychology,
      'color': const Color(0xFF8B5CF6),
      'isPremium': true,
    },
    {
      'title': 'Advanced Analytics',
      'description': 'Detailed health reports and trend analysis',
      'icon': Icons.analytics,
      'color': const Color(0xFFFF6B35),
      'isPremium': true,
    },
    {
      'title': 'Remote Camera Control',
      'description': 'Control your device camera remotely',
      'icon': Icons.camera_alt,
      'color': const Color(0xFF06B6D4),
      'isPremium': true,
    },
    {
      'title': 'Premium Support',
      'description': '24/7 priority support with live chat',
      'icon': Icons.support_agent,
      'color': const Color(0xFFFFD700),
      'isPremium': true,
    },
  ];

  final List<Map<String, dynamic>> _changelog = [
    {
      'version': 'v2.1.4',
      'date': 'January 15, 2024',
      'changes': [
        'Bug fixes and performance improvements',
        'Enhanced ECG monitoring accuracy',
        'Improved sleep tracking algorithms',
        'Fixed Bluetooth connectivity issues',
      ],
    },
    {
      'version': 'v2.1.3',
      'date': 'January 10, 2024',
      'changes': [
        'Added new health metrics',
        'Improved user interface',
        'Enhanced data synchronization',
        'Security updates',
      ],
    },
    {
      'version': 'v2.1.2',
      'date': 'January 5, 2024',
      'changes': [
        'Fixed notification issues',
        'Improved app stability',
        'Enhanced accessibility features',
        'Updated privacy settings',
      ],
    },
  ];

  final List<Map<String, dynamic>> _teamMembers = [
    {
      'name': 'Dr. Sarah Johnson',
      'role': 'Chief Medical Officer',
      'description': 'Leading our medical research and clinical validation',
      'avatar': '👩‍⚕️',
    },
    {
      'name': 'Michael Chen',
      'role': 'Head of Engineering',
      'description': 'Overseeing technical development and innovation',
      'avatar': '👨‍💻',
    },
    {
      'name': 'Dr. Emily Rodriguez',
      'role': 'Research Director',
      'description': 'Managing health data analysis and insights',
      'avatar': '👩‍🔬',
    },
    {
      'name': 'David Kim',
      'role': 'Product Manager',
      'description': 'Driving product strategy and user experience',
      'avatar': '👨‍💼',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final userType = ref.watch(userTypeProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // App Header
            _buildAppHeaderCard(context, theme, isDark),
            const SizedBox(height: 24),

            // App Features
            _buildSectionHeader(context, theme, isDark, 'App Features'),
            const SizedBox(height: 16),
            ..._appFeatures.map(
              (feature) =>
                  _buildFeatureCard(context, theme, isDark, feature, userType),
            ),
            const SizedBox(height: 24),

            // Version Information
            _buildVersionInfoCard(context, theme, isDark),
            const SizedBox(height: 24),

            // Changelog
            _buildChangelogCard(context, theme, isDark),
            const SizedBox(height: 24),

            // Team
            _buildTeamCard(context, theme, isDark),
            const SizedBox(height: 24),

            // Legal Links
            _buildLegalLinksCard(context, theme, isDark),
            const SizedBox(height: 24),

            // Premium Features
            if (userType == UserType.premium)
              _buildPremiumFeaturesSection(context, theme, isDark)
            else
              _buildUpgradeSection(context, theme, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildAppHeaderCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
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
                    : [const Color(0xFFF8FAFC), const Color(0xFFF1F5F9)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryBlue.withAlpha((0.3 * 255).toInt()),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryBlue,
                    AppColors.primaryBlue.withAlpha((0.8 * 255).toInt()),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withAlpha((0.3 * 255).toInt()),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.favorite, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 16),
            Text(
              'Caredify',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Your Health, Our Priority',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Advanced health monitoring and AI-powered insights to help you live a healthier life.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white70 : const Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    String title,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDark
                  ? [
                    const Color(0xFF1E293B).withAlpha((0.6 * 255).toInt()),
                    const Color(0xFF334155).withAlpha((0.4 * 255).toInt()),
                  ]
                  : [const Color(0xFFF1F5F9), const Color(0xFFE2E8F0)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isDark
                  ? const Color(0xFF475569).withAlpha((0.2 * 255).toInt())
                  : const Color(0xFFCBD5E1).withAlpha((0.3 * 255).toInt()),
          width: 1,
        ),
      ),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : const Color(0xFF1E293B),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    Map<String, dynamic> feature,
    UserType userType,
  ) {
    final isEnabled = !feature['isPremium'] || userType == UserType.premium;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isEnabled ? null : Colors.grey.withAlpha((0.1 * 255).toInt()),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    feature['color'],
                    feature['color'].withAlpha((0.8 * 255).toInt()),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: feature['color'].withAlpha((0.3 * 255).toInt()),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(feature['icon'], color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        feature['title'],
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                      if (feature['isPremium'] &&
                          userType != UserType.premium) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD700),
                            borderRadius: BorderRadius.circular(8),
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
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    feature['description'],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isEnabled ? Icons.check_circle : Icons.lock,
              color: isEnabled ? Colors.green : Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionInfoCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
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
                  Icons.info_outline,
                  color: AppColors.primaryBlue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Version Information',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('App Version', _appVersion),
            _buildInfoRow('Build Number', _buildNumber),
            _buildInfoRow('Last Updated', _lastUpdated),
            _buildInfoRow('Platform', 'Flutter'),
            _buildInfoRow('Target SDK', 'Android 13+ / iOS 15+'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildChangelogCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
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
                const Icon(Icons.update, color: AppColors.primaryBlue, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Recent Updates',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._changelog.map(
              (update) => _buildChangelogItem(context, theme, isDark, update),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChangelogItem(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    Map<String, dynamic> update,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            isDark
                ? Colors.grey.withAlpha((0.1 * 255).toInt())
                : Colors.grey.withAlpha((0.05 * 255).toInt()),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                update['version'],
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                update['date'],
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...(update['changes'] as List<String>).map(
            (change) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      change,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            isDark ? Colors.white70 : const Color(0xFF64748B),
                      ),
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

  Widget _buildTeamCard(BuildContext context, ThemeData theme, bool isDark) {
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
                const Icon(Icons.people, color: AppColors.primaryBlue, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Our Team',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._teamMembers.map(
              (member) => _buildTeamMember(context, theme, isDark, member),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    Map<String, dynamic> member,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            isDark
                ? Colors.grey.withAlpha((0.1 * 255).toInt())
                : Colors.grey.withAlpha((0.05 * 255).toInt()),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withAlpha((0.1 * 255).toInt()),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(
                member['avatar'],
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member['name'],
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  member['role'],
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  member['description'],
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalLinksCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
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
                const Icon(Icons.gavel, color: AppColors.primaryBlue, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Legal',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildLegalLink(
              context,
              theme,
              isDark,
              'Privacy Policy',
              Icons.privacy_tip,
            ),
            _buildLegalLink(
              context,
              theme,
              isDark,
              'Terms of Service',
              Icons.description,
            ),
            _buildLegalLink(
              context,
              theme,
              isDark,
              'Data Usage',
              Icons.data_usage,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalLink(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    String title,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryBlue, size: 20),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: theme.hintColor, size: 20),
      onTap: () {
        // Navigate to legal pages
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening $title...'),
            backgroundColor: AppColors.primaryBlue,
          ),
        );
      },
    );
  }

  Widget _buildPremiumFeaturesSection(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
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
                    : [const Color(0xFFFFF8E1), const Color(0xFFFFF3CD)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFFFD700).withAlpha((0.3 * 255).toInt()),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'PREMIUM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Premium Features',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Access to AI health assistant, advanced analytics, remote camera control, and priority support.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white70 : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpgradeSection(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
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
                    : [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryBlue.withAlpha((0.3 * 255).toInt()),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star, color: Color(0xFFFFD700), size: 24),
                const SizedBox(width: 12),
                Text(
                  'Upgrade to Premium',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Unlock AI health assistant, advanced analytics, remote camera control, and priority support.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white70 : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go('/upgrade'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Upgrade Now',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
