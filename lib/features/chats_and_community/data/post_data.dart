class PostData {
  final String userName;
  final String timeAgo;
  final String postText;
  final String avatarUrl;
  final String? imageUrl;
  final int likesCount;
  final int commentsCount;

  const PostData({
    required this.userName,
    required this.timeAgo,
    required this.postText,
    required this.avatarUrl,
    this.imageUrl,
    this.likesCount = 0,
    this.commentsCount = 0,
  });
}
