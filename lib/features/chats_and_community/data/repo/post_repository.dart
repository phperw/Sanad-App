import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/error_hander.dart';
import '../models/create_post_response.dart';
import '../models/post/community_feed_response.dart';
import '../api_service/post_api_service.dart';

class PostRepository {
  final PostApiService _apiService;

  PostRepository(this._apiService);

  Future<File?> _compressImage(File image) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath =
          '${dir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final result = await FlutterImageCompress.compressAndGetFile(
        image.absolute.path,
        targetPath,
        quality: 70,
        minWidth: 1080,
        minHeight: 1080,
      );

      return result != null ? File(result.path) : image;
    } catch (_) {
      return image;
    }
  }

  Future<ApiResult<CreatePostResponse>> createPost({
    required String content,
    File? image,
  }) async {
    try {
      CreatePostResponse response;

      if (image != null) {
        final compressed = await _compressImage(image) ?? image;

        final multipartImage = await MultipartFile.fromFile(
          compressed.path,
          filename: compressed.path.split('/').last,
          contentType: MediaType('image', 'jpeg'),
        );

        response =
            await _apiService.createPostWithImage(content, multipartImage);
      } else {
        response =
            await _apiService.createPostTextOnly({'content': content});
      }

      return Success(response);
    } catch (e) {
      return Failure(ErrorHandler.handle(e));
    }
  }

  Future<ApiResult<CommunityFeedResponse>> getCommunityFeed({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.getCommunityFeed(page, limit);
      return Success(response);
    } catch (e) {
      return Failure(ErrorHandler.handle(e));
    }
  }
}