import 'package:blog_app/core/network/supabase/supabase_realtime_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseRealtimeClientImpl implements SupabaseRealtimeClient {
  final SupabaseClient _client;

  SupabaseRealtimeClientImpl(this._client);

  @override
  RealtimeChannel subscribeToTable({
    required String channelName,
    required String table,
    PostgresChangeEvent event = PostgresChangeEvent.all,
    String? filterColumn,
    String? filterValue,
    required PostgresChangeHandler onChnage,
  }) {
    final filter = (filterColumn != null && filterValue != null)
        ? PostgresChangeFilter(type: PostgresChangeFilterType.eq, column: filterColumn, value: filterValue)
        : null;
    final channel = _client.channel(channelName);

    channel
        .onPostgresChanges(event: event, schema: 'public', table: table, callback: onChnage, filter: filter)
        .subscribe();

    return channel;
  }

  @override
  Future<void> unSubscribeFromTable(RealtimeChannel channelName) async {
    await _client.removeChannel(channelName);
  }
}
