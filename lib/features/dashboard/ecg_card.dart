import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ECGCard extends StatelessWidget {
  const ECGCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration:  const  BoxDecoration(
                color:  Color(0xFFFFE5E5),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/ecg.svg',
                  width: 20,
                  height: 20,
  colorFilter: const ColorFilter.mode( Color(0xFFFF6B81), BlendMode.srcIn),
                  placeholderBuilder:
                      (context) =>  const  Icon(
                        Icons.favorite,
                        size: 20,
                        color:  Color(0xFFFF6B81),
                      ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'ECG',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFF6B81),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Average ECG Value: 00 BPM',
                    style: theme.textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            TextButton(
  onPressed: () {
    // TODO: Navigate to ECG details screen
  },
  style: TextButton.styleFrom(
    foregroundColor: const Color(0xFFFF6B81),
    textStyle: const TextStyle(fontWeight: FontWeight.bold),
  ),
  child: Text(AppLocalizations.of(context)!.seeMore),
),
          ],
        ),
      ),
    );
  }
}
