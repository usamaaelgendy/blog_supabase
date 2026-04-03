import 'package:blog_app/features/blog/domain/entities/comment_entity.dart';
import 'package:equatable/equatable.dart';

abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object?> get props => [];
}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentsLoaded extends CommentState {
  final List<CommentEntity> comments;

  const CommentsLoaded(this.comments);

  @override
  List<Object?> get props => [comments];
}

class CommentAdded extends CommentState {
  final CommentEntity comment;

  const CommentAdded(this.comment);

  @override
  List<Object?> get props => [comment];
}

class CommentDeleted extends CommentState {}

class CommentError extends CommentState {
  final String message;

  const CommentError(this.message);

  @override
  List<Object?> get props => [message];
}
