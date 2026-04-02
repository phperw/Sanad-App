import 'package:flutter/material.dart';
import 'package:sanad/core/helper/spacing.dart';
import '../../data/models/home_response.dart';
import 'empty_state_widget.dart';
import 'scheduled_task_card.dart';
import 'task_header.dart';

class TasksSection extends StatelessWidget {
  final List<HomeTask> tasks;

  const TasksSection({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TasksHeader(tasksCount: tasks.length),
        verticalSpace(context, height: 16),
        if (tasks.isEmpty)
          const EmptyStateWidget(
            message: 'لا توجد مهام معينة لك اليوم',
            icon: Icons.task_alt,
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
                time: task.time,
                remainingTime: task.remainingTime,
                locationName: task.locationName,
                taskType: task.taskType,
              );
            },
          ),
      ],
    );
  }
}
