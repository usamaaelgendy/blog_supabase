import 'package:blog_app/features/blog/data/models/profile_model.dart';
import 'package:blog_app/features/blog/domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.title,
    required super.content,
    super.imageUrl,
    required super.authorId,
    super.author,
    super.category,
    super.viewCount,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrl: json['image_url'] as String?,
      authorId: json['author_id'] as String,
      author: json['author'] != null ? ProfileModel.fromJson(json['author'] as Map<String, dynamic>) : null,
      category: json['category'] as String?,
      viewCount: json['view_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'author_id': authorId,
      'category': category,
    };
  }

  PostModel copyWith({
    String? id,
    String? title,
    String? content,
    String? imageUrl,
    String? authorId,
    ProfileModel? author,
    String? category,
    int? viewCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      authorId: authorId ?? this.authorId,
      author: author ?? this.author as ProfileModel?,
      category: category ?? this.category,
      viewCount: viewCount ?? this.viewCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
