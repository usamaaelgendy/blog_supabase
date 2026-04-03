import 'package:blog_app/core/network/supabase/auth_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthClientImpl implements AuthClient {
  final GoTrueClient _client;
  final FunctionsClient _functions;

  AuthClientImpl(this._client, this._functions);

  @override
  Future<AuthResponse> signUp({required String email, required String password, required String name}) async {
    return await _client.signUp(email: email, password: password, data: {'name': name});
  }

  @override
  Future<AuthResponse> signIn({required String email, required String password}) async {
    return await _client.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> resetPasswordForEmail({required String email}) async {
    return await _client.resetPasswordForEmail(email);
  }

  @override
  Future<AuthResponse> verifyPasswordResetOtp({required String email, required String otp}) async {
    return await _client.verifyOTP(email: email, token: otp, type: OtpType.recovery);
  }

  @override
  Future<UserResponse> updatePassword({required String password}) async {
    return await _client.updateUser(UserAttributes(password: password));
  }

  @override
  Future<AuthResponse> signInWithIdToken(OAuthProvider provider, String idToken) async {
    return await _client.signInWithIdToken(provider: provider, idToken: idToken);
  }

  @override
  Future<bool> signInWithOAuth(OAuthProvider provider, String callbackUrl) async {
    return await _client.signInWithOAuth(
      provider,
      redirectTo: callbackUrl,
      authScreenLaunchMode: LaunchMode.externalApplication,
    );
  }

  @override
  Future<void> signInWithOtp({required String phoneNumber}) async {
    await _client.signInWithOtp(phone: phoneNumber);
  }

  @override
  Future<AuthResponse> verifyOtp({required String phoneNumber, required String otp}) async {
    return await _client.verifyOTP(phone: phoneNumber, token: otp, type: OtpType.sms);
  }

  @override
  User? get getCurrentUser => _client.currentUser;

  @override
  User? get currentUser => _client.currentUser;

  @override
  Future<void> signOut() async {
    await _client.signOut(scope: SignOutScope.global);
  }

  @override
  Stream<AuthState> get onAuthStateChange => _client.onAuthStateChange;

  @override
  Future<UserResponse> updateUser({String? name, String? avatarUrl}) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (avatarUrl != null) data['avatar_url'] = avatarUrl;
    return await _client.updateUser(UserAttributes(data: data));
  }

  @override
  Future<void> deleteAccount() async {
    final response = await _functions.invoke('delete-account');
    await _client.signOut(scope: SignOutScope.global);

    if (response.status != 200) {
      throw const AuthException('Failed to delete account');
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    await deleteAccount();
  }
}
