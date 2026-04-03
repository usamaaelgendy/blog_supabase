import 'dart:typed_data';

abstract class StorageClient {
  Future<String> uploadFile({
    required String bucket,
    required String path,
    required Uint8List fileBytes,
    String? contentType,
  });

  String getPublicUrl({required String bucket, required String path});

  Future<void> deleteFile({required String bucket, required String path});
}
