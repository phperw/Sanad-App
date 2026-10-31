// // ignore_for_file: use_null_aware_elements

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:sanad/core/theme/app_colors.dart';
// import 'package:sanad/core/theme/text_styles.dart';
// import 'package:sanad/core/helper/responsive_extensions.dart';
// import 'package:sanad/core/helper/spacing.dart';
// import 'package:sanad/core/routing/router.dart';

// class SosActiveScreen extends StatelessWidget {
//   const SosActiveScreen({super.key});

//   static const _adminPhone = '16878';

//   Future<void> _callAdmin() async {
//     final uri = Uri(scheme: 'tel', path: _adminPhone);
//     if (await canLaunchUrl(uri)) await launchUrl(uri);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final cardColor = isDark
//         ? const Color(0xFF1E1E1E)
//         : const Color(0xFFF9F9F9);
//     final subtitleColor = const Color(0xFFA0A0A0);

//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       body: Stack(
//         children: [
//           _BackgroundPattern(),
//           Column(
//             children: [
//               _Header(),
//               Expanded(
//                 child: Directionality(
//                   textDirection: TextDirection.rtl,
//                   child: SingleChildScrollView(
//                     padding: context.responsivePadding(
//                       horizontal: 16,
//                       bottom: 24,
//                     ),
//                     child: Directionality(
//                       textDirection: TextDirection.rtl,

//                       child: Column(
//                         children: [
//                           verticalSpace(context, height: 20),
//                           _StatusCard(
//                             cardColor: cardColor,
//                             borderColor: const Color(0xFFE74C3C),
//                             icon: Icons.location_on_rounded,
//                             iconBgColor: const Color(
//                               0xFFE74C3C,
//                             ).withOpacity(0.5),
//                             iconColor: Colors.white,
//                             title: 'موقعك يُشارك الآن',
//                             subtitle: 'الإدارة تتابع موقعك في الوقت الفعلي',
//                             badge: _LiveBadge(),
//                           ),
//                           verticalSpace(context, height: 12),
//                           _StatusCard(
//                             cardColor: cardColor,
//                             borderColor: AppColors.chatChipBorder,
//                             icon: Icons.notifications_rounded,
//                             iconBgColor: AppColors.chatChipBorder.withOpacity(
//                               0.1,
//                             ),
//                             iconColor: AppColors.chatChipBorder,
//                             title: 'تم إبلاغ الإدارة',
//                             subtitle: 'وتم إشعار المتطوعين القريبين منك',
//                             trailing: Text(
//                               'منذ ثوانٍ',
//                               style: TextStyles.cairoRegular10Gray(context)
//                                   .copyWith(
//                                     color: subtitleColor,
//                                     fontSize: 11.sp(context),
//                                   ),
//                             ),
//                           ),
//                           verticalSpace(context, height: 16),
//                           _CallCard(cardColor: cardColor, onCall: _callAdmin),
//                           verticalSpace(context, height: 24),
//                           _CancelButton(cardColor: cardColor),
//                           verticalSpace(context, height: 8),
//                           Text(
//                             'سيتم إيقاف مشاركة موقعك',
//                             textAlign: TextAlign.center,
//                             style: TextStyles.cairoRegular10Gray(context)
//                                 .copyWith(
//                                   color: subtitleColor,
//                                   fontSize: 10.sp(context),
//                                 ),
//                           ),
//                           verticalSpace(context, height: 8),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _Header extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: ShapeDecoration(
//         color: AppColors.sosRed,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(24),
//             bottomRight: Radius.circular(24),
//           ),
//         ),
//       ),
//       child: SafeArea(
//         bottom: false,
//         child: Directionality(
//           textDirection: TextDirection.rtl,
//           child: Padding(
//             padding: context.responsivePadding(
//               horizontal: 20,
//               top: 16,
//               bottom: 20,
//             ),
//             child: Column(
//               children: [
//                 Text(
//                   'طلب الطوارئ نشط',
//                   textAlign: TextAlign.center,
//                   style: TextStyles.cairoBold20Dark(
//                     context,
//                   ).copyWith(color: Colors.white, fontSize: 20.sp(context)),
//                 ),
//                 verticalSpace(context, height: 4),
//                 Text(
//                   'تم إبلاغ الإدارة — المساعدة في الطريق',
//                   textAlign: TextAlign.center,
//                   style: TextStyles.cairoRegular10Gray(context).copyWith(
//                     color: Colors.white.withOpacity(0.9),
//                     fontSize: 13.sp(context),
//                     height: 1.5,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _StatusCard extends StatelessWidget {
//   final Color cardColor;
//   final Color borderColor;
//   final IconData icon;
//   final Color iconBgColor;
//   final Color iconColor;
//   final String title;
//   final String subtitle;
//   final Widget? badge;
//   final Widget? trailing;

