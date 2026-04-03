import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/network/supabase/database_client.dart';
import 'package:blog_app/features/blog/data/datasources/comment_datasource.dart';
import 'package:blog_app/features/blog/data/models/comment_model.dart';

class CommentDataSourceImpl implements CommentDataSource {
  // ignore: unused_field
  final DatabaseClient _databaseClient;

  CommentDataSourceImpl(this._databaseClient);

  @override
  Future<CommentModel> addComment({
    required String postId,
    required String content,
    required String authorId,
  }) async {
    try {
      // TODO: Implement addComment
      // Use _databaseClient.insert() to add a comment to the 'comments' table
      // Then fetch the comment with author join
      throw UnimplementedError('addComment not implemented yet');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to add comment: ${e.toString()}');
    }
  }

  @override
  Future<List<CommentModel>> getComments({required String postId}) async {
    try {
      // TODO: Implement getComments
      // Use _databaseClient.select() with:
      //   table: 'comments'
      //   columns: '*, author:profiles!author_id(*)'
      //   filters: {'post_id': postId}
      //   orderBy: 'created_at'
      //   ascending: true
      // Map each result to CommentModel.fromJson()
      throw UnimplementedError('getComments not implemented yet');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get comments: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteComment(String id) async {
    try {
      // TODO: Implement deleteComment
      // Use _databaseClient.delete() to remove the comment
      throw UnimplementedError('deleteComment not implemented yet');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to delete comment: ${e.toString()}');
    }
  }
}
