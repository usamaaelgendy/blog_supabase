import 'dart:async';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/network/supabase/database_client.dart';
import 'package:blog_app/core/network/supabase/supabase_realtime_client.dart';
import 'package:blog_app/features/blog/data/datasources/post_query_datasource.dart';
import 'package:blog_app/features/blog/data/models/post_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostQueryDataSourceImpl implements PostQueryDataSource {
  final DatabaseClient _databaseClient;
  final SupabaseRealtimeClient _realtimeClient;

  PostQueryDataSourceImpl(this._databaseClient, this._realtimeClient);

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
      final response = await _databaseClient.search(
        'posts',
        column: 'title',
        query: query,
        columns: '*, author:profiles!author_id(*)',
      );
      return response.map((e) => PostModel.fromJson(e)).toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to search posts: ${e.toString()}');
    }
  }

  @override
  Stream<PostModel> watchNewPosts() {
    final controller = StreamController<PostModel>();
    final channel = _realtimeClient.subscribeToTable(
      channelName: 'post-feed',
      table: 'posts',
      event: PostgresChangeEvent.insert,
      onChnage: (payload) async {
        final newPost = payload.newRecord;
        final postId = newPost['id'] as String;

        final hydrated = await _databaseClient.selectById('posts', postId, columns: '*, author:profiles!author_id(*)');

        controller.add(PostModel.fromJson(hydrated));
      },
    );

    controller.onCancel = () async {
      await _realtimeClient.unSubscribeFromTable(channel);
      await controller.close();
    };

    return controller.stream;
  }
}
