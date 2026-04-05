import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/features/campaign/logic/cubit/campaign_cubit.dart';
import 'package:sanad/features/campaign/logic/cubit/campaign_state.dart';
import 'mission_card_widget.dart';
// lib/features/map/view/widgets/missions_bottom_sheet_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'mission_card_widget.dart';

class MissionsBottomSheetWidget extends StatelessWidget {
  const MissionsBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: context.screenHeight * 0.45,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r(context)),
            topRight: Radius.circular(24.r(context)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          children: [
            verticalSpace(context, height: 20),
            Text(
              'المهام الميدانية',
              style: TextStyles.cairoBold32Dark(context)
                  .copyWith(fontSize: 18.sp(context)),
            ),
            verticalSpace(context, height: 16),

            Expanded(
              child: BlocBuilder<CampaignsCubit, CampaignsState>(
                builder: (context, state) {
                  if (state is CampaignsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is CampaignsError) {
                    return Center(
                      child: Text(state.message,
                          style: const TextStyle(color: Colors.red)),
                    );
                  }

                  if (state is CampaignsSuccess) {
                    final cubit = context.read<CampaignsCubit>();
                    return ListView.builder(
                      padding: context.responsivePadding(horizontal: 16),
                      itemCount: state.campaigns.length,
                      itemBuilder: (context, index) {
                        final campaign = state.campaigns[index];
                     return MissionCardWidget(
  title: campaign.location?.name ?? '',                              // ← ?? ''
  distance: cubit.getDistance(campaign),
  isActive: cubit.isWithinRange(campaign),
  taskLatitude: campaign.location?.latitude ?? 0,          // ← ?. و ?? 0
  taskLongitude: campaign.location?.longitude ?? 0,        // ← ?. و ?? 0
  radiusMeters: (campaign.attendance?.radiusMeters ?? 0).toDouble(), // ← ?. و ?? 0
  camp: campaign,
);
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// class MissionsBottomSheetWidget extends StatelessWidget {
//   const MissionsBottomSheetWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Container(
//         height: context.screenHeight * 0.45, // Responsive height
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: Theme.of(context).cardColor,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(24.r(context)),
//             topRight: Radius.circular(24.r(context)),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, -4),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             verticalSpace(context, height: 20),
//             // Header Title
//             Text(
//               'المهام الميدانية',
//               style: TextStyles.cairoBold32Dark(
//                 context,
//               ).copyWith(fontSize: 18.sp(context)),
//             ),
//             verticalSpace(context, height: 16),

//             // Scrollable List of Missions
//             Expanded(
//               child: ListView(
//                 padding: context.responsivePadding(horizontal: 16),
//                 children: const [
//                   MissionCardWidget(
//                     title: 'منطقة أكتوبر السكنية',
//                     distance: 'على بعد 50 متر',
//                     isActive: true,
//                   ),
//                   MissionCardWidget(
//                     title: 'حي المعادي - شارع 9',
//                     distance: 'على بعد 15 كم',
//                     isActive: false,
//                   ),
//                   MissionCardWidget(
//                     title: 'مصر الجديدة',
//                     distance: 'على بعد 40 كم',
//                     isActive: true,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
