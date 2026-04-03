import 'package:blog_app/features/auth/data/models/user_model.dart';

abstract class PhoneAuthDataSource {
  Future<void> sendOTP({required String phoneNumber});
  Future<UserModel> verifyOTP({required String phoneNumber, required String otpCode});
}
