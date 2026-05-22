import 'package:blog_app/features/blog/data/models/post_model.dart';

abstract class PostCrudDataSource {
  Future<PostModel> createPost({
    required String title,
    required String content,
    required String authorId,
    String? imageUrl,
    String? category,
  });

  Future<PostModel> getPostById(String id);

  Future<PostModel> updatePost({
    required String id,
    String? title,
    String? content,
    String? imageUrl,
    String? category,
  });

  Future<void> deletePost(String id);

  Future<String> uploadPostImage({required String authorId, required String filePath});
}
