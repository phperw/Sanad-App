import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sanad/core/di/dependency_injection.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:solar_icons/solar_icons.dart';

import '../data/models/mission_details.dart';
import '../logic/mission_cubit.dart';

class MissionDetailsScreen extends StatelessWidget {
  final int missionId;
  final VoidCallback? onReportSubmitted;

  const MissionDetailsScreen({
    super.key,
    required this.missionId,
    this.onReportSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MissionCubit>()..loadMission(missionId),
      child: _MissionDetailsView(
        missionId: missionId,
        onReportSubmitted: onReportSubmitted,
      ),
    );
  }
}

class _MissionDetailsView extends StatefulWidget {
  final int missionId;
  final VoidCallback? onReportSubmitted;

  const _MissionDetailsView({required this.missionId, this.onReportSubmitted});

  @override
  State<_MissionDetailsView> createState() => _MissionDetailsViewState();
}

class _MissionDetailsViewState extends State<_MissionDetailsView> {
  final TextEditingController _notesController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final List<_MissionImage> _images = [];
  int _rating = 5;
  bool _isGettingLocation = false;
  bool _isBookmarked = false;
  bool _didNotifyReportSubmitted = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MissionCubit, MissionDetailsState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.successMessage != current.successMessage,
      listener: (context, state) {
        if (state.reportSubmitted && !_didNotifyReportSubmitted) {
          _didNotifyReportSubmitted = true;
          widget.onReportSubmitted?.call();
        }
        final message = state.errorMessage ?? state.successMessage;
        if (message == null || !context.mounted) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      },
      builder: (context, state) {
        final mission = state.mission;
        if (mission == null) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SafeArea(
              child: state.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    )
                  : _loadFailure(context, state),
            ),
          );
        }

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      color: AppColors.primaryColor,
                      onRefresh: () => context.read<MissionCubit>().loadMission(
                        widget.missionId,
                      ),
                      child: ListView(
                        padding: EdgeInsets.only(bottom: 20.h(context)),
                        children: [
                          _heroWithMissionInfo(context, mission),
                          Padding(
                            padding: context.responsivePadding(horizontal: 18),
                            child: _rewardCard(context, mission.reward),
                          ),
                          SizedBox(height: 14.h(context)),
                          Padding(
                            padding: context.responsivePadding(horizontal: 18),
                            child: _stepsCard(context, mission),
                          ),
                          SizedBox(height: 14.h(context)),
                          Padding(
                            padding: context.responsivePadding(horizontal: 18),
                            child: _reportCard(context, mission, state),
                          ),
                          SizedBox(height: 12.h(context)),
                        ],
                      ),
                    ),
                  ),
                  _bottomAction(context, mission, state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _heroWithMissionInfo(BuildContext context, MissionDetails mission) {
    final heroHeight = context.screenWidth / 3;
    final overlap = 24.h(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        _hero(context, mission),
        Padding(
          padding: EdgeInsets.only(
            top: heroHeight - overlap,
            left: 18.w(context),
            right: 18.w(context),
          ),
          child: _missionInfo(context, mission),
        ),
      ],
    );
  }

  Widget _loadFailure(BuildContext context, MissionDetailsState state) {
    return Center(
      child: Padding(
        padding: context.responsivePadding(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              SolarIconsOutline.refreshCircle,
              color: AppColors.primaryColor,
              size: 42.r(context),
            ),
            SizedBox(height: 12.h(context)),
            Text(
              state.errorMessage ?? 'تعذر تحميل تفاصيل المهمة',
              textAlign: TextAlign.center,
              style: TextStyles.cairoRegular14Muted(context),
            ),
            SizedBox(height: 16.h(context)),
            ElevatedButton(
              onPressed: () =>
                  context.read<MissionCubit>().loadMission(widget.missionId),
              child: const Text('إعادة المحاولة'),
            ),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('رجوع'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hero(BuildContext context, MissionDetails mission) {
    final imageUrl = mission.coverImage;
    return SizedBox(
      height: context.screenWidth / 3,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imageUrl != null && imageUrl.trim().isNotEmpty)
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _defaultHero(),
            )
          else
            _defaultHero(),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.18),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.46),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8.h(context),
            left: 16.w(context),
            right: 16.w(context),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                children: [
                  _heroButton(
                    context,
                    SolarIconsOutline.arrowLeft,
                    () => context.pop(),
                  ),
                  const Spacer(),
                  Text(
                    'تفاصيل المهمة',
                    style: TextStyles.cairoBold32Dark(context).copyWith(
                      fontSize: 19.sp(context),
                      color: Colors.white,
                      shadows: const [
                        Shadow(color: Colors.black38, blurRadius: 8),
                      ],
                    ),
                  ),
                  const Spacer(),
                  _heroButton(
                    context,
                    _isBookmarked
                        ? SolarIconsOutline.bookmarkOpened
                        : SolarIconsOutline.bookmark,
                    () => setState(() => _isBookmarked = !_isBookmarked),
                  ),
                  SizedBox(width: 8.w(context)),
                  _heroButton(context, SolarIconsOutline.share, () {
                    Clipboard.setData(
                      ClipboardData(
                        text: '${mission.title}\n${mission.description}',
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم نسخ تفاصيل المهمة')),
                    );
                  }),
                ],
              ),
            ),
          ),
          Positioned(
            right: 18.w(context),
            bottom: 42.h(context),
            child: Container(
              padding: context.responsivePadding(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(30.r(context)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    mission.typeLabel,
                    style: TextStyles.cairoBold32Dark(
                      context,
                    ).copyWith(color: Colors.white, fontSize: 12.sp(context)),
                  ),
                  SizedBox(width: 6.w(context)),
                  Icon(
                    SolarIconsOutline.handHeart,
                    color: Colors.white,
                    size: 18.r(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultHero() {
    return Image.asset(
      'assets/images/Reaching Hands at Sunrise.png',
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Container(
        color: AppColors.lightGreenishWhite,
        child: const Center(
          child: Icon(
            SolarIconsOutline.handHeart,
            color: AppColors.primaryColor,
            size: 68,
          ),
        ),
      ),
    );
  }

  Widget _heroButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Material(
      color: Colors.white.withValues(alpha: 0.88),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 42.r(context),
          height: 42.r(context),
          child: Icon(icon, color: AppColors.dark, size: 21.r(context)),
        ),
      ),
    );
  }

  Widget _missionInfo(BuildContext context, MissionDetails mission) {
    return Container(
      padding: context.responsivePadding(all: 18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(28.r(context)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mission.title,
            style: TextStyles.cairoBold32Dark(context).copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 23.sp(context),
              height: 1.35,
            ),
          ),
          SizedBox(height: 6.h(context)),
          Text(
            mission.description,
            style: TextStyles.cairoRegular14Muted(context).copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.68),
              fontSize: 13.sp(context),
              height: 1.7,
            ),
          ),
          SizedBox(height: 20.h(context)),
          Row(
            children: [
              Expanded(
                child: _metric(
                  context,
                  SolarIconsOutline.usersGroupRounded,
                  'المتطوعون',
                  '${mission.volunteersCount}',
                ),
              ),
              _verticalDivider(context),
              Expanded(
                child: _metric(
                  context,
                  SolarIconsOutline.clockCircle,
                  'المدة',
                  '${mission.durationHours} ساعات',
                ),
              ),
              _verticalDivider(context),
              Expanded(
                child: _metric(
                  context,
                  SolarIconsOutline.mapPoint,
                  'الموقع',
                  mission.location.name.isEmpty
                      ? mission.location.city
                      : mission.location.name.trim(),
                ),
              ),
              _verticalDivider(context),
              Expanded(
                child: _metric(
                  context,
                  SolarIconsOutline.calendar,
                  'التاريخ',
                  _dateLabel(mission.date),
                ),
              ),
            ],
          ),
          if (mission.campaign.title.isNotEmpty) ...[
            SizedBox(height: 14.h(context)),
            Text(
              'ضمن حملة: ${mission.campaign.title}',
              style: TextStyles.cairoRegular14Muted(context).copyWith(
                color: AppColors.primaryColor,
                fontSize: 12.sp(context),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _metric(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 22.r(context)),
        SizedBox(height: 5.h(context)),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyles.cairoRegular14Muted(
            context,
          ).copyWith(fontSize: 10.sp(context)),
        ),
        SizedBox(height: 2.h(context)),
        Text(
          value,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.cairoBold32Dark(context).copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 11.sp(context),
          ),
        ),
      ],
    );
  }

  Widget _verticalDivider(BuildContext context) {
    return Container(
      height: 54.h(context),
      width: 1,
      color: Theme.of(context).dividerColor,
      margin: EdgeInsets.symmetric(horizontal: 4.w(context)),
    );
  }

  Widget _rewardCard(BuildContext context, MissionReward reward) {
    return Container(
      padding: context.responsivePadding(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.lightGreenishWhite,
        borderRadius: BorderRadius.circular(18.r(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                SolarIconsOutline.gift,
                color: AppColors.primaryColor,
                size: 22.r(context),
              ),
              SizedBox(width: 8.w(context)),
              Text(
                'مكافأة إتمام المهمة',
                style: TextStyles.cairoBold32Dark(
                  context,
                ).copyWith(color: AppColors.dark, fontSize: 15.sp(context)),
              ),
            ],
          ),
          SizedBox(height: 12.h(context)),
          Row(
            children: [
              Expanded(
                child: _rewardValue(
                  context,
                  SolarIconsOutline.clockCircle,
                  '+${reward.hours}',
                  'ساعات تطوع',
                ),
              ),
              _rewardDivider(context),
              Expanded(
                child: _rewardValue(
                  context,
                  SolarIconsOutline.layers,
                  '+${reward.totalPoints}',
                  'نقطة',
                ),
              ),
              _rewardDivider(context),
              Expanded(
                child: _rewardValue(
                  context,
                  SolarIconsOutline.medalStar,
                  reward.badgeName ?? 'شارة',
                  'شارة المكافأة',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rewardValue(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 26.r(context)),
        SizedBox(height: 3.h(context)),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.cairoBold32Dark(
            context,
          ).copyWith(color: AppColors.dark, fontSize: 14.sp(context)),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.cairoRegular14Muted(context).copyWith(
            color: AppColors.descriptionGray,
            fontSize: 10.sp(context),
          ),
        ),
      ],
    );
  }

  Widget _rewardDivider(BuildContext context) {
    return Container(
      height: 50.h(context),
      width: 1,
      color: AppColors.primaryColor.withValues(alpha: 0.15),
      margin: EdgeInsets.symmetric(horizontal: 4.w(context)),
    );
  }

  Widget _stepsCard(BuildContext context, MissionDetails mission) {
    final steps = mission.steps;
    return Container(
      padding: context.responsivePadding(all: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18.r(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                SolarIconsOutline.listCheck,
                color: AppColors.primaryColor,
                size: 22.r(context),
              ),
              SizedBox(width: 8.w(context)),
              Text(
                'خطوات المهمة',
                style: TextStyles.cairoBold32Dark(context).copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 16.sp(context),
                ),
              ),
              const Spacer(),
              Text(
                '${mission.completedSteps}/${mission.totalSteps}',
                style: TextStyles.cairoBold32Dark(context).copyWith(
                  color: AppColors.primaryColor,
                  fontSize: 13.sp(context),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h(context)),
          if (steps.isEmpty)
            Text(
              'سيتم تحديث خطوات المهمة قريبًا',
              style: TextStyles.cairoRegular14Muted(context),
            )
          else
            ...List.generate(
              steps.length,
              (index) =>
                  _missionStep(context, steps[index], index < steps.length - 1),
            ),
        ],
      ),
    );
  }

  Widget _missionStep(BuildContext context, MissionStep step, bool hasNext) {
    final color = step.completed || step.isCurrent
        ? AppColors.primaryColor
        : AppColors.secondaryGray;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h(context)),
      child: Row(
        children: [
          Column(
            children: [
              Icon(
                step.completed
                    ? SolarIconsOutline.checkCircle
                    : step.isCurrent
                    ? SolarIconsOutline.playCircle
                    : SolarIconsOutline.clockCircle,
                color: color,
                size: 22.r(context),
              ),
              if (hasNext)
                Container(
                  width: 1,
                  height: 17.h(context),
                  color: Theme.of(context).dividerColor,
                ),
            ],
          ),
          SizedBox(width: 10.w(context)),
          Expanded(
            child: Text(
              step.title,
              style: TextStyles.cairoRegular14Muted(context).copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: step.isCurrent ? FontWeight.w700 : FontWeight.w400,
                fontSize: 13.sp(context),
              ),
            ),
          ),
          if (step.isCurrent)
            Text(
              'الحالية',
              style: TextStyles.cairoRegular14Muted(context).copyWith(
                color: AppColors.primaryColor,
                fontSize: 10.sp(context),
              ),
            ),
        ],
      ),
    );
  }

  Widget _reportCard(
    BuildContext context,
    MissionDetails mission,
    MissionDetailsState state,
  ) {
    final submitted = mission.hasSubmittedReport || state.reportSubmitted;
    return Container(
      padding: context.responsivePadding(all: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20.r(context)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                SolarIconsOutline.documentText,
                color: AppColors.primaryColor,
                size: 24.r(context),
              ),
              SizedBox(width: 8.w(context)),
              Expanded(
                child: Text(
                  'إرسال تقرير المهمة',
                  style: TextStyles.cairoBold32Dark(context).copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 17.sp(context),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h(context)),
          Text(
            submitted
                ? 'تم إرسال تقرير هذه المهمة'
                : 'أرفق تقريرًا مختصرًا عن تجربتك ودورك في المهمة.',
            style: TextStyles.cairoRegular14Muted(
              context,
            ).copyWith(fontSize: 12.sp(context)),
          ),
          if (!submitted) ...[
            SizedBox(height: 12.h(context)),
            TextField(
              controller: _notesController,
              minLines: 3,
              maxLines: 5,
              maxLength: 500,
              onChanged: (_) => setState(() {}),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              enabled: !state.isSubmitting,
              decoration: InputDecoration(
                hintText: 'اكتب تقريرك هنا...',
                hintStyle: TextStyles.cairoRegular14Muted(context),
                filled: true,
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r(context)),
                  borderSide: BorderSide(color: Theme.of(context).dividerColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r(context)),
                  borderSide: BorderSide(color: Theme.of(context).dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r(context)),
                  borderSide: const BorderSide(color: AppColors.primaryColor),
                ),
                counterStyle: TextStyles.cairoRegular14Muted(
                  context,
                ).copyWith(fontSize: 10.sp(context)),
              ),
            ),
            SizedBox(height: 8.h(context)),
            _ratingSelector(context, state.isSubmitting),
            SizedBox(height: 12.h(context)),
            _imagePickerRow(context, state.isSubmitting),
            if (!mission.canSubmitReport) ...[
              SizedBox(height: 12.h(context)),
              _permissionMessage(context, mission),
            ],
          ] else
            Padding(
              padding: EdgeInsets.only(top: 14.h(context)),
              child: Row(
                children: [
                  Icon(
                    SolarIconsOutline.checkCircle,
                    color: AppColors.primaryColor,
                    size: 20.r(context),
                  ),
                  SizedBox(width: 7.w(context)),
                  Text(
                    'سيظهر التقرير ضمن إنجازاتك في الملف الشخصي',
                    style: TextStyles.cairoRegular14Muted(context).copyWith(
                      color: AppColors.primaryColor,
                      fontSize: 11.sp(context),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _ratingSelector(BuildContext context, bool disabled) {
    return Row(
      children: [
        Text(
          'تقييم التجربة',
          style: TextStyles.cairoRegular14Muted(context).copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 12.sp(context),
          ),
        ),
        const Spacer(),
        ...List.generate(
          5,
          (index) => IconButton(
            visualDensity: VisualDensity.compact,
            constraints: BoxConstraints(
              minWidth: 30.w(context),
              minHeight: 34.h(context),
            ),
            padding: EdgeInsets.zero,
            onPressed: disabled
                ? null
                : () => setState(() => _rating = index + 1),
            icon: Icon(
              SolarIconsOutline.star,
              size: 21.r(context),
              color: index < _rating
                  ? AppColors.orange
                  : AppColors.secondaryGray,
            ),
          ),
        ),
      ],
    );
  }

  Widget _imagePickerRow(BuildContext context, bool disabled) {
    return Wrap(
      spacing: 10.w(context),
      runSpacing: 10.h(context),
      children: [
        ...List.generate(_images.length, (index) {
          final image = _images[index];
          return Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r(context)),
                child: Image.memory(
                  image.bytes,
                  width: 74.w(context),
                  height: 74.w(context),
                  fit: BoxFit.cover,
                ),
              ),
              if (!disabled)
                Positioned(
                  top: -7,
                  right: -7,
                  child: GestureDetector(
                    onTap: () => setState(() => _images.removeAt(index)),
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: AppColors.dark,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        SolarIconsOutline.closeCircle,
                        color: Colors.white,
                        size: 18.r(context),
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
        if (_images.length < 5)
          InkWell(
            onTap: disabled ? null : _addImage,
            borderRadius: BorderRadius.circular(12.r(context)),
            child: Container(
              width: 82.w(context),
              height: 74.w(context),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(12.r(context)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    SolarIconsOutline.addCircle,
                    color: AppColors.primaryColor,
                    size: 25.r(context),
                  ),
                  Text(
                    'إضافة ملف',
                    style: TextStyles.cairoRegular14Muted(context).copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 10.sp(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _permissionMessage(BuildContext context, MissionDetails mission) {
    final message = mission.canCheckIn
        ? 'سجّل حضورك في موقع المهمة أولاً لإرسال التقرير.'
        : 'إرسال التقرير سيتاح بعد استيفاء متطلبات الحضور وتنفيذ المهمة.';
    return Container(
      padding: context.responsivePadding(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.lightGreenishWhite,
        borderRadius: BorderRadius.circular(12.r(context)),
      ),
      child: Row(
        children: [
          Icon(
            SolarIconsOutline.mapPoint,
            color: AppColors.primaryColor,
            size: 18.r(context),
          ),
          SizedBox(width: 7.w(context)),
          Expanded(
            child: Text(
              message,
              style: TextStyles.cairoRegular14Muted(
                context,
              ).copyWith(color: AppColors.dark, fontSize: 11.sp(context)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomAction(
    BuildContext context,
    MissionDetails mission,
    MissionDetailsState state,
  ) {
    if (mission.hasSubmittedReport || state.reportSubmitted) {
      return const SizedBox(height: 8);
    }

    final canCheckIn = mission.canCheckIn;
    final canSubmit = mission.canSubmitReport;
    final busy = state.isCheckingIn || state.isSubmitting || _isGettingLocation;
    final enabled =
        !busy &&
        (canCheckIn || (canSubmit && _notesController.text.trim().isNotEmpty));

    return SafeArea(
      top: false,
      child: Padding(
        padding: context.responsivePadding(horizontal: 18, top: 8, bottom: 10),
        child: SizedBox(
          width: double.infinity,
          height: 54.h(context),
          child: ElevatedButton.icon(
            onPressed: !enabled
                ? null
                : canCheckIn
                ? _checkIn
                : _submitReport,
            icon: busy
                ? SizedBox(
                    width: 19.r(context),
                    height: 19.r(context),
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(
                    canCheckIn
                        ? SolarIconsOutline.mapPoint
                        : SolarIconsOutline.plain,
                    size: 21.r(context),
                  ),
            label: Text(
              busy
                  ? 'جارٍ التنفيذ...'
                  : canCheckIn
                  ? 'تسجيل الحضور للمهمة'
                  : canSubmit
                  ? 'إرسال التقرير وإنهاء المهمة'
                  : 'إكمال متطلبات المهمة أولاً',
              style: TextStyles.cairoBold32Dark(
                context,
              ).copyWith(color: Colors.white, fontSize: 14.sp(context)),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              disabledBackgroundColor: AppColors.primaryColor.withValues(
                alpha: 0.4,
              ),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r(context)),
              ),
              elevation: 3,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addImage() async {
    if (_images.length >= 5) return;
    try {
      final file = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 82,
      );
      if (file == null || !mounted) return;
      final bytes = await file.readAsBytes();
      final mimeType = file.mimeType ?? _mimeType(file.name);
      setState(() {
        _images.add(
          _MissionImage(
            bytes: bytes,
            dataUri: 'data:$mimeType;base64,${base64Encode(bytes)}',
          ),
        );
      });
    } on PlatformException catch (error) {
      if (mounted) _showMessage(error.message ?? 'تعذر فتح معرض الصور');
    }
  }

  String _mimeType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    return switch (extension) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      'gif' => 'image/gif',
      _ => 'image/jpeg',
    };
  }

  Future<void> _checkIn() async {
    final cubit = context.read<MissionCubit>();
    setState(() => _isGettingLocation = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        _showMessage('فعّل خدمة الموقع لتسجيل الحضور');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showMessage('اسمح للتطبيق بالوصول إلى موقعك لتسجيل الحضور');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      if (!mounted) return;
      await cubit.checkIn(
        missionId: widget.missionId,
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (error) {
      if (mounted) _showMessage('تعذر تحديد موقعك: $error');
    } finally {
      if (mounted) setState(() => _isGettingLocation = false);
    }
  }

  Future<void> _submitReport() async {
    final cubit = context.read<MissionCubit>();
    final notes = _notesController.text.trim();
    if (notes.isEmpty) {
      _showMessage('اكتب تقريرك قبل الإرسال');
      return;
    }
    await cubit.submitReport(
      missionId: widget.missionId,
      notes: notes,
      imageDataUris: _images.map((image) => image.dataUri).toList(),
      rating: _rating,
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _dateLabel(String value) {
    final date = DateTime.tryParse(value);
    if (date == null) return value;
    const months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }
}

class _MissionImage {
  final Uint8List bytes;
  final String dataUri;

  const _MissionImage({required this.bytes, required this.dataUri});
}
