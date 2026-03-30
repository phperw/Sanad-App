import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extensions.dart';
import '../../../../core/theme/app_colors.dart';

class CircularAvatarWidget extends StatelessWidget {
  final String imageUrl;

  const CircularAvatarWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final double size = 80.w(context);
    final double borderWidth = 2.20.w(context);
    final double padding = 2.w(context);

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(padding),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: borderWidth, color: AppColors.chatChipBorder),
          borderRadius: BorderRadius.circular(100.r(context)),
        ),
      ),
      child: Container(
        width: size,
        height: size,
        decoration: ShapeDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.fill,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.r(context)),
          ),
        ),
      ),
    );
  }
}
