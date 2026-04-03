import 'dart:typed_data';

import 'package:blog_app/core/network/supabase/storage_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageClientImpl implements StorageClient {
  final SupabaseClient _client;

  StorageClientImpl(this._client);

  @override
  Future<String> uploadFile({
    required String bucket,
    required String path,
    required Uint8List fileBytes,
    String? contentType,
  }) async {
    await _client.storage.from(bucket).uploadBinary(
      path,
      fileBytes,
      fileOptions: FileOptions(contentType: contentType, upsert: true),
    );
    return _client.storage.from(bucket).getPublicUrl(path);
  }

  @override
  String getPublicUrl({required String bucket, required String path}) {
    return _client.storage.from(bucket).getPublicUrl(path);
  }

  @override
  Future<void> deleteFile({required String bucket, required String path}) async {
    await _client.storage.from(bucket).remove([path]);
  }
}
