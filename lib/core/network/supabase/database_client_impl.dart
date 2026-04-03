import 'package:blog_app/core/network/supabase/database_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseClientImpl implements DatabaseClient {
  final SupabaseClient _client;

  DatabaseClientImpl(this._client);

  @override
  Future<Map<String, dynamic>> insert(String table, Map<String, dynamic> data) async {
    final response = await _client.from(table).insert(data).select().single();

    return response;
  }

  @override
  Future<List<Map<String, dynamic>>> select(
    String table, {
    String columns = '*',
    Map<String, dynamic>? filters,
    String? orderBy,
    bool ascending = false,
    int? rangeFrom,
    int? rangeTo,
  }) async {
    dynamic query = _client.from(table).select(columns);

    if (filters != null) {
      filters.forEach((key, value) {
        query = query.eq(key, value);
      });
    }

    if (orderBy != null) {
      query = query.order(orderBy, ascending: ascending);
    }

    if (rangeFrom != null && rangeTo != null) {
      query = query.range(rangeFrom, rangeTo);
    }

    final response = await query;

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<Map<String, dynamic>> selectById(String table, String id, {String columns = '*'}) async {
    final response = await _client.from(table).select(columns).eq('id', id).single();

    return response;
  }

  @override
  Future<Map<String, dynamic>> update(String table, String id, Map<String, dynamic> data) async {
    // TODO: Implement update
    throw UnimplementedError('update not implemented yet');
  }

  @override
  Future<void> delete(String table, String id) async {
    // TODO: Implement delete
    throw UnimplementedError('delete not implemented yet');
  }

  @override
  Future<List<Map<String, dynamic>>> search(
    String table, {
    required String column,
    required String query,
    String columns = '*',
  }) async {
    // TODO: Implement search
    throw UnimplementedError('search not implemented yet');
  }

  @override
  Future<void> rpc(String functionName, {Map<String, dynamic>? params}) async {
    // TODO: Implement rpc
    throw UnimplementedError('rpc not implemented yet');
  }
}