//   const _StatusCard({
//     required this.cardColor,
//     required this.borderColor,
//     required this.icon,
//     required this.iconBgColor,
//     required this.iconColor,
//     required this.title,
//     required this.subtitle,
//     this.badge,
//     this.trailing,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final titleColor = isDark ? Colors.white : AppColors.darkBlue;

//     return Container(
//       width: double.infinity,
//       padding: context.responsivePadding(horizontal: 16, vertical: 16),
//       decoration: ShapeDecoration(
//         color: cardColor,
//         shape: RoundedRectangleBorder(
//           side: BorderSide(width: 3, color: borderColor),
//           borderRadius: BorderRadius.circular(12.r(context)),
//         ),
//         shadows: const [
//           BoxShadow(
//             color: Color(0x26000000),
//             blurRadius: 4,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     if (badge != null) badge!,
//                     if (trailing != null) trailing!,
//                     Text(
//                       title,
//                       style: TextStyles.cairoBold16DarkBlue(
//                         context,
//                       ).copyWith(color: titleColor, fontSize: 16.sp(context)),
//                     ),
//                   ],
//                 ),
//                 verticalSpace(context, height: 2),
//                 Text(
//                   subtitle,
//                   style: TextStyles.cairoRegular10Gray(context).copyWith(
//                     color: const Color(0xFFA0A0A0),
//                     fontSize: 13.sp(context),
//                     height: 1.5,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           horizontalSpace(context, width: 12),
//           Container(
//             width: 48.w(context),
//             height: 48.w(context),
//             decoration: BoxDecoration(
//               color: iconBgColor,
//               borderRadius: BorderRadius.circular(14.r(context)),
//             ),
//             child: Icon(icon, color: iconColor, size: 24.sp(context)),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _LiveBadge extends StatefulWidget {
//   @override
//   State<_LiveBadge> createState() => _LiveBadgeState();
// }

// class _LiveBadgeState extends State<_LiveBadge>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//   late Animation<double> _fade;

//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     )..repeat(reverse: true);
//     _fade = Tween<double>(begin: 0.4, end: 1.0).animate(_ctrl);
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: 10.w(context),
//         vertical: 4.h(context),
//       ),
//       decoration: BoxDecoration(
//         color: const Color(0xFF2ECC71),
//         borderRadius: BorderRadius.circular(100),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             'مباشر',
//             style: TextStyles.cairoSemiBold12White(
//               context,
//             ).copyWith(fontSize: 11.sp(context), height: 1.5),
//           ),
//           horizontalSpace(context, width: 4),
//           FadeTransition(
//             opacity: _fade,
//             child: Container(
//               width: 6.w(context),
//               height: 6.w(context),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _CallCard extends StatelessWidget {
//   final Color cardColor;
//   final VoidCallback onCall;

//   const _CallCard({required this.cardColor, required this.onCall});

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final titleColor = isDark ? Colors.white : AppColors.darkBlue;

