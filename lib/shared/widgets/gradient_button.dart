import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const GradientButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.icon,
    this.padding,
    this.borderRadius = 32,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0092DF), Color(0xFF00C853)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0092DF).withOpacity(0.18),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.18), width: 1.5),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: isEnabled ? onPressed : null,
            child: Padding(
              padding:
                  padding ??
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Center(
                child:
                    isLoading
                        ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (icon != null) ...[
                              Icon(icon, color: Colors.white, size: 22),
                              const SizedBox(width: 10),
                            ],
                            Flexible(
                              child: Text(
                                text,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.2,
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
          ),
        ),
      ),
    );
  }
}

class SecondaryGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const SecondaryGradientButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.icon,
    this.padding,
    this.borderRadius = 32,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;
    const borderGradient = LinearGradient(
      colors: [Color(0xFF0092DF), Color(0xFF00C853)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0092DF).withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(width: 2, color: const Color(0xFF0092DF)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: isEnabled ? onPressed : null,
            child: Padding(
              padding:
                  padding ??
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Center(
                child:
                    isLoading
                        ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF0092DF),
                            ),
                          ),
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (icon != null) ...[
                              Icon(
                                icon,
                                color: const Color(0xFF0092DF),
                                size: 22,
                              ),
                              const SizedBox(width: 10),
                            ],
                            Flexible(
                              child: Text(
                                text,
                                style: const TextStyle(
                                  color: Color(0xFF0092DF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.2,
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
          ),
        ),
      ),
    );
  }
}
