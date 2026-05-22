import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/network/supabase/database_client.dart';
import 'package:blog_app/features/blog/data/datasources/post_query_datasource.dart';
import 'package:blog_app/features/blog/data/models/post_model.dart';

class PostQueryDataSourceImpl implements PostQueryDataSource {
  final DatabaseClient _databaseClient;

  PostQueryDataSourceImpl(this._databaseClient);

  @override
  Future<List<PostModel>> getPosts({int? rangeFrom, int? rangeTo, String? category}) async {
    try {
      final response = await _databaseClient.select(
        'posts',
        columns: '*, author:profiles!author_id(*)',
        rangeFrom: rangeFrom,
        rangeTo: rangeTo,
        orderBy: 'created_at',
        ascending: false,
        filters: category != null ? {'category': category} : null,
      );

      return response.map((e) => PostModel.fromJson(e)).toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get posts: ${e.toString()}');
    }
  }

  @override
  Future<List<PostModel>> getMyPosts({required String userId, String? category}) async {
    try {
      final filters = <String, dynamic>{'author_id': userId};
      if (category != null) {
        filters['category'] = category;
      }

      final response = await _databaseClient.select(
        'posts',
        columns: '*, author:profiles!author_id(*)',
        orderBy: 'created_at',
        filters: filters,
        ascending: false,
      );

      return response.map((e) => PostModel.fromJson(e)).toList();
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
