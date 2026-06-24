import 'package:dio/dio.dart';
import '../../domain/repositories/community_repository.dart';
import '../datasources/community_remote_data_source.dart';
import '../models/post_model.dart';
import 'dart:io';

class CommunityRepositoryImpl implements CommunityRepository {
  final CommunityRemoteDataSource remoteDataSource;

  CommunityRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>> getAllPosts({String? cursor, int? limit, int? userId}) async {
    try {
      return await remoteDataSource.getAllPosts(cursor: cursor, limit: limit, userId: userId);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Server error');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<PostModel> getPostDetails(int postId) async {
    try {
      return await remoteDataSource.getPostDetails(postId);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Server error');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<PostModel> createPost(String content, List<File>? images, List<File>? files) async {
    try {
      return await remoteDataSource.createPost(content, images, files);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Server error');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> sharePost(int postId, {String? content}) async {
    try {
      return await remoteDataSource.sharePost(postId, content: content);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Server error');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> toggleLike(int postId) async {
    try {
      await remoteDataSource.toggleLike(postId);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Server error');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<PostUser>> getPostLikes(int postId, {int? page}) async {
    try {
      return await remoteDataSource.getPostLikes(postId, page: page);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Server error');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<CommentModel>> getPostComments(int postId, {int? page}) async {
    try {
      return await remoteDataSource.getPostComments(postId, page: page);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Server error');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<CommentModel> createComment(int postId, String content, {int? parentId}) async {
    try {
      return await remoteDataSource.createComment(postId, content, parentId: parentId);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Server error');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<CommentModel> updateComment(int commentId, String content) async {
    try {
      return await remoteDataSource.updateComment(commentId, content);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Server error');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> toggleCommentLike(int commentId) async {
    try {
      await remoteDataSource.toggleCommentLike(commentId);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Server error');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<PostUser>> getCommentLikes(int commentId, {int? page}) async {
    try {
      return await remoteDataSource.getCommentLikes(commentId, page: page);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Server error');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> hidePost(int postId) async {
    try {
      return await remoteDataSource.hidePost(postId);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Server error');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