//     return GestureDetector(
//       onTap: onCall,
//       child: Container(
//         width: double.infinity,
//         padding: context.responsivePadding(vertical: 24),
//         decoration: ShapeDecoration(
//           color: cardColor,
//           shape: RoundedRectangleBorder(
//             side: BorderSide(width: 2, color: AppColors.chatChipBorder),
//             borderRadius: BorderRadius.circular(16.r(context)),
//           ),
//         ),
//         child: Column(
//           children: [
//             Container(
//               width: 56.w(context),
//               height: 56.w(context),
//               decoration: const BoxDecoration(
//                 color: AppColors.chatChipBorder,
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.phone_rounded,
//                 color: Colors.white,
//                 size: 28.sp(context),
//               ),
//             ),
//             verticalSpace(context, height: 12),
//             Text(
//               'تواصل مباشر مع الإدارة',
//               textAlign: TextAlign.center,
//               style: TextStyles.cairoBold16DarkBlue(
//                 context,
//               ).copyWith(color: titleColor, fontSize: 16.sp(context)),
//             ),
//             verticalSpace(context, height: 8),
//             Text(
//               '16878',
//               textAlign: TextAlign.center,
//               style: TextStyles.cairoBold24Primary(context).copyWith(
//                 color: AppColors.chatChipBorder,
//                 fontSize: 32.sp(context),
//                 fontWeight: FontWeight.w800,
//                 letterSpacing: 1,
//               ),
//             ),
//             verticalSpace(context, height: 4),
//             Text(
//               'اضغط للاتصال',
//               textAlign: TextAlign.center,
//               style: TextStyles.cairoRegular10Gray(context).copyWith(
//                 color: const Color(0xFFA0A0A0),
//                 fontSize: 12.sp(context),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _CancelButton extends StatelessWidget {
//   final Color cardColor;

//   const _CancelButton({required this.cardColor});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => context.go(AppRouter.kSosSuccess),
//       child: Container(
//         width: double.infinity,
//         height: 60.h(context),
//         decoration: ShapeDecoration(
//           color: cardColor,
//           shape: RoundedRectangleBorder(
//             side: BorderSide(width: 1, color: AppColors.chatChipBorder),
//             borderRadius: BorderRadius.circular(12.r(context)),
//           ),
//           shadows: const [
//             BoxShadow(
//               color: Color(0x26000000),
//               blurRadius: 4,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Center(
//           child: Text(
//             'أنا بخير — إلغاء الطوارئ',
//             textAlign: TextAlign.center,
//             style: TextStyles.cairoBold16DarkBlue(context).copyWith(
//               color: AppColors.chatChipBorder,
//               fontSize: 18.sp(context),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _BackgroundPattern extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final ringColor = isDark
//         ? AppColors.chatChipBorder.withOpacity(0.05)
//         : AppColors.chatChipBorder.withOpacity(0.06);

//     return Positioned(
//       bottom: -100,
//       right: -100,
//       child: CustomPaint(
//         size: Size(400.w(context), 400.w(context)),
//         painter: _RingsPainter(color: ringColor),
//       ),
//     );
//   }
// }

// class _RingsPainter extends CustomPainter {
//   final Color color;
//   _RingsPainter({required this.color});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.5;

//     final center = Offset(size.width / 2, size.height / 2);
//     for (var i = 1; i <= 5; i++) {
//       canvas.drawCircle(center, size.width * 0.12 * i, paint);
//     }
//   }

//   @override
//   bool shouldRepaint(_RingsPainter old) => old.color != color;
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sanad/features/home/view/widget/sos_bloc_listener.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:sanad/core/theme/app_colors.dart';
// import 'package:sanad/core/theme/text_styles.dart';
// import 'package:sanad/core/helper/responsive_extensions.dart';
// import 'package:sanad/core/helper/spacing.dart';

// import '../../logic/OSO_Cubit/sos_cubit.dart';

// class SosActiveScreen extends StatelessWidget {
//   const SosActiveScreen({super.key});

//   static const _adminPhone = '16878';

//   Future<void> _callAdmin() async {
//     final uri = Uri(scheme: 'tel', path: _adminPhone);
//     if (await canLaunchUrl(uri)) await launchUrl(uri);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final cardColor =
//         isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF9F9F9);
//     final subtitleColor = const Color(0xFFA0A0A0);

