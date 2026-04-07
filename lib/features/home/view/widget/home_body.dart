import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/widgets/error_screen.dart';
import '../../data/models/home_response.dart';
import '../../logic/home_cubit.dart';
import '../../logic/home_state.dart';
import 'header_section.dart';
import 'news_section.dart';
import 'sos_button.dart';
import 'stats_row.dart';
import 'task_section.dart';

final _fakeLocation = TaskLocation(
  id: 0,
  name: 'اسم الموقع يظهر هنا',
  latitude: 0,
  longitude: 0,
  city: 'المدينة',
  area: 'المنطقة',
);

final _fakeCampaign = TaskCampaign(
  id: 0,
  title: 'اسم الحملة',
  coverImage: null,
);

final _fakeAssignment = TaskAssignment(status: 'ASSIGNED', checkInTime: null);

final _fakeVolunteer = Volunteer(
  id: 0,
  fullName: 'اسم المستخدم هنا',
  nationalId: '00000000000000',
  email: 'example@email.com',
  phone: '01000000000',
  avatarUrl: null,
  status: 'ACTIVE',
  totalHours: 120,
  points: 450,
);

final _fakeStats = Stats(
  totalHours: 120,
  points: 450,
  badges: 8,
  assignedTasks: 5,
  reports: 3,
  todayTasks: 2,
);

final _fakeAnnouncements = List.generate(
  2,
  (_) => Announcement(
    id: 0,
    title: 'عنوان الخبر يظهر هنا',
    description: 'تفاصيل الخبر أو التنبيه تظهر في هذا المكان',
    imageUrl: null,
    isPinned: false,
    createdAt: '',
  ),
);

final _fakeTasks = List.generate(
  2,
  (_) => HomeTask(
    id: 0,
    title: 'عنوان المهمة',
    description: 'وصف المهمة يظهر هنا',
    date: '2026-01-01',
    startTime: '10:00:00',
    endTime: '12:00:00',
    status: 'ASSIGNED',
    location: _fakeLocation,
    campaign: _fakeCampaign,
    assignment: _fakeAssignment,
  ),
);

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeFailure) {
          return Center(
            child: ErrorScreen(
              message: state.error.message,
              onRetry: () => context.read<HomeCubit>().getHomeData(),
            ),
          );
        }

        final isLoading = state is HomeLoading || state is HomeInitial;

        final volunteer = state is HomeSuccess
            ? state.data.summary.volunteer
            : _fakeVolunteer;
        final stats = state is HomeSuccess
            ? state.data.summary.stats
            : _fakeStats;
        final announcements = state is HomeSuccess
            ? state.data.summary.announcements
            : _fakeAnnouncements;
        final tasks = state is HomeSuccess
            ? state.data.summary.todayTasks
            : _fakeTasks;

        return Skeletonizer(
          enabled: isLoading,
          enableSwitchAnimation: true,
          effect: ShimmerEffect(
            baseColor: AppColors.lightGray,
            highlightColor: AppColors.lightGreenishWhite,
            duration: const Duration(milliseconds: 1200),
          ),
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w(context)),
            children: [
              verticalSpace(context, height: 16),
              HeaderSection(volunteer: volunteer),
              verticalSpace(context, height: 20),
              SOSButton(
                onTap: () {
                  context.push('/emergency');
                },
              ),
              verticalSpace(context, height: 20),
              StatsRow(stats: stats),
              verticalSpace(context, height: 20),
              NewsSection(announcements: announcements),
              verticalSpace(context, height: 20),
              TasksSection(tasks: tasks),
              verticalSpace(context, height: 30),
            ],
          ),
        );
      },
    );
  }
}
