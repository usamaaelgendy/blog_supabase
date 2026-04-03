import 'package:blog_app/features/blog/domain/entities/profile_entity.dart';
import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  final String id;
  final String content;
  final String postId;
  final String authorId;
  final ProfileEntity? author;
  final DateTime createdAt;

  const CommentEntity({
    required this.id,
    required this.content,
    required this.postId,
    required this.authorId,
    this.author,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, content, postId, authorId, author, createdAt];
}