//     return SosBlocListener(
//       child: Scaffold(
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         body: Stack(
//           children: [
//             _BackgroundPattern(),
//             Column(
//               children: [
//                 _Header(),
//                 Expanded(
//                   child: Directionality(
//                     textDirection: TextDirection.rtl,
//                     child: SingleChildScrollView(
//                       padding: context.responsivePadding(
//                         horizontal: 16,
//                         bottom: 24,
//                       ),
//                       child: Column(
//                         children: [
//                           verticalSpace(context, height: 20),
//                           _StatusCard(
//                             cardColor: cardColor,
//                             borderColor: const Color(0xFFE74C3C),
//                             icon: Icons.location_on_rounded,
//                             iconBgColor:
//                                 const Color(0xFFE74C3C).withOpacity(0.5),
//                             iconColor: Colors.white,
//                             title: 'موقعك يُشارك الآن',
//                             subtitle:
//                                 'الإدارة تتابع موقعك في الوقت الفعلي',
//                             badge: _LiveBadge(),
//                           ),
//                           verticalSpace(context, height: 12),
//                           _StatusCard(
//                             cardColor: cardColor,
//                             borderColor: AppColors.chatChipBorder,
//                             icon: Icons.notifications_rounded,
//                             iconBgColor:
//                                 AppColors.chatChipBorder.withOpacity(0.1),
//                             iconColor: AppColors.chatChipBorder,
//                             title: 'تم إبلاغ الإدارة',
//                             subtitle: 'وتم إشعار المتطوعين القريبين منك',
//                             trailing: Text(
//                               'منذ ثوانٍ',
//                               style: TextStyles.cairoRegular10Gray(context)
//                                   .copyWith(
//                                 color: subtitleColor,
//                                 fontSize: 11.sp(context),
//                               ),
//                             ),
//                           ),
//                           verticalSpace(context, height: 16),
//                           _CallCard(
//                             cardColor: cardColor,
//                             onCall: _callAdmin,
//                           ),
//                           verticalSpace(context, height: 24),
//                           BlocBuilder<SosCubit, SosState>(
//                             builder: (context, state) {
//                               final isLoading = state is SosCancelLoading;
//                               return _CancelButton(
//                                 cardColor: cardColor,
//                                 isLoading: isLoading,
//                                 onTap: isLoading
//                                     ? null
//                                     : () =>
//                                         context.read<SosCubit>().cancelSos(),
//                               );
//                             },
//                           ),
//                           verticalSpace(context, height: 8),
//                           Text(
//                             'سيتم إيقاف مشاركة موقعك',
//                             textAlign: TextAlign.center,
//                             style: TextStyles.cairoRegular10Gray(context)
//                                 .copyWith(
//                               color: subtitleColor,
//                               fontSize: 10.sp(context),
//                             ),
//                           ),
//                           verticalSpace(context, height: 8),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _Header extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: ShapeDecoration(
//         color: AppColors.sosRed,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(24),
//             bottomRight: Radius.circular(24),
//           ),
//         ),
//       ),
//       child: SafeArea(
//         bottom: false,
//         child: Directionality(
//           textDirection: TextDirection.rtl,
//           child: Padding(
//             padding: context.responsivePadding(
//               horizontal: 20,
//               top: 16,
//               bottom: 20,
//             ),
//             child: Column(
//               children: [
//                 Text(
//                   'طلب الطوارئ نشط',
//                   textAlign: TextAlign.center,
//                   style: TextStyles.cairoBold20Dark(context).copyWith(
//                     color: Colors.white,
//                     fontSize: 20.sp(context),
//                   ),
//                 ),
//                 verticalSpace(context, height: 4),
//                 Text(
//                   'تم إبلاغ الإدارة — المساعدة في الطريق',
//                   textAlign: TextAlign.center,
//                   style: TextStyles.cairoRegular10Gray(context).copyWith(
//                     color: Colors.white.withOpacity(0.9),
//                     fontSize: 13.sp(context),
//                     height: 1.5,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _StatusCard extends StatelessWidget {
//   final Color cardColor;
//   final Color borderColor;
//   final IconData icon;
//   final Color iconBgColor;
//   final Color iconColor;
//   final String title;
//   final String subtitle;
//   final Widget? badge;
//   final Widget? trailing;

//   const _StatusCard({
//     required this.cardColor,
//     required this.borderColor,
//     required this.icon,
//     required this.iconBgColor,
//     required this.iconColor,
//     required this.title,
//     required this.subtitle,
//     this.badge,
//     this.trailing,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final titleColor = isDark ? Colors.white : AppColors.darkBlue;

//     return Container(
//       width: double.infinity,
//       padding: context.responsivePadding(horizontal: 16, vertical: 16),
//       decoration: ShapeDecoration(
//         color: cardColor,
//         shape: RoundedRectangleBorder(
//           side: BorderSide(width: 3, color: borderColor),
//           borderRadius: BorderRadius.circular(12.r(context)),
//         ),
//         shadows: const [
//           BoxShadow(
//             color: Color(0x26000000),
//             blurRadius: 4,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     if (badge != null) badge!,
//                     if (trailing != null) trailing!,
//                     Text(
//                       title,
//                       style:
//                           TextStyles.cairoBold16DarkBlue(context).copyWith(
//                         color: titleColor,
//                         fontSize: 16.sp(context),
//                       ),
//                     ),
//                   ],
//                 ),
//                 verticalSpace(context, height: 2),
//                 Text(
//                   subtitle,
//                   style: TextStyles.cairoRegular10Gray(context).copyWith(
//                     color: const Color(0xFFA0A0A0),
//                     fontSize: 13.sp(context),
//                     height: 1.5,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           horizontalSpace(context, width: 12),
//           Container(
//             width: 48.w(context),
//             height: 48.w(context),
//             decoration: BoxDecoration(
//               color: iconBgColor,
//               borderRadius: BorderRadius.circular(14.r(context)),
//             ),
//             child: Icon(icon, color: iconColor, size: 24.sp(context)),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _LiveBadge extends StatefulWidget {
//   @override
//   State<_LiveBadge> createState() => _LiveBadgeState();
// }

// class _LiveBadgeState extends State<_LiveBadge>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//   late Animation<double> _fade;

//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     )..repeat(reverse: true);
//     _fade = Tween<double>(begin: 0.4, end: 1.0).animate(_ctrl);
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: 10.w(context),
//         vertical: 4.h(context),
//       ),
//       decoration: BoxDecoration(
//         color: const Color(0xFF2ECC71),
//         borderRadius: BorderRadius.circular(100),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             'مباشر',
//             style: TextStyles.cairoSemiBold12White(context).copyWith(
//               fontSize: 11.sp(context),
//               height: 1.5,
//             ),
//           ),
//           horizontalSpace(context, width: 4),
//           FadeTransition(
//             opacity: _fade,
//             child: Container(
//               width: 6.w(context),
//               height: 6.w(context),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _CallCard extends StatelessWidget {
//   final Color cardColor;
//   final VoidCallback onCall;

//   const _CallCard({required this.cardColor, required this.onCall});

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final titleColor = isDark ? Colors.white : AppColors.darkBlue;

//     return GestureDetector(
//       onTap: onCall,
//       child: Container(
//         width: double.infinity,
//         padding: context.responsivePadding(vertical: 24),
//         decoration: ShapeDecoration(
//           color: cardColor,
//           shape: RoundedRectangleBorder(
//             side: BorderSide(
//               width: 2,
//               color: AppColors.chatChipBorder,
//             ),
//             borderRadius: BorderRadius.circular(16.r(context)),
//           ),
//         ),
//         child: Column(
//           children: [
//             Container(
//               width: 56.w(context),
//               height: 56.w(context),
//               decoration: const BoxDecoration(
//                 color: AppColors.chatChipBorder,
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.phone_rounded,
//                 color: Colors.white,
//                 size: 28.sp(context),
//               ),
//             ),
//             verticalSpace(context, height: 12),
//             Text(
//               'تواصل مباشر مع الإدارة',
//               textAlign: TextAlign.center,
//               style: TextStyles.cairoBold16DarkBlue(context).copyWith(
//                 color: titleColor,
//                 fontSize: 16.sp(context),
//               ),
//             ),
//             verticalSpace(context, height: 8),
//             Text(
//               '16878',
//               textAlign: TextAlign.center,
//               style: TextStyles.cairoBold24Primary(context).copyWith(
//                 color: AppColors.chatChipBorder,
//                 fontSize: 32.sp(context),
//                 fontWeight: FontWeight.w800,
//                 letterSpacing: 1,
//               ),
//             ),
//             verticalSpace(context, height: 4),
//             Text(
//               'اضغط للاتصال',
//               textAlign: TextAlign.center,
//               style: TextStyles.cairoRegular10Gray(context).copyWith(
//                 color: const Color(0xFFA0A0A0),
//                 fontSize: 12.sp(context),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _CancelButton extends StatelessWidget {
//   final Color cardColor;
//   final bool isLoading;
//   final VoidCallback? onTap;

//   const _CancelButton({
//     required this.cardColor,
//     required this.isLoading,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         height: 60.h(context),
//         decoration: ShapeDecoration(
//           color: cardColor,
//           shape: RoundedRectangleBorder(
//             side: BorderSide(width: 1, color: AppColors.chatChipBorder),
//             borderRadius: BorderRadius.circular(12.r(context)),
//           ),
//           shadows: const [
//             BoxShadow(
//               color: Color(0x26000000),
//               blurRadius: 4,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Center(
//           child: isLoading
//               ? const CircularProgressIndicator()
//               : Text(
//                   'أنا بخير — إلغاء الطوارئ',
//                   textAlign: TextAlign.center,
//                   style: TextStyles.cairoBold16DarkBlue(context).copyWith(
//                     color: AppColors.chatChipBorder,
//                     fontSize: 18.sp(context),
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
// }

// class _BackgroundPattern extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final ringColor = isDark
//         ? AppColors.chatChipBorder.withOpacity(0.05)
//         : AppColors.chatChipBorder.withOpacity(0.06);

//     return Positioned(
//       bottom: -100,
//       right: -100,
//       child: CustomPaint(
//         size: Size(400.w(context), 400.w(context)),
//         painter: _RingsPainter(color: ringColor),
//       ),
//     );
//   }
// }

// class _RingsPainter extends CustomPainter {
//   final Color color;
//   _RingsPainter({required this.color});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.5;

//     final center = Offset(size.width / 2, size.height / 2);
//     for (var i = 1; i <= 5; i++) {
//       canvas.drawCircle(center, size.width * 0.12 * i, paint);
//     }
//   }

//   @override
//   bool shouldRepaint(_RingsPainter old) => old.color != color;
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad/features/home/view/widget/sos_bloc_listener.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/networking/dio_factory.dart';
import '../../data/OSO_api_service/sos_api_service.dart';
import '../../data/repo/OSO/sos_repository.dart';
import '../../logic/OSO_Cubit/sos_cubit.dart';

class SosActiveScreen extends StatelessWidget {
  const SosActiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SosCubit(
        SosRepository(SosApiService(DioFactory.getDio())),
      ),
      child: const _SosActiveScreenContent(),
    );
  }
}

