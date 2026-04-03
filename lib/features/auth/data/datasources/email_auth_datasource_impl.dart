import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/network/supabase/auth_client.dart';
import 'package:blog_app/features/auth/data/datasources/email_auth_datasource.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:blog_app/features/auth/domain/entities/user_entity.dart';

class EmailAuthDataSourceImpl implements EmailAuthDataSource {
  final AuthClient _authClient;

  EmailAuthDataSourceImpl(this._authClient);

  @override
  Future<UserModel> signUpWithEmail({required String email, required String password, required String name}) async {
    try {
      final response = await _authClient.signUp(email: email, password: password, name: name);
      if (response.user == null) throw AuthException('Signup failed: no user returned');
      return UserModel.fromSupabaseUser(response.user!);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to sign up: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signInWithEmail({required String email, required String password}) async {
    try {
      final response = await _authClient.signIn(email: email, password: password);
      if (response.user == null) throw AuthException('Login failed: no user returned');
      return UserModel.fromSupabaseUser(response.user!);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to sign in: ${e.toString()}');
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _authClient.resetPasswordForEmail(email: email);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to reset password: ${e.toString()}');
    }
  }

  @override
  Future<UserEntity> verifyPasswordRestOtp({required String email, required String otp}) async {
    try {
      final response = await _authClient.verifyPasswordResetOtp(email: email, otp: otp);
      if (response.user == null) throw AuthException('OTP verification failed');
      return UserModel.fromSupabaseUser(response.user!);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to verify OTP: ${e.toString()}');
    }
  }

  @override
  Future<void> updatePassword({required String password}) async {
    try {
      await _authClient.updatePassword(password: password);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to update password: ${e.toString()}');
    }
  }

  @override
  Future<void> sendMagicLink({required String email}) async {
    try {
      await _authClient.signInWithOtp(phoneNumber: email);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to send magic link: ${e.toString()}');
    }
  }
}
