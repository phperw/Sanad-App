import 'package:flutter/material.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/core/helper/spacing.dart';
import '../../data/models/home_response.dart';
import 'stat_card.dart';

class StatsRow extends StatelessWidget {
  final Stats stats;

  const StatsRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'عدد الساعات',
            value: '${stats.totalHours}',
            valueStyle: TextStyles.cairoBold24Primary(context),
          ),
        ),
        horizontalSpace(context, width: 15),
        Expanded(
          child: StatCard(
            title: 'إنجازاتي',
            value: '${stats.badges}',
            valueStyle: TextStyles.cairoBold24Orange(context),
          ),
        ),
      ],
    );
  }
}
