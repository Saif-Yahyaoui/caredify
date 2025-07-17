import 'package:flutter/material.dart';

class PremiumTabBar extends StatelessWidget {
  final List<TabData> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final bool isDark;

  const PremiumTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color:
            isDark
                ? const Color(0xFF1E293B).withAlpha((0.8 * 255).toInt())
                : Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color:
              isDark
                  ? const Color(0xFF475569).withAlpha((0.3 * 255).toInt())
                  : const Color(0xFFE2E8F0),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withAlpha((0.3 * 255).toInt())
                    : Colors.grey.withAlpha((0.1 * 255).toInt()),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      height: 56,
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isSelected = selectedIndex == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                decoration:
                    isSelected
                        ? BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0092DF), Color(0xFF00C853)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF0092DF,
                              ).withAlpha((0.3 * 255).toInt()),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        )
                        : null,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tabs[i].icon,
                      size: isSelected ? 18 : 16,
                      color:
                          isSelected
                              ? Colors.white
                              : (isDark ? Colors.grey[400] : Colors.grey[600]),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 8),
                      Text(
                        tabs[i].label,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class TabData {
  final String label;
  final IconData icon;
  const TabData(this.label, this.icon);
}
