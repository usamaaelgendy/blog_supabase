import 'package:blog_app/features/auth/data/models/user_model.dart';

abstract class ProfileDataSource {
  Future<UserModel> updateProfile({String? name, String? avatarUrl});
  Future<String> uploadProfilePicture({required String filePath});
  Future<void> deleteAccount();
}
