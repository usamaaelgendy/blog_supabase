import 'package:supabase_flutter/supabase_flutter.dart';

typedef PostgresChangeHandler = void Function(PostgresChangePayload payload);

abstract class SupabaseRealtimeClient {
  RealtimeChannel subscribeToTable({
    required String channelName,
    required String table,
    PostgresChangeEvent event = PostgresChangeEvent.all,
    String? filterColumn,
    String? filterValue,
    required PostgresChangeHandler onChnage,
  });

  Future<void> unSubscribeFromTable(RealtimeChannel channelName);
}
