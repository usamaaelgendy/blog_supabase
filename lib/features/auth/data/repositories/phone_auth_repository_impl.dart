import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/auth/data/datasources/phone_auth_datasource.dart';
import 'package:blog_app/features/auth/domain/entities/user_entity.dart';
import 'package:blog_app/features/auth/domain/repositories/phone_auth_repository.dart';
import 'package:dartz/dartz.dart';

class PhoneAuthRepositoryImpl implements PhoneAuthRepository {
  final PhoneAuthDataSource phoneAuthDataSource;

  PhoneAuthRepositoryImpl({required this.phoneAuthDataSource});

  @override
  Future<Either<Failure, void>> sendOTP({required String phoneNumber}) async {
    try {
      await phoneAuthDataSource.sendOTP(phoneNumber: phoneNumber);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> verifyOTP({required String phoneNumber, required String otpCode}) async {
    try {
      final user = await phoneAuthDataSource.verifyOTP(phoneNumber: phoneNumber, otpCode: otpCode);
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
