import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/helper/spacing.dart';
import '../../../../core/routing/router.dart';
import '../../data/models/home_response.dart';
import 'empty_state_widget.dart';
import 'scheduled_task_card.dart';
import 'task_header.dart';
import 'package:solar_icons/solar_icons.dart';

class TasksSection extends StatelessWidget {
  final List<HomeTask> tasks;
  final String title;
  final String emptyMessage;
  final VoidCallback? onMissionReportSubmitted;

  const TasksSection({
    super.key,
    required this.tasks,
    this.title = 'مهام اليوم',
    this.emptyMessage = 'لا توجد مهام معينة لك اليوم',
    this.onMissionReportSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TasksHeader(tasksCount: tasks.length, title: title),
        verticalSpace(context, height: 16),
        if (tasks.isEmpty)
          EmptyStateWidget(
            message: emptyMessage,
            icon: SolarIconsOutline.checkCircle,
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tasks.length,
            separatorBuilder: (context, index) =>
                verticalSpace(context, height: 12),
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ScheduledTaskCard(
                title: task.title,
                time: task.displayTime,
                remainingTime: task.isCompleted
                    ? 'مكتملة'
                    : task.remainingTimeLabel,
                locationName: task.location.name,
                taskType: task.campaign.title,
                isCompleted: task.isCompleted,
                onTap: () => context.push(
                  AppRouter.kMissionDetails.replaceFirst(
                    ':missionId',
                    task.id.toString(),
                  ),
                  extra: onMissionReportSubmitted,
                ),
              );
            },
          ),
      ],
    );
  }
}
