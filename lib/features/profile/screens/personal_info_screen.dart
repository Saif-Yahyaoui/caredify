import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/user_type_provider.dart';
import '../../../shared/services/auth_service.dart';
import '../../../shared/widgets/custom_text_field.dart';

class PersonalInfoScreen extends ConsumerStatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  ConsumerState<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends ConsumerState<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Saif Yahyaoui');
  final _emailController = TextEditingController(
    text: 'saif.yahyaoui@esprit.tn',
  );
  final _phoneController = TextEditingController(text: '+216 20947998');
  final _ageController = TextEditingController(text: '27');
  final _genderController = TextEditingController(text: 'Male');
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userType = ref.watch(userTypeProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
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
        actions: [
          if (userType == UserType.premium)
            TextButton(
              onPressed: _saveChanges,
              child:
                  _isLoading
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Text('Save'),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Picture Section
              _buildProfilePictureSection(context, theme, isDark),
              const SizedBox(height: 24),

              // Basic Information
              _buildSectionHeader(context, theme, isDark, 'Basic Information'),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _nameController,
                label: 'Full Name',
                hint: 'Enter your full name',
                prefixIcon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _emailController,
                label: 'Email Address',
                hint: 'Enter your email address',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _phoneController,
                label: 'Phone Number',
                hint: 'Enter your phone number',
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Personal Details
              _buildSectionHeader(context, theme, isDark, 'Personal Details'),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _ageController,
                label: 'Age',
                hint: 'Enter your age',
                prefixIcon: Icons.cake,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age < 1 || age > 120) {
                    return 'Please enter a valid age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _genderController,
                label: 'Gender',
                hint: 'Enter your gender',
                prefixIcon: Icons.person_outline,
                readOnly: true,
                onTap: () => _showGenderPicker(context),
              ),
              const SizedBox(height: 24),

              // Premium Features
              if (userType == UserType.premium) ...[
                _buildPremiumFeaturesSection(context, theme, isDark),
                const SizedBox(height: 24),
              ] else ...[
                _buildUpgradeSection(context, theme, isDark),
                const SizedBox(height: 24),
              ],

              // Save Button
              if (userType == UserType.premium)
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : const Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    final userType = ref.watch(userTypeProvider);

    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors:
                        userType == UserType.premium
                            ? [const Color(0xFFFFD700), const Color(0xFFFFA500)]
                            : [AppColors.primaryBlue, const Color(0xFF1D4ED8)],
                  ),
                  borderRadius: BorderRadius.circular(60),
                  boxShadow: [
                    BoxShadow(
                      color: (userType == UserType.premium
                              ? const Color(0xFFFFD700)
                              : AppColors.primaryBlue)
                          .withAlpha((0.3 * 255).toInt()),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/profile.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (userType == UserType.premium)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.2 * 255).toInt()),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: AppColors.primaryBlue,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Profile Picture',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userType == UserType.premium
                ? 'Tap to change your profile picture'
                : 'Upgrade to Premium to customize your profile picture',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            textAlign: TextAlign.center,
          ),
        ],
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
                    const Color(0xFF1E293B).withAlpha((0.5 * 255).toInt()),
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
                      const Color(0xFF334155).withAlpha((0.5 * 255).toInt()),
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
              'Custom profile picture, detailed personal information, and advanced profile customization options.',
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
                      const Color(0xFF334155).withAlpha((0.5 * 255).toInt()),
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
              'Unlock custom profile pictures, detailed personal information, and advanced profile customization.',
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

  void _showGenderPicker(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Gender'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Male'),
                  onTap: () {
                    _genderController.text = 'Male';
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('Female'),
                  onTap: () {
                    _genderController.text = 'Female';
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('Other'),
                  onTap: () {
                    _genderController.text = 'Other';
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Personal information updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      context.go('/main/profile');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
