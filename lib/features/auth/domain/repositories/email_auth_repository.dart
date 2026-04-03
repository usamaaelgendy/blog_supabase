import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class EmailAuthRepository {
  Future<Either<Failure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> resetPassword({required String email});

  Future<Either<Failure, UserEntity>> verifyPasswordRestOtp({
    required String email,
    required String otp,
  });

  Future<Either<Failure, void>> updatePassword({required String password});

  Future<Either<Failure, void>> sendMagicLink({required String email});
}
