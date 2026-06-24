import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/community_repository.dart';
import '../../data/models/post_model.dart';

abstract class CreatePostState {}
class CreatePostInitial extends CreatePostState {}
class CreatePostLoading extends CreatePostState {}
class CreatePostSuccess extends CreatePostState {
  final PostModel post;
  CreatePostSuccess(this.post);
}
class CreatePostError extends CreatePostState {
  final String message;
  CreatePostError(this.message);
}

class CreatePostCubit extends Cubit<CreatePostState> {
  final CommunityRepository repository;
  
  CreatePostCubit({required this.repository}) : super(CreatePostInitial());

  Future<void> createPost(String content, {List<File>? images, List<File>? files}) async {
    emit(CreatePostLoading());
    try {
      final post = await repository.createPost(content, images, files);
      emit(CreatePostSuccess(post));
    } catch (e) {
      emit(CreatePostError(e.toString()));
    }
  }
}
