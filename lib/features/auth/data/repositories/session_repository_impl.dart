import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/auth/data/datasources/session_datasource.dart';
import 'package:blog_app/features/auth/domain/entities/user_entity.dart';
import 'package:blog_app/features/auth/domain/repositories/session_repository.dart';
import 'package:dartz/dartz.dart';

class SessionRepositoryImpl implements SessionRepository {
  final SessionDataSource sessionDataSource;

  SessionRepositoryImpl({required this.sessionDataSource});

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await sessionDataSource.getCurrentUser();
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await sessionDataSource.signOut();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges => sessionDataSource.authStateChanges;
}
