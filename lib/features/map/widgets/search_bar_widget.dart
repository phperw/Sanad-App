import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';

class SearchBarWidget extends StatelessWidget {
  final Function(String) onChanged;

  const SearchBarWidget({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60.h(context),
      left: 16.w(context),
      right: 16.w(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w(context)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r(context)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Directionality(
          textDirection: TextDirection.rtl, // RTL: Start is Right, End is Left
          child: TextField(
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: 'إبحث عن مهام قريبة منك...',
              hintStyle: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                color: Colors.grey,
              ),
              border: InputBorder.none,
              suffixIcon: const Icon(Icons.search, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}
