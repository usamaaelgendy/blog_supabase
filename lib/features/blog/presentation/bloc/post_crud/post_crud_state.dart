import 'package:blog_app/features/blog/domain/entities/post_entity.dart';
import 'package:equatable/equatable.dart';

abstract class PostCrudState extends Equatable {
  const PostCrudState();

  @override
  List<Object?> get props => [];
}

class PostCrudInitial extends PostCrudState {}

class PostCrudLoading extends PostCrudState {}

class PostCreated extends PostCrudState {
  final PostEntity post;

  const PostCreated(this.post);

  @override
  List<Object?> get props => [post];
}

class PostLoaded extends PostCrudState {
  final PostEntity post;

  const PostLoaded(this.post);

  @override
  List<Object?> get props => [post];
}

class PostUpdated extends PostCrudState {
  final PostEntity post;

  const PostUpdated(this.post);

  @override
  List<Object?> get props => [post];
}

class PostDeleted extends PostCrudState {}

class ViewCountIncremented extends PostCrudState {}

class PostCrudError extends PostCrudState {
  final String message;

  const PostCrudError(this.message);

  @override
  List<Object?> get props => [message];
}
