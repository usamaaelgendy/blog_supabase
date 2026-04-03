import 'package:blog_app/features/blog/data/models/comment_model.dart';

abstract class CommentDataSource {
  Future<CommentModel> addComment({
    required String postId,
    required String content,
    required String authorId,
  });

  Future<List<CommentModel>> getComments({required String postId});

  Future<void> deleteComment(String id);
}
