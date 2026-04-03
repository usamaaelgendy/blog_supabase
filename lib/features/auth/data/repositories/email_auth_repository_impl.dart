import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/auth/data/datasources/email_auth_datasource.dart';
import 'package:blog_app/features/auth/domain/entities/user_entity.dart';
import 'package:blog_app/features/auth/domain/repositories/email_auth_repository.dart';
import 'package:dartz/dartz.dart';

class EmailAuthRepositoryImpl implements EmailAuthRepository {
  final EmailAuthDataSource emailAuthDataSource;

  EmailAuthRepositoryImpl({required this.emailAuthDataSource});

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final user = await emailAuthDataSource.signUpWithEmail(email: email, password: password, name: name);
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmail({required String email, required String password}) async {
    try {
      final user = await emailAuthDataSource.signInWithEmail(email: email, password: password);
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    try {
      await emailAuthDataSource.resetPassword(email: email);
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
  Future<Either<Failure, UserEntity>> verifyPasswordRestOtp({required String email, required String otp}) async {
    try {
      final user = await emailAuthDataSource.verifyPasswordRestOtp(email: email, otp: otp);
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updatePassword({required String password}) async {
    try {
      await emailAuthDataSource.updatePassword(password: password);
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
  Future<Either<Failure, void>> sendMagicLink({required String email}) async {
    try {
      await emailAuthDataSource.sendMagicLink(email: email);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
