import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/network/supabase/database_client.dart';
import 'package:blog_app/features/blog/data/datasources/post_crud_datasource.dart';
import 'package:blog_app/features/blog/data/models/post_model.dart';

class PostCrudDataSourceImpl implements PostCrudDataSource {
  final DatabaseClient _databaseClient;

  PostCrudDataSourceImpl(this._databaseClient);

  @override
  Future<PostModel> createPost({
    required String title,
    required String content,
    required String authorId,
    String? imageUrl,
    String? category,
  }) async {
    try {
      final response = await _databaseClient.insert('posts', {
        'title': title,
        'content': content,
        'author_id': authorId,
        'image_url': imageUrl,
        'category': category,
      });

      final postId = response['id'] as String;

      return await getPostById(postId);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to create post: ${e.toString()}');
    }
  }

  @override
  Future<PostModel> getPostById(String id) async {
    try {
      // TODO: Implement getPostById
      // Use _databaseClient.selectById() with columns: '*, author:profiles!author_id(*)'
      // Parse the response into a PostModel
      throw UnimplementedError('getPostById not implemented yet');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get post: ${e.toString()}');
    }
  }

  @override
  Future<PostModel> updatePost({
    required String id,
    String? title,
    String? content,
    String? imageUrl,
    String? category,
  }) async {
    try {
      // TODO: Implement updatePost
      // Build update data map with non-null fields
      // Use _databaseClient.update() to update the post
      // Then fetch the updated post with author join using getPostById()
      throw UnimplementedError('updatePost not implemented yet');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to update post: ${e.toString()}');
    }
  }

  @override
  Future<void> deletePost(String id) async {
    try {
      // TODO: Implement deletePost
      // Use _databaseClient.delete() to delete the post from the 'posts' table
      throw UnimplementedError('deletePost not implemented yet');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to delete post: ${e.toString()}');
    }
  }
}
