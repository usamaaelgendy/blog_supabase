import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/network/supabase/database_client.dart';
import 'package:blog_app/features/blog/data/datasources/post_query_datasource.dart';
import 'package:blog_app/features/blog/data/models/post_model.dart';

class PostQueryDataSourceImpl implements PostQueryDataSource {
  // ignore: unused_field
  final DatabaseClient _databaseClient;

  PostQueryDataSourceImpl(this._databaseClient);

  @override
  Future<List<PostModel>> getPosts({int? rangeFrom, int? rangeTo}) async {
    try {
      // TODO: Implement getPosts
      // Use _databaseClient.select() with:
      //   table: 'posts'
      //   columns: '*, author:profiles!author_id(*)'
      //   orderBy: 'created_at'
      //   ascending: false
      //   rangeFrom and rangeTo for pagination
      // Map each result to PostModel.fromJson()
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
      // Use _databaseClient.select() with:
      //   table: 'posts'
      //   columns: '*, author:profiles!author_id(*)'
      //   filters: {'author_id': userId} (and optionally 'category': category)
      //   orderBy: 'created_at'
      // Map each result to PostModel.fromJson()
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
      // Use _databaseClient.search() with:
      //   table: 'posts'
      //   column: 'title'
      //   query: query
      //   columns: '*, author:profiles!author_id(*)'
      // Map each result to PostModel.fromJson()
      throw UnimplementedError('searchPosts not implemented yet');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to search posts: ${e.toString()}');
    }
  }
}
