import 'dart:io';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/network/supabase/auth_client.dart';
import 'package:blog_app/core/network/supabase/storage_client.dart';
import 'package:blog_app/features/auth/data/datasources/profile_datasource.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';

class ProfileDataSourceImpl implements ProfileDataSource {
  final AuthClient _authClient;
  final StorageClient _storageClient;

  ProfileDataSourceImpl(this._authClient, this._storageClient);

  @override
  Future<UserModel> updateProfile({String? name, String? avatarUrl}) async {
    try {
      final response = await _authClient.updateUser(name: name, avatarUrl: avatarUrl);
      if (response.user == null) throw ServerException('Failed to update profile');
      return UserModel.fromSupabaseUser(response.user!);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to update profile: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadProfilePicture({required String filePath}) async {
    try {
      final userId = _authClient.currentUser?.id;
      if (userId == null) throw AuthException('User not authenticated');
      final file = File(filePath);
      final fileBytes = await file.readAsBytes();
      final extension = filePath.split('.').last;
      final storagePath = '$userId/avatar.$extension';
      final publicUrl = await _storageClient.uploadFile(
        bucket: 'avatars',
        path: storagePath,
        fileBytes: fileBytes,
        contentType: 'image/$extension',
      );
      await _authClient.updateUser(avatarUrl: publicUrl);
      return publicUrl;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to upload profile picture: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await _authClient.deleteAccount();
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to delete account: ${e.toString()}');
    }
  }
}
