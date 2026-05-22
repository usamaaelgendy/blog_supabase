import 'dart:io';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/network/supabase/database_client.dart';
import 'package:blog_app/core/network/supabase/storage_client.dart';
import 'package:blog_app/features/blog/data/datasources/post_crud_datasource.dart';
import 'package:blog_app/features/blog/data/models/post_model.dart';

class PostCrudDataSourceImpl implements PostCrudDataSource {
  final DatabaseClient _databaseClient;
  final StorageClient _storageClient;

  PostCrudDataSourceImpl(this._databaseClient, this._storageClient);

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
      final response = await _databaseClient.selectById('posts', id, columns: '*, auther:profiles!author_id(*)');

      return PostModel.fromJson(response);
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
      final data = {
        'updated_at': DateTime.now().toIso8601String(),
        'title': title,
        'content': content,
        'image_url': imageUrl,
        'category': category,
      }..removeWhere((key, value) => value == null);

      await _databaseClient.update('posts', id, data);

      return await getPostById(id);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to update post: ${e.toString()}');
    }
  }

  @override
  Future<void> deletePost(String id) async {
    try {
      await _databaseClient.delete('posts', id);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to delete post: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadPostImage({required String authorId, required String filePath}) async {
    try {
      final fileBytes = await File(filePath).readAsBytes();
      final extension = filePath.split('.').last;
      final storagePath = '$authorId/${DateTime.now().millisecondsSinceEpoch}.$extension';
      return await _storageClient.uploadFile(
        bucket: 'post-image',
        path: storagePath,
        fileBytes: fileBytes,
        contentType: 'image/$extension',
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to upload post image: ${e.toString()}');
    }
  }
}
