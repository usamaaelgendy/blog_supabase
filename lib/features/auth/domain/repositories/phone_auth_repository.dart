import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PhoneAuthRepository {
  Future<Either<Failure, void>> sendOTP({required String phoneNumber});
  Future<Either<Failure, UserEntity>> verifyOTP({required String phoneNumber, required String otpCode});
}
