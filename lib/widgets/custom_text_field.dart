import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_colors.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Custom text field widget with CAREDIFY styling and validation
class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? errorText;
  final String? helperText;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.focusNode,
    this.autofocus = false,
    this.errorText,
    this.helperText,
  });

  /// Phone number field factory
  factory CustomTextField.phone({
    required String label,
    required String hint,
    TextEditingController? controller,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    FocusNode? focusNode,
    String? errorText,
    Key? key,
  }) {
    return CustomTextField(
      key: key,
      label: label,
      hint: hint,
      controller: controller,
      keyboardType: TextInputType.phone,
      prefixIcon: Icons.phone,
      validator: validator,
      onChanged: onChanged,
      focusNode: focusNode,
      errorText: errorText,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(15),
      ],
    );
  }

  /// Password field factory
  factory CustomTextField.password({
    required String label,
    required String hint,
    TextEditingController? controller,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
    FocusNode? focusNode,
    String? errorText,
    bool showVisibilityToggle = true,
    Key? key,
  }) {
    return _PasswordTextField(
      key: key,
      label: label,
      hint: hint,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      errorText: errorText,
      showVisibilityToggle: showVisibilityToggle,
    );
  }

  /// Email field factory
  factory CustomTextField.email({
    required String label,
    required String hint,
    TextEditingController? controller,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    FocusNode? focusNode,
    String? errorText,
    Key? key,
  }) {
    return CustomTextField(
      key: key,
      label: label,
      hint: hint,
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Icons.email,
      validator: validator,
      onChanged: onChanged,
      focusNode: focusNode,
      errorText: errorText,
      textCapitalization: TextCapitalization.none,
    );
  }

  /// Name field factory
  factory CustomTextField.name({
    required String label,
    required String hint,
    TextEditingController? controller,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    FocusNode? focusNode,
    String? errorText,
    Key? key,
  }) {
    return CustomTextField(
      key: key,
      label: label,
      hint: hint,
      controller: controller,
      keyboardType: TextInputType.name,
      prefixIcon: Icons.person,
      validator: validator,
      onChanged: onChanged,
      focusNode: focusNode,
      errorText: errorText,
      textCapitalization: TextCapitalization.words,
    );
  }

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = widget.errorText != null;
    final locale = Localizations.localeOf(context);
    final isRtl = intl.Bidi.isRtlLanguage(locale.languageCode);

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.label!,
                  style: theme.textTheme.labelLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

          TextFormField(
            controller: _controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            validator: widget.validator,
            onChanged: widget.onChanged,
            onTap: widget.onTap,
            onFieldSubmitted: widget.onSubmitted,
            inputFormatters: widget.inputFormatters,
            textCapitalization: widget.textCapitalization,
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,

            style: theme.textTheme.bodyLarge?.copyWith(
              color: widget.enabled ? null : AppColors.mediumGray,
            ),

            decoration: InputDecoration(
              hintText: widget.hint,
              prefixIcon:
                  widget.prefixIcon != null
                      ? Icon(
                        widget.prefixIcon,
                        color:
                            hasError
                                ? AppColors.alertRed
                                : AppColors.mediumGray,
                        size: 20,
                      )
                      : null,
              suffixIcon: widget.suffixIcon,
              errorText: widget.errorText,
              helperText: widget.helperText,

              // Custom styling
              filled: true,
              fillColor:
                  widget.enabled
                      ? (hasError
                          ? AppColors.alertBackground
                          : AppColors.surfaceLight)
                      : AppColors.lightGray,

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: hasError ? AppColors.alertRed : AppColors.inputBorder,
                  width: 1,
                ),
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: hasError ? AppColors.alertRed : AppColors.inputBorder,
                  width: 1,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: hasError ? AppColors.alertRed : AppColors.inputFocused,
                  width: 2,
                ),
              ),

              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.alertRed,
                  width: 1,
                ),
              ),

              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.alertRed,
                  width: 2,
                ),
              ),

              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.lightGray,
                  width: 1,
                ),
              ),

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Password field with visibility toggle
class _PasswordTextField extends CustomTextField {
  final bool showVisibilityToggle;

const _PasswordTextField({
  super.key,
  super.label,
  super.hint,
  super.controller,
  super.validator,
  super.onChanged,
  super.onSubmitted,
  super.focusNode,
  super.errorText,
  this.showVisibilityToggle = true,
});

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: widget.label,
      hint: widget.hint,
      controller: widget.controller,
      keyboardType: TextInputType.visiblePassword,
      obscureText: _obscureText,
      prefixIcon: Icons.lock,
      suffixIcon:
          widget.showVisibilityToggle
              ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.mediumGray,
                  size: 20,
                ),
                onPressed: _toggleVisibility,
                tooltip:
                    widget.showVisibilityToggle
                        ? AppLocalizations.of(context)!.showPassword
                        : AppLocalizations.of(context)!.hidePassword,
              )
              : null,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      focusNode: widget.focusNode,
      errorText: widget.errorText,
    );
  }
}
