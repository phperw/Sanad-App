import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_images.dart';
import '../../../../../core/helper/responsive_extensions.dart';
import '../../../../../core/helper/spacing.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/text_styles.dart';

class CommunityPostCard extends StatelessWidget {
  final String userName;
  final String timeAgo;
  final String postText;
  final String? imageUrl;
  final String avatarUrl;
  final int likesCount;
  final int commentsCount;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;

  const CommunityPostCard({
    super.key,
    required this.userName,
    required this.timeAgo,
    required this.postText,
    required this.avatarUrl,
    this.imageUrl,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.onLike,
    this.onComment,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          top: 20.h(context),
          right: 16.w(context),
          left: 16.w(context),
        ),
        decoration: ShapeDecoration(
          color: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r(context)),
          ),
          shadows: const [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 4,
              offset: Offset(0, 2),
              spreadRadius: -2,
            ),
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 6,
              offset: Offset(0, 4),
              spreadRadius: -1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Header: Avatar + Name + Time
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      userName,
                      style: TextStyles.cairoBold16DarkBlue(context),
                    ),
                    Text(
                      timeAgo,
                      style: TextStyles.cairoRegular10Gray(context),
                    ),
                  ],
                ),
                horizontalSpace(context, width: 8),
                Container(
                  width: 40.w(context),
                  height: 40.w(context),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(avatarUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            verticalSpace(context, height: 8),

            // Post text
            Text(
              postText,
              textAlign: TextAlign.right,
              style: TextStyles.cairoRegular12DarkBlue(context),
            ),
            verticalSpace(context, height: 4),

            // Post image (optional)
            if (imageUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(14.r(context)),
                child: Image.asset(
                  imageUrl!,
                  width: double.infinity,
                  height: 180.h(context),
                  fit: BoxFit.cover,
                ),
              ),
              verticalSpace(context, height: 8),
            ],

            // Actions bar
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h(context)),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1, color: AppColors.dividerColor),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // مشاركة
                  _ActionButton(
                    iconPath: Assets.share,
                    label: 'مشاركة',
                    count: null,
                    isActive: true,
                    onTap: onShare,
                  ),
                  horizontalSpace(context, width: 24),

                  // تعليق
                  _ActionButton(
                    iconPath: Assets.comment,
                    label: 'تعليق',
                    count: commentsCount,
                    isActive: false,
                    onTap: onComment,
                  ),
                  horizontalSpace(context, width: 24),

                  // إعجاب
                  _ActionButton(
                    iconPath: Assets.like,
                    label: 'إعجاب',
                    count: likesCount,
                    isActive: false,
                    onTap: onLike,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final int? count;
  final bool isActive;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.iconPath,
    required this.label,
    required this.isActive,
    this.count,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.chatChipBorder : AppColors.textGray;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (count != null) ...[
            Text(
              '$count',
              style: TextStyle(
                color: AppColors.textGray,
                fontSize: 14.sp(context),
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w500,
                height: 1.43,
              ),
            ),
            horizontalSpace(context, width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 14.sp(context),
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w600,
              height: 1.43,
            ),
          ),
          horizontalSpace(context, width: 6),
          SvgPicture.asset(
            iconPath,
            width: 20.w(context),
            height: 20.w(context),
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
        ],
      ),
    );
  }
}
