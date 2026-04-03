import 'package:equatable/equatable.dart';

abstract class PostCrudEvent extends Equatable {
  const PostCrudEvent();

  @override
  List<Object?> get props => [];
}

class CreatePostEvent extends PostCrudEvent {
  final String title;
  final String content;
  final String authorId;
  final String? imagePath;
  final String? category;

  const CreatePostEvent({
    required this.title,
    required this.content,
    required this.authorId,
    this.imagePath,
    this.category,
  });

  @override
  List<Object?> get props => [title, content, authorId, imagePath, category];
}

class GetPostByIdEvent extends PostCrudEvent {
  final String postId;

  const GetPostByIdEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}

class UpdatePostEvent extends PostCrudEvent {
  final String id;
  final String? title;
  final String? content;
  final String? imagePath;
  final String? category;

  const UpdatePostEvent({
    required this.id,
    this.title,
    this.content,
    this.imagePath,
    this.category,
  });

  @override
  List<Object?> get props => [id, title, content, imagePath, category];
}

class DeletePostEvent extends PostCrudEvent {
  final String postId;

  const DeletePostEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}

class IncrementViewCountEvent extends PostCrudEvent {
  final String postId;

  const IncrementViewCountEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}
