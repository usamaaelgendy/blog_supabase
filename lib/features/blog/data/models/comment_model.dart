import 'package:blog_app/features/blog/data/models/profile_model.dart';
import 'package:blog_app/features/blog/domain/entities/comment_entity.dart';

class CommentModel extends CommentEntity {
  const CommentModel({
    required super.id,
    required super.content,
    required super.postId,
    required super.authorId,
    super.author,
    required super.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as String,
      content: json['content'] as String,
      postId: json['post_id'] as String,
      authorId: json['author_id'] as String,
      author: json['author'] != null ? ProfileModel.fromJson(json['author'] as Map<String, dynamic>) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'post_id': postId,
      'author_id': authorId,
    };
  }
}
