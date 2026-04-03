abstract class DatabaseClient {
  Future<Map<String, dynamic>> insert(String table, Map<String, dynamic> data);

  Future<List<Map<String, dynamic>>> select(
    String table, {
    String columns = '*',
    Map<String, dynamic>? filters,
    String? orderBy,
    bool ascending = false,
    int? rangeFrom,
    int? rangeTo,
  });

  Future<Map<String, dynamic>> selectById(
    String table,
    String id, {
    String columns = '*',
  });

  Future<Map<String, dynamic>> update(String table, String id, Map<String, dynamic> data);

  Future<void> delete(String table, String id);

  Future<List<Map<String, dynamic>>> search(
    String table, {
    required String column,
    required String query,
    String columns = '*',
  });

  Future<void> rpc(String functionName, {Map<String, dynamic>? params});
}
