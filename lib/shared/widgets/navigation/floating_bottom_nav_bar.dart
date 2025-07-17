import 'package:caredify/shared/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart' as intl;

class FloatingBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const FloatingBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required UserType userType,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isRtl = intl.Bidi.isRtlLanguage(locale.languageCode);
    final items = [
      _NavBarItem(
        icon: Icons.home,
        label: AppLocalizations.of(context)!.homeTab,
      ),
      _NavBarItem(
        icon: Icons.watch,
        label: AppLocalizations.of(context)!.watchTab,
      ),

      _NavBarItem(
        icon: Icons.chat_bubble_outline,
        label: AppLocalizations.of(context)!.chatTab,
      ),

      _NavBarItem(
        icon: Icons.person_outline,
        label: AppLocalizations.of(context)!.profileTab,
      ),
    ];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBarColor =
        isDark
            ? const Color(0xFF232325) // lighter black for dark mode
            : Colors.white;
    final shadowColor = Colors.grey.withAlpha((0.15 * 255).round());

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Material(
        color: Colors.transparent,
        elevation: 8,
        borderRadius: BorderRadius.circular(35),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: navBarColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isActive = index == selectedIndex;
              return Expanded(
                child: Semantics(
                  button: true,
                  selected: isActive,
                  label: items[index].label + (isActive ? ', selected' : ''),
                  child: GestureDetector(
                    onTap: () => onTabSelected(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(
                        vertical: 9,
                        horizontal: 4,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 0,
                      ),
                      decoration:
                          isActive
                              ? BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF0092DF),
                                    Color(0xFF00C853),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(25),
                              )
                              : null,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            child: Icon(
                              items[index].icon,
                              color:
                                  isActive
                                      ? Colors.white
                                      : isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[900],
                              size: isActive ? 25 : 25,
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child:
                                isActive
                                    ? SizedBox(
                                      height: 16,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          items[index].label,
                                          key: ValueKey(items[index].label),
                                          style: Theme.of(
                                            context,
                                          ).textTheme.labelSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                    : SizedBox(
                                      key: ValueKey(
                                        'empty_${items[index].label}',
                                      ),
                                      height: 0,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem {
  final IconData icon;
  final String label;
  const _NavBarItem({required this.icon, required this.label});
}
