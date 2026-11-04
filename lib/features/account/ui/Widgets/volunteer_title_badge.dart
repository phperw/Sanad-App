import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/features/account/data/models/volunteer_title.dart';
import 'package:solar_icons/solar_icons.dart';

class VolunteerTitleBadge extends StatelessWidget {
  final VolunteerTitle? title;
  final bool compact;

  const VolunteerTitleBadge({
    super.key,
    required this.title,
    this.compact = false,
  });

  static const _levelColors = <int, Color>{
    1: Color(0xFF56846C),
    2: Color(0xFF167C65),
    3: Color(0xFF3B78B4),
    4: Color(0xFF7659B5),
    5: Color(0xFFB07B16),
  };

  static IconData _iconForTitle(VolunteerTitle title) {
    final serverIcon = title.icon?.trim().toLowerCase().replaceAll('-', '_');
    switch (serverIcon) {
      case 'seedling':
      case 'sprout':
      case 'leaf':
        return SolarIconsOutline.leaf;
      case 'heart':
      case 'hand_heart':
      case 'handheart':
        return SolarIconsOutline.heart;
      case 'star':
      case 'stars':
        return SolarIconsOutline.stars;
      case 'crown':
      case 'medal':
        return SolarIconsOutline.crown;
      case 'shield_star':
      case 'verified_check':
      case 'verifiedcheck':
        return SolarIconsOutline.shieldStar;
    }

    switch (title.level) {
      case 1:
        return SolarIconsOutline.leaf;
      case 2:
        return SolarIconsOutline.heart;
      case 3:
        return SolarIconsOutline.stars;
      case 4:
        return SolarIconsOutline.crown;
      case 5:
        return SolarIconsOutline.shieldStar;
      default:
        return SolarIconsOutline.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    final volunteerTitle = title;
    if (volunteerTitle == null || volunteerTitle.name.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final color = _levelColors[volunteerTitle.level] ?? const Color(0xFF64748B);
    final horizontalPadding = compact ? 7.0 : 10.0;
    final verticalPadding = compact ? 2.0 : 4.0;
    final iconSize = compact ? 12.0 : 14.0;
    final textSize = compact ? 9.0 : 11.0;

    final badge = Container(
      constraints: BoxConstraints(maxWidth: 180.w(context)),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding.w(context),
        vertical: verticalPadding.h(context),
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withOpacity(0.24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _iconForTitle(volunteerTitle),
            size: iconSize.sp(context),
            color: color,
          ),
          SizedBox(width: 4.w(context)),
          Flexible(
            child: Text(
              volunteerTitle.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: textSize.sp(context),
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    );

    final description = volunteerTitle.description?.trim();
    if (description == null || description.isEmpty) return badge;
    return Tooltip(message: description, child: badge);
  }
}
