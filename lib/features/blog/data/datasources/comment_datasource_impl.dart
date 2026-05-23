import 'dart:async';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/network/supabase/database_client.dart';
import 'package:blog_app/core/network/supabase/supabase_realtime_client.dart';
import 'package:blog_app/features/blog/data/datasources/comment_datasource.dart';
import 'package:blog_app/features/blog/data/models/comment_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentDataSourceImpl implements CommentDataSource {
  final DatabaseClient _databaseClient;
  final SupabaseRealtimeClient _realtimeClient;

  CommentDataSourceImpl(this._databaseClient, this._realtimeClient);

  @override
  Future<CommentModel> addComment({
    required String postId,
    required String content,
    required String authorId,
  }) async {
    try {
      final response = await _databaseClient.insert('comments', {
        'content': content,
        'post_id': postId,
        'author_id': authorId,
      });

      final commentId = response['id'] as String;

      final commentWithAuthor = await _databaseClient.selectById(
        'comments',
        commentId,
        columns: '*, author:profiles!author_id(*)',
      );

      return CommentModel.fromJson(commentWithAuthor);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to add comment: ${e.toString()}');
    }
  }

  @override
  Future<List<CommentModel>> getComments({required String postId}) async {
    try {
      final response = await _databaseClient.select(
        'comments',
        columns: '*, author:profiles!author_id(*)',
        filters: {'post_id': postId},
        orderBy: 'created_at',
        ascending: true,
      );

      return response.map((json) => CommentModel.fromJson(json)).toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get comments: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteComment(String id) async {
    try {
      await _databaseClient.delete('comments', id);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to delete comment: ${e.toString()}');
    }
  }

  @override
  Stream<CommentModel> watchNewComments({required String postId}) {
    final controller = StreamController<CommentModel>();
    final channel = _realtimeClient.subscribeToTable(
      channelName: 'comments-insert-$postId',
      table: 'comments',
      event: PostgresChangeEvent.insert,
      filterColumn: 'post_id',
      filterValue: postId,
      onChnage: (payload) async {
        final newComment = payload.newRecord;
        final commentId = newComment['id'] as String;

        final hydrated = await _databaseClient.selectById(
          'comments',
          commentId,
          columns: '*, author:profiles!author_id(*)',
        );

        controller.add(CommentModel.fromJson(hydrated));
      },
    );

    controller.onCancel = () async {
      await _realtimeClient.unSubscribeFromTable(channel);
      await controller.close();
    };

    return controller.stream;
  }

  @override
  Stream<String> watchDeletedComments({required String postId}) {
    final controller = StreamController<String>();
    final channel = _realtimeClient.subscribeToTable(
      channelName: 'comments-delete-$postId',
      table: 'comments',
      event: PostgresChangeEvent.delete,
      filterColumn: 'post_id',
      filterValue: postId,
      onChnage: (payload) {
        final oldComment = payload.oldRecord;
        final commentId = oldComment['id'] as String;
        controller.add(commentId);
      },
    );

    controller.onCancel = () async {
      await _realtimeClient.unSubscribeFromTable(channel);
      await controller.close();
    };

    return controller.stream;
  }
}
