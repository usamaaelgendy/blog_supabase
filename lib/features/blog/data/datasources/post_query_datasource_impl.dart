import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/network/supabase/database_client.dart';
import 'package:blog_app/features/blog/data/datasources/post_query_datasource.dart';
import 'package:blog_app/features/blog/data/models/post_model.dart';

class PostQueryDataSourceImpl implements PostQueryDataSource {
  final DatabaseClient _databaseClient;

  PostQueryDataSourceImpl(this._databaseClient);

  @override
  Future<List<PostModel>> getPosts({int? rangeFrom, int? rangeTo}) async {
    try {
      // TODO: Implement getPosts
      throw UnimplementedError('getPosts not implemented yet');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get posts: ${e.toString()}');
    }
  }

  @override
  Future<List<PostModel>> getMyPosts({required String userId, String? category}) async {
    try {
      // TODO: Implement getMyPosts
      throw UnimplementedError('getMyPosts not implemented yet');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get my posts: ${e.toString()}');
    }
  }

  @override
  Future<List<PostModel>> searchPosts({required String query}) async {
    try {
      // TODO: Implement searchPosts
      throw UnimplementedError('searchPosts not implemented yet');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to search posts: ${e.toString()}');
    }
  }
}
