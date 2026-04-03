import 'package:equatable/equatable.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object?> get props => [];
}

class GetCommentsEvent extends CommentEvent {
  final String postId;

  const GetCommentsEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}

class AddCommentEvent extends CommentEvent {
  final String postId;
  final String content;
  final String authorId;

  const AddCommentEvent({required this.postId, required this.content, required this.authorId});

  @override
  List<Object?> get props => [postId, content, authorId];
}

class DeleteCommentEvent extends CommentEvent {
  final String commentId;
  final String postId;

  const DeleteCommentEvent({required this.commentId, required this.postId});

  @override
  List<Object?> get props => [commentId, postId];
}
