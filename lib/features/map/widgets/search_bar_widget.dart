import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String)? onSearchChanged;
  final VoidCallback? onArrowPressed;

  const SearchBarWidget({super.key, this.onSearchChanged, this.onArrowPressed});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: context.responsivePadding(horizontal: 16, top: 16),
        child: Row(
          children: [
            // 1. The Search Input Field
            Expanded(
              child: Container(
                height: 50.h(context),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12.r(context)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  onChanged: widget.onSearchChanged,
                  textDirection:
                      TextDirection.rtl, // Ensures Arabic starts from right
                  decoration: InputDecoration(
                    hintText: 'ابحث عن مهام قريبة منك...',
                    hintStyle: TextStyles.cairoRegular14Muted(context),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20.r(context),
                      color: AppColors.gray,
                    ),
                    suffixIcon: _controller.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _controller.clear();
                              widget.onSearchChanged?.call('');
                              setState(() {}); // Refresh to hide clear icon
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: context.responsivePadding(vertical: 14),
                  ),
                ),
              ),
            ),
            horizontalSpace(context, width: 12),

            // 2. The Action Button (Arrow)
            GestureDetector(
              onTap: widget.onArrowPressed,
              child: Container(
                height: 50.h(context),
                width: 50.w(context),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12.r(context)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 18.r(context),
                    color: AppColors.dark,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
