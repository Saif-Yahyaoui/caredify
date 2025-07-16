// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;

import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../shared/providers/user_type_provider.dart';
import '../../../shared/providers/voice_feedback_provider.dart';
import '../../../shared/services/auth_service.dart';
import '../../../shared/widgets/section_header.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final voiceFeedbackEnabled = ref.read(voiceFeedbackProvider);
      if (voiceFeedbackEnabled) {
        await _tts.speak(
          'Profile screen. Manage your account settings and preferences.',
        );
      }
    });
  }

  @override
  void dispose() {
    _tts.stop();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final isRtl = intl.Bidi.isRtlLanguage(locale.languageCode);
    final isDark = theme.brightness == Brightness.dark;
    final userType = ref.watch(userTypeProvider);
    final authState = ref.watch(authStateProvider);

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Header
                _buildProfileHeader(
                  context,
                  theme,
                  isDark,
                  authState,
                  userType,
                ),
                const SizedBox(height: 24),

                // Modern Search Section
                _buildModernSearchSection(context, theme, isDark),
                const SizedBox(height: 24),

                // Separated Profile Options
                _buildSeparatedProfileOptions(context, theme, isDark),
                const SizedBox(height: 24),

                // Logout Section
                _buildLogoutSection(context, theme, isDark),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    authState,
    UserType userType,
  ) {
    return Container(
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
                  : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0)],
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
                    ? Colors.black.withAlpha((0.3 * 255).toInt())
                    : const Color(0xFF64748B).withAlpha((0.1 * 255).toInt()),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors:
                    userType == UserType.premium
                        ? [const Color(0xFFF59E0B), const Color(0xFFD97706)]
                        : [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)],
              ),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: (userType == UserType.premium
                          ? const Color(0xFFF59E0B)
                          : const Color(0xFF3B82F6))
                      .withAlpha((0.3 * 255).toInt()),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/profile.jpeg',
                fit: BoxFit.cover,
                width: 120,
                height: 120,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Saif Yahyaoui',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userType == UserType.premium ? 'Premium User' : 'Basic User',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors:
                          userType == UserType.premium
                              ? [
                                const Color(0xFFF59E0B),
                                const Color(0xFFD97706),
                              ]
                              : [
                                const Color(0xFF3B82F6),
                                const Color(0xFF1D4ED8),
                              ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    userType == UserType.premium ? 'PREMIUM' : 'BASIC',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedProfileOption(
    BuildContext context,
    ThemeData theme,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    Color? color,
    bool isPremium = false,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    final optionColor = color ?? AppColors.primaryBlue;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
        borderRadius: BorderRadius.circular(16),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        optionColor,
                        optionColor.withAlpha((0.8 * 255).toInt()),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: optionColor.withAlpha((0.3 * 255).toInt()),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color:
                                    isDark
                                        ? Colors.white
                                        : const Color(0xFF1E293B),
                              ),
                            ),
                          ),
                          if (isPremium)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFFD700),
                                    Color(0xFFFFA500),
                                  ],
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
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
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
                const SizedBox(width: 12),
                Icon(
                  Icons.chevron_right_rounded,
                  color:
                      isDark
                          ? Colors.white.withAlpha((0.6 * 255).toInt())
                          : const Color(0xFF64748B),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernSearchSection(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryBlue,
                  AppColors.primaryBlue.withAlpha((0.8 * 255).toInt()),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withAlpha((0.3 * 255).toInt()),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.search_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Search settings and preferences...',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF64748B),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() {});
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? Colors.white.withAlpha((0.1 * 255).toInt())
                          : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.close_rounded,
                  color:
                      isDark
                          ? Colors.white.withAlpha((0.7 * 255).toInt())
                          : const Color(0xFF64748B),
                  size: 18,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSeparatedProfileOptions(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    final userType = ref.watch(userTypeProvider);

    return Column(
      children: [
        // Account Settings Section
        const SectionHeader(
          title: 'Account',
          icon: Icons.person_rounded,
          iconColor: Color(0xFF3B82F6),
        ),
        const SizedBox(height: 12),
        _buildEnhancedProfileOption(
          context,
          theme,
          Icons.person_outline,
          'Personal Information',
          'Update your profile details',
          () => context.go('/main/profile/account-settings/personal-info'),
          color: const Color(0xFF3B82F6),
        ),
        const SizedBox(height: 8),
        _buildEnhancedProfileOption(
          context,
          theme,
          Icons.security,
          'Security Settings',
          'Manage password and security',
          () => context.go('/main/profile/account-settings/security'),
          color: const Color(0xFFEF4444),
        ),
        const SizedBox(height: 8),
        _buildEnhancedProfileOption(
          context,
          theme,
          Icons.privacy_tip_outlined,
          'Privacy Settings',
          'Control your data privacy',
          () => context.go('/main/profile/account-settings/privacy'),
          color: const Color(0xFF8B5CF6),
        ),
        const SizedBox(height: 24),

        // App Settings Section
        const SectionHeader(
          title: 'App Settings',
          icon: Icons.settings_rounded,
          iconColor: Color(0xFF10B981),
        ),
        const SizedBox(height: 12),
        _buildEnhancedProfileOption(
          context,
          theme,
          Icons.notifications_outlined,
          'Notifications',
          'Manage notification preferences',
          () => context.go('/main/profile/app-settings/notifications'),
          color: const Color(0xFF10B981),
        ),
        const SizedBox(height: 8),
        _buildEnhancedProfileOption(
          context,
          theme,
          Icons.message_outlined,
          'Message Push',
          'Configure message notifications',
          () => context.go('/main/profile/app-settings/messages'),
          color: const Color(0xFF06B6D4),
        ),
        const SizedBox(height: 8),
        _buildEnhancedProfileOption(
          context,
          theme,
          Icons.accessibility_new,
          'Accessibility Controls',
          'Customize accessibility settings',
          () => context.go('/main/profile/accessibility-settings'),
          color: const Color(0xFFF59E0B),
        ),
        const SizedBox(height: 24),

        // Device Settings Section
        const SectionHeader(
          title: 'Device',
          icon: Icons.devices_rounded,
          iconColor: Color(0xFF8B5CF6),
        ),
        const SizedBox(height: 12),
        _buildEnhancedProfileOption(
          context,
          theme,
          Icons.restart_alt,
          'Reset Device',
          'Reset device settings to default',
          () => context.go('/main/profile/device-settings/reset'),
          color: const Color(0xFF8B5CF6),
        ),
        const SizedBox(height: 8),
        _buildEnhancedProfileOption(
          context,
          theme,
          Icons.camera_alt_outlined,
          'Remote Shutter',
          'Configure camera remote control',
          () => context.go('/main/profile/device-settings/remote-shutter'),
          color: const Color(0xFFEC4899),
        ),
        const SizedBox(height: 8),
        _buildEnhancedProfileOption(
          context,
          theme,
          Icons.system_update,
          'OTA Upgrade',
          'Check for software updates',
          () => context.go('/main/profile/device-settings/ota-upgrade'),
          color: const Color(0xFF84CC16),
        ),
        const SizedBox(height: 24),

        // Support Section
        const SectionHeader(
          title: 'Support & Help',
          icon: Icons.help_outline_rounded,
          iconColor: Color(0xFFF59E0B),
        ),
        const SizedBox(height: 12),
        _buildEnhancedProfileOption(
          context,
          theme,
          Icons.help_outline,
          'Help & FAQ',
          'Get help and find answers',
          () => context.go('/main/profile/support/help-faq'),
          color: const Color(0xFFF59E0B),
        ),
        const SizedBox(height: 8),
        _buildEnhancedProfileOption(
          context,
          theme,
          Icons.contact_support_outlined,
          'Contact Support',
          'Get in touch with our team',
          () => context.go('/main/profile/support/contact'),
          color: const Color(0xFF06B6D4),
        ),
        const SizedBox(height: 8),
        _buildEnhancedProfileOption(
          context,
          theme,
          Icons.info_outline,
          'About App',
          'App version and information',
          () => context.go('/main/profile/support/about'),
          color: const Color(0xFF6B7280),
        ),
        const SizedBox(height: 24),

        // Upgrade Section (for basic users)
        if (userType == UserType.basic) ...[
          _buildEnhancedProfileOption(
            context,
            theme,
            Icons.star,
            'Upgrade to Premium',
            'Unlock advanced features',
            () => context.go('/upgrade'),
            color: const Color(0xFFFFD700),
            isPremium: true,
          ),
          const SizedBox(height: 24),
        ],
      ],
    );
  }

  Widget _buildLogoutSection(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDark
                  ? [
                    const Color(0xFFDC2626).withAlpha((0.1 * 255).toInt()),
                    const Color(0xFFEF4444).withAlpha((0.05 * 255).toInt()),
                  ]
                  : [const Color(0xFFFEF2F2), const Color(0xFFFEE2E2)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isDark
                  ? const Color(0xFFDC2626).withAlpha((0.3 * 255).toInt())
                  : const Color(0xFFFECACA).withAlpha((0.8 * 255).toInt()),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? const Color(0xFFDC2626).withAlpha((0.2 * 255).toInt())
                    : const Color(0xFFDC2626).withAlpha((0.1 * 255).toInt()),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            final shouldLogout = await showDialog<bool>(
              context: context,
              builder:
                  (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.logout_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Logout',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFDC2626),
                          ),
                        ),
                      ],
                    ),
                    content: Text(
                      'Are you sure you want to sign out of your account?',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            isDark
                                ? Colors.white.withAlpha((0.8 * 255).toInt())
                                : const Color(0xFF64748B),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color:
                                isDark
                                    ? Colors.white.withAlpha(
                                      (0.7 * 255).toInt(),
                                    )
                                    : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
            );

            if (shouldLogout == true && mounted) {
              await ref.read(authStateProvider.notifier).logout();
              if (!mounted) return;
              context.go('/login');
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFFDC2626,
                        ).withAlpha((0.3 * 255).toInt()),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
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
                        'Logout',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFDC2626),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Sign out of your account',
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
                const SizedBox(width: 12),
                Icon(
                  Icons.chevron_right_rounded,
                  color: const Color(0xFFDC2626).withAlpha((0.7 * 255).toInt()),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
