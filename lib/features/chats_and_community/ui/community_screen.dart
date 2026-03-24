import 'package:flutter/material.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/helper/responsive_extensions.dart';
import '../../../core/helper/spacing.dart';
import '../data/post_data.dart';
import 'animations/community_animations.dart';
import 'widget_community/add_post_button.dart';
import 'widget_community/announcement_card.dart';
import 'widget_community/community_post_card.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  static const List<PostData> _posts = [
    PostData(
      userName: 'مصطفى محمود',
      timeAgo: 'منذ 3 ساعات',
      postText:
          'حملة النهارده في المعادي كانت رائعة! وصلنا لأكتر من 200 أسرة 💪 فخور إني جزء من فريق سند 🌿',
      avatarUrl: 'https://avatars.githubusercontent.com/u/189971801?v=4',
      imageUrl: Assets.campaignPhoto,
      likesCount: 24,
      commentsCount: 8,
    ),
    PostData(
      userName: 'هاجر',
      timeAgo: 'منذ 5 ساعات',
      postText:
          'أول حملة ليا مع سند وكانت تجربة مش هنساها ❤️ شكراً للفريق على الترحيب الجميل',
      avatarUrl: 'https://avatars.githubusercontent.com/u/148388900?v=4',
      likesCount: 12,
      commentsCount: 3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.separated(
          padding: context.responsivePadding(vertical: 16),
          itemCount: _posts.length + 2,
          // ignore: unnecessary_underscores
          separatorBuilder: (_, __) => verticalSpace(context, height: 12),
          itemBuilder: (context, index) {
            if (index == 0) {
              return FadeSlideIn(
                delay: const Duration(milliseconds: 100),
                child: const AnnouncementCard(
                  title: 'إعلان من الإدارة',
                  body: 'موعد حملة الجيزة الكبرى تغير إلى الجمعة 20 مارس',
                  timeAgo: 'منذ ساعتين',
                ),
              );
            }

            if (index == _posts.length + 1) {
              return verticalSpace(context, height: 72);
            }

            final post = _posts[index - 1];
            return FadeSlideIn(
              delay: Duration(milliseconds: 200 + (index * 100)),
              child: CommunityPostCard(
                userName: post.userName,
                timeAgo: post.timeAgo,
                postText: post.postText,
                avatarUrl: post.avatarUrl,
                imageUrl: post.imageUrl,
                likesCount: post.likesCount,
                commentsCount: post.commentsCount,
                onLike: () {},
                onComment: () {},
                onShare: () {},
              ),
            );
          },
        ),
        Positioned(
          bottom: 16.h(context),
          left: 16.w(context),
          child: ScaleBounce(
            delay: const Duration(milliseconds: 400),
            child: AddPostButton(
              onTap: () {
                // ignore: avoid_print
                print("Navigate to Add Post Screen");
              },
            ),
          ),
        ),
      ],
    );
  }
}