class _SosActiveScreenContent extends StatelessWidget {
  const _SosActiveScreenContent();

  static const _adminPhone = '16878';

  Future<void> _callAdmin() async {
    final uri = Uri(scheme: 'tel', path: _adminPhone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor =
        isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF9F9F9);
    final subtitleColor = const Color(0xFFA0A0A0);

    return SosBlocListener(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            _BackgroundPattern(),
            Column(
              children: [
                _Header(),
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: SingleChildScrollView(
                      padding: context.responsivePadding(
                        horizontal: 16,
                        bottom: 24,
                      ),
                      child: Column(
                        children: [
                          verticalSpace(context, height: 20),
                          _StatusCard(
                            cardColor: cardColor,
                            borderColor: const Color(0xFFE74C3C),
                            icon: Icons.location_on_rounded,
                            iconBgColor:
                                const Color(0xFFE74C3C).withOpacity(0.5),
                            iconColor: Colors.white,
                            title: 'موقعك يُشارك الآن',
                            subtitle:
                                'الإدارة تتابع موقعك في الوقت الفعلي',
                            badge: _LiveBadge(),
                          ),
                          verticalSpace(context, height: 12),
                          _StatusCard(
                            cardColor: cardColor,
                            borderColor: AppColors.chatChipBorder,
                            icon: Icons.notifications_rounded,
                            iconBgColor:
                                AppColors.chatChipBorder.withOpacity(0.1),
                            iconColor: AppColors.chatChipBorder,
                            title: 'تم إبلاغ الإدارة',
                            subtitle: 'وتم إشعار المتطوعين القريبين منك',
                            trailing: Text(
                              'منذ ثوانٍ',
                              style: TextStyles.cairoRegular10Gray(context)
                                  .copyWith(
                                color: subtitleColor,
                                fontSize: 11.sp(context),
                              ),
                            ),
                          ),
                          verticalSpace(context, height: 16),
                          _CallCard(
                            cardColor: cardColor,
                            onCall: _callAdmin,
                          ),
                          verticalSpace(context, height: 24),
                          BlocBuilder<SosCubit, SosState>(
                            builder: (context, state) {
                              final isLoading = state is SosCancelLoading;
                              return _CancelButton(
                                cardColor: cardColor,
                                isLoading: isLoading,
                                onTap: isLoading
                                    ? null
                                    : () =>
                                        context.read<SosCubit>().cancelSos(),
                              );
                            },
                          ),
                          verticalSpace(context, height: 8),
                          Text(
                            'سيتم إيقاف مشاركة موقعك',
                            textAlign: TextAlign.center,
                            style: TextStyles.cairoRegular10Gray(context)
                                .copyWith(
                              color: subtitleColor,
                              fontSize: 10.sp(context),
                            ),
                          ),
                          verticalSpace(context, height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        color: AppColors.sosRed,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: context.responsivePadding(
              horizontal: 20,
              top: 16,
              bottom: 20,
            ),
            child: Column(
              children: [
                Text(
                  'طلب الطوارئ نشط',
                  textAlign: TextAlign.center,
                  style: TextStyles.cairoBold20Dark(context).copyWith(
                    color: Colors.white,
                    fontSize: 20.sp(context),
                  ),
                ),
                verticalSpace(context, height: 4),
                Text(
                  'تم إبلاغ الإدارة — المساعدة في الطريق',
                  textAlign: TextAlign.center,
                  style: TextStyles.cairoRegular10Gray(context).copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13.sp(context),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final Color cardColor;
  final Color borderColor;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? badge;
  final Widget? trailing;

  const _StatusCard({
    required this.cardColor,
    required this.borderColor,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.badge,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : AppColors.darkBlue;

    return Container(
      width: double.infinity,
      padding: context.responsivePadding(horizontal: 16, vertical: 16),
      decoration: ShapeDecoration(
        color: cardColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 3, color: borderColor),
          borderRadius: BorderRadius.circular(12.r(context)),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ignore: use_null_aware_elements
                    if (badge != null) badge!,
                    // ignore: use_null_aware_elements
                    if (trailing != null) trailing!,
                    Text(
                      title,
                      style:
                          TextStyles.cairoBold16DarkBlue(context).copyWith(
                        color: titleColor,
                        fontSize: 16.sp(context),
                      ),
                    ),
                  ],
                ),
                verticalSpace(context, height: 2),
                Text(
                  subtitle,
                  style: TextStyles.cairoRegular10Gray(context).copyWith(
                    color: const Color(0xFFA0A0A0),
                    fontSize: 13.sp(context),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          horizontalSpace(context, width: 12),
          Container(
            width: 48.w(context),
            height: 48.w(context),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(14.r(context)),
            ),
            child: Icon(icon, color: iconColor, size: 24.sp(context)),
          ),
        ],
      ),
    );
  }
}

class _LiveBadge extends StatefulWidget {
  @override
  State<_LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<_LiveBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _fade = Tween<double>(begin: 0.4, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w(context),
        vertical: 4.h(context),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF2ECC71),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'مباشر',
            style: TextStyles.cairoSemiBold12White(context).copyWith(
              fontSize: 11.sp(context),
              height: 1.5,
            ),
          ),
          horizontalSpace(context, width: 4),
          FadeTransition(
            opacity: _fade,
            child: Container(
              width: 6.w(context),
              height: 6.w(context),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CallCard extends StatelessWidget {
  final Color cardColor;
  final VoidCallback onCall;

  const _CallCard({required this.cardColor, required this.onCall});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : AppColors.darkBlue;

    return GestureDetector(
      onTap: onCall,
      child: Container(
        width: double.infinity,
        padding: context.responsivePadding(vertical: 24),
        decoration: ShapeDecoration(
          color: cardColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 2,
              color: AppColors.chatChipBorder,
            ),
            borderRadius: BorderRadius.circular(16.r(context)),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 56.w(context),
              height: 56.w(context),
              decoration: const BoxDecoration(
                color: AppColors.chatChipBorder,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.phone_rounded,
                color: Colors.white,
                size: 28.sp(context),
              ),
            ),
            verticalSpace(context, height: 12),
            Text(
              'تواصل مباشر مع الإدارة',
              textAlign: TextAlign.center,
              style: TextStyles.cairoBold16DarkBlue(context).copyWith(
                color: titleColor,
                fontSize: 16.sp(context),
              ),
            ),
            verticalSpace(context, height: 8),
            Text(
              '16878',
              textAlign: TextAlign.center,
              style: TextStyles.cairoBold24Primary(context).copyWith(
                color: AppColors.chatChipBorder,
                fontSize: 32.sp(context),
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
            verticalSpace(context, height: 4),
            Text(
              'اضغط للاتصال',
              textAlign: TextAlign.center,
              style: TextStyles.cairoRegular10Gray(context).copyWith(
                color: const Color(0xFFA0A0A0),
                fontSize: 12.sp(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  final Color cardColor;
  final bool isLoading;
  final VoidCallback? onTap;

  const _CancelButton({
    required this.cardColor,
    required this.isLoading,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60.h(context),
        decoration: ShapeDecoration(
          color: cardColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: AppColors.chatChipBorder),
            borderRadius: BorderRadius.circular(12.r(context)),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : Text(
                  'أنا بخير — إلغاء الطوارئ',
                  textAlign: TextAlign.center,
                  style: TextStyles.cairoBold16DarkBlue(context).copyWith(
                    color: AppColors.chatChipBorder,
                    fontSize: 18.sp(context),
                  ),
                ),
        ),
      ),
    );
  }
}

class _BackgroundPattern extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ringColor = isDark
        ? AppColors.chatChipBorder.withOpacity(0.05)
        : AppColors.chatChipBorder.withOpacity(0.06);

    return Positioned(
      bottom: -100,
      right: -100,
      child: CustomPaint(
        size: Size(400.w(context), 400.w(context)),
        painter: _RingsPainter(color: ringColor),
      ),
    );
  }
}

class _RingsPainter extends CustomPainter {
  final Color color;
  _RingsPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final center = Offset(size.width / 2, size.height / 2);
    for (var i = 1; i <= 5; i++) {
      canvas.drawCircle(center, size.width * 0.12 * i, paint);
    }
  }

  @override
  bool shouldRepaint(_RingsPainter old) => old.color != color;
}