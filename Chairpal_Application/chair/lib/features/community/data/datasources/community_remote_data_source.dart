import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/post_model.dart';
import 'dart:io';
import 'dart:developer' as developer;

abstract class CommunityRemoteDataSource {
  Future<Map<String, dynamic>> getAllPosts({String? cursor, int? limit, int? userId});
  Future<PostModel> getPostDetails(int postId);
  Future<PostModel> createPost(String content, List<File>? images, List<File>? files);
  Future<Map<String, dynamic>> sharePost(int postId, {String? content});
  Future<void> toggleLike(int postId);
  Future<List<PostUser>> getPostLikes(int postId, {int? page});
  
  Future<List<CommentModel>> getPostComments(int postId, {int? page});
  Future<CommentModel> createComment(int postId, String content, {int? parentId});
  Future<CommentModel> updateComment(int commentId, String content);
  Future<void> toggleCommentLike(int commentId);
  Future<List<PostUser>> getCommentLikes(int commentId, {int? page});
  Future<bool> hidePost(int postId);
}

class CommunityRemoteDataSourceImpl implements CommunityRemoteDataSource {
  final DioClient _dioClient;

  CommunityRemoteDataSourceImpl({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  @override
  Future<Map<String, dynamic>> getAllPosts({String? cursor, int? limit, int? userId}) async {
    try {
      developer.log('Fetching posts with userId: $userId, cursor: $cursor', name: 'API_REQUEST');
      final response = await _dioClient.dio.get(
        ApiConstants.postsEndpoint,
        queryParameters: {
          if (cursor != null) 'cursor': cursor,
          if (limit != null) 'limit': limit,
          if (userId != null) 'user_id': userId,
        },
      );
      if (response.statusCode == 200) {
        developer.log('Community Posts Response: ${response.data}', name: 'API_RESPONSE');
        final List<dynamic> data = response.data['data']['posts'];
        final posts = data.map((json) => PostModel.fromJson(json)).toList();
        return {
          'posts': posts,
          'next_cursor': response.data['data']['next_cursor'],
        };
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PostModel> getPostDetails(int postId) async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.postDetailsEndpoint(postId));
      if (response.statusCode == 200) {
        return PostModel.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PostModel> createPost(String content, List<File>? images, List<File>? files) async {
    try {
      FormData formData = FormData.fromMap({
        'content': content,
      });
      if (images != null) {
        for (int i = 0; i < images.length; i++) {
          formData.files.add(MapEntry(
            'images[$i]',
            await MultipartFile.fromFile(images[i].path),
          ));
        }
      }
      if (files != null) {
        for (int i = 0; i < files.length; i++) {
          formData.files.add(MapEntry(
            'files[$i]',
            await MultipartFile.fromFile(files[i].path),
          ));
        }
      }

      final response = await _dioClient.dio.post(
        ApiConstants.postsEndpoint,
        data: formData,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return PostModel.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> sharePost(int postId, {String? content}) async {
    try {
      final data = content != null && content.isNotEmpty ? {'content': content} : null;
      final response = await _dioClient.dio.post(
        ApiConstants.postShareEndpoint(postId),
        data: data,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'post': PostModel.fromJson(response.data['data']),
          'message': response.data['message'] ?? 'Shared successfully!',
        };
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> toggleLike(int postId) async {
    try {
      final response = await _dioClient.dio.post(ApiConstants.postLikeEndpoint(postId));
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PostUser>> getPostLikes(int postId, {int? page}) async {
    try {
      final response = await _dioClient.dio.get(
        ApiConstants.postLikesEndpoint(postId),
        queryParameters: {
          if (page != null) 'page': page,
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data']['likes'];
        return data.map((json) => PostUser.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CommentModel>> getPostComments(int postId, {int? page}) async {
    try {
      final response = await _dioClient.dio.get(
        ApiConstants.postCommentsEndpoint(postId),
        queryParameters: {
          if (page != null) 'page': page,
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data']['comments'];
        return data.map((json) => CommentModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CommentModel> createComment(int postId, String content, {int? parentId}) async {
    try {
      FormData formData = FormData.fromMap({
        'content': content,
        if (parentId != null) 'parent_id': parentId,
      });
      final response = await _dioClient.dio.post(
        ApiConstants.postCommentsEndpoint(postId),
        data: formData,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return CommentModel.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CommentModel> updateComment(int commentId, String content) async {
    try {
      FormData formData = FormData.fromMap({
        'content': content,
        '_method': 'PUT',
      });
      final response = await _dioClient.dio.post(
        ApiConstants.commentEndpoint(commentId),
        data: formData,
      );
      if (response.statusCode == 200) {
        return CommentModel.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> toggleCommentLike(int commentId) async {
    try {
      final response = await _dioClient.dio.post(ApiConstants.commentLikeEndpoint(commentId));
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PostUser>> getCommentLikes(int commentId, {int? page}) async {
    try {
      final response = await _dioClient.dio.get(
        ApiConstants.commentLikesEndpoint(commentId),
        queryParameters: {
          if (page != null) 'page': page,
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data']['likes'];
        return data.map((json) => PostUser.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future<bool> hidePost(int postId) async {
    try {
      final response = await _dioClient.dio.post(ApiConstants.hidePostEndpoint(postId));
      if (response.statusCode == 200) {
        return response.data['data']['is_hidden'];
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
