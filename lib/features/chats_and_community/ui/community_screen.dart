import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/helper/responsive_extensions.dart';
import '../../../core/helper/shared_pref_helper.dart';
import '../../../core/helper/shared_pref_keys.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../data/models/post/community_feed_response.dart';
import '../logic/community/community_feed_cubit.dart';
import '../logic/community/community_feed_state.dart';
import 'animations/community_animations.dart';
import 'widget_community/add_post_button.dart';
import 'widget_community/add_post_sheet.dart';
import 'widget_community/announcement_card.dart';
import 'widget_community/community_post_card.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  late ScrollController _scrollController;
  late CommunityFeedCubit _feedCubit;

  @override
  void initState() {
    super.initState();
    _feedCubit = getIt<CommunityFeedCubit>()..getFeed(isRefresh: true);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      _feedCubit.getFeed();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _feedCubit.close();
    super.dispose();
  }

  String _getTimeAgo(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      Duration diff = DateTime.now().difference(date);
      if (diff.inDays > 0) return 'منذ ${diff.inDays} أيام';
      if (diff.inHours > 0) return 'منذ ${diff.inHours} ساعات';
      if (diff.inMinutes > 0) return 'منذ ${diff.inMinutes} دقائق';
      return 'الآن';
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _feedCubit,
      child: Stack(
        children: [
          RefreshIndicator(
            color: AppColors.primaryColor,
            onRefresh: () async {
              await _feedCubit.getFeed(isRefresh: true);
            },
            child: BlocBuilder<CommunityFeedCubit, CommunityFeedState>(
              builder: (context, state) {
                bool isLoading = state is CommunityFeedLoading;
                List<PostModel> posts = [];
                bool isFetchingMore = false;

                if (state is CommunityFeedSuccess) {
                  posts = state.posts;
                  isFetchingMore = state.isFetchingMore;
                } else if (isLoading) {
                  posts = List.generate(
                    3,
                    (index) => PostModel(
                      id: index,
                      content: 'جاري تحميل المنشور الخاص بالمجتمع...',
                      createdAt: DateTime.now().toString(),
                      updatedAt: DateTime.now().toString(),
                      volunteer: VolunteerModel(
                        id: index,
                        fullName: 'اسم المستخدم',
                        nationalId: '',
                        email: '',
                        phone: '',
                        status: '',
                      ),
                      stats: StatsModel(likes: 0, comments: 0),
                      likedByMe: false,
                    ),
                  );
                }

                if (state is CommunityFeedFailure) {
                  return Center(
                    child: Text(
                      state.errorMessage,
                      style: TextStyles.cairoBold16DarkBlue(context),
                    ),
                  );
                }

                return Skeletonizer(
                  enabled: isLoading,
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: context.responsivePadding(vertical: 16),
                    itemCount: posts.length + 3,
                    // ignore: unnecessary_underscores
                    separatorBuilder: (_, __) =>
                        verticalSpace(context, height: 12),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return FadeSlideIn(
                          delay: const Duration(milliseconds: 100),
                          child: const AnnouncementCard(
                            title: 'إعلان من الإدارة',
                            body:
                                'موعد حملة الجيزة الكبرى تغير إلى الجمعة 20 مارس',
                            timeAgo: 'منذ ساعتين',
                          ),
                        );
                      }

                      if (index == posts.length + 1) {
                        if (isFetchingMore) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }

                      if (index == posts.length + 2) {
                        return verticalSpace(context, height: 72);
                      }

                      final post = posts[index - 1];
                      return FadeSlideIn(
                        delay: Duration(milliseconds: isLoading ? 0 : 100),
                        child: CommunityPostCard(
                          userName: post.volunteer.fullName,
                          timeAgo: _getTimeAgo(post.createdAt),
                          postText: post.content,
                          avatarUrl: post.volunteer.avatarUrl ?? '',
                          imageUrl: post.image ?? '',
                          likesCount: post.stats.likes,
                          commentsCount: post.stats.comments,
                          onLike: () {},
                          onComment: () {},
                          onShare: () {},
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 16.h(context),
            left: 16.w(context),
            child: ScaleBounce(
              delay: const Duration(milliseconds: 400),
              child: AddPostButton(
                onTap: () {
                  final String userName =
                      SharedPrefHelper.getData(key: SharedPrefKeys.userName) ??
                      'سند';
                  showAddPostSheet(
                    context,
                    userName: userName,
                    feedCubit: _feedCubit,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
