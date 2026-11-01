import 'package:flutter/material.dart';
import '../../../../../core/constants/app_images.dart';

class HeaderAuth extends StatelessWidget {
  const HeaderAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 100),
        Image.asset(Assets.imageAthara, width: 150, height: 150),
      ],
    );
  }
}
