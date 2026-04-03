import 'package:blog_app/features/blog/domain/entities/post_entity.dart';
import 'package:equatable/equatable.dart';

abstract class PostQueryState extends Equatable {
  const PostQueryState();

  @override
  List<Object?> get props => [];
}

class PostQueryInitial extends PostQueryState {}

class PostQueryLoading extends PostQueryState {}

class PostsLoaded extends PostQueryState {
  final List<PostEntity> posts;
  final bool hasMore;

  const PostsLoaded({required this.posts, this.hasMore = true});

  @override
  List<Object?> get props => [posts, hasMore];
}

class PostQueryError extends PostQueryState {
  final String message;

  const PostQueryError(this.message);

  @override
  List<Object?> get props => [message];
}
