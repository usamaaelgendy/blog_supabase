import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/network/supabase/auth_client.dart';
import 'package:blog_app/features/auth/data/datasources/session_datasource.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';

class SessionDataSourceImpl implements SessionDataSource {
  final AuthClient _authClient;

  SessionDataSourceImpl(this._authClient);

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _authClient.currentUser;
      if (user == null) return null;
      return UserModel.fromSupabaseUser(user);
    } catch (e) {
      throw ServerException('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _authClient.signOut();
    } catch (e) {
      throw ServerException('Failed to sign out: ${e.toString()}');
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _authClient.onAuthStateChange.map((authState) {
      final user = authState.session?.user;
      if (user == null) return null;
      return UserModel.fromSupabaseUser(user);
    });
  }
}
