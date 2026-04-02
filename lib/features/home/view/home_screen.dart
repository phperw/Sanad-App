// import 'package:flutter/material.dart';
// import 'widget/stats_row.dart';
// import 'widget/task_header.dart';
// import '../../../core/helper/responsive_extensions.dart';
// import '../../../core/helper/spacing.dart';
// import 'widget/header_section.dart';
// import 'widget/news_section.dart';
// import 'widget/sos_button.dart';
// import 'widget/scheduled_task_card.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: SafeArea(
//         child: ListView(
//           padding: EdgeInsets.symmetric(horizontal: 16.w(context)),
//           children: [
//             HeaderSection(),
//             verticalSpace(context, height: 20),
//             SOSButton(),
//             verticalSpace(context, height: 20),
//             StatsRow(),
//             verticalSpace(context, height: 20),
//             NewsSection(),
//             verticalSpace(context, height: 20),
//             TasksHeader(tasksCount: 2),
//             verticalSpace(context, height: 16),
//             ScheduledTaskCard(
//               time: 'AM 10:00',
//               remainingTime: 'متبقي 2س',
//               locationName: 'منطقة أكتوبر السكنية',
//               taskType: 'مهمة ميدانية سريعة',
//             ),
//             verticalSpace(context, height: 12),
//             ScheduledTaskCard(
//               time: 'PM 2:30',
//               remainingTime: 'متبقي 5س',
//               locationName: 'حي المعادي - شارع 9',
//               taskType: 'دعم لوجستي و توزيع',
//             ),
//             verticalSpace(context, height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad/core/di/dependency_injection.dart';
import 'package:sanad/features/home/logic/home_cubit.dart';
import 'package:sanad/features/home/view/widget/home_body.dart';
import 'package:sanad/features/home/view/widget/home_cubit_listener.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..getHomeData(),
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(child: HomeCubitListener(child: HomeBody())),
      ),
    );
  }
}
