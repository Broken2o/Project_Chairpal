import '../../data/models/post_model.dart';
import 'dart:io';

abstract class CommunityRepository {
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
