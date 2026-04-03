import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class SessionRepository {
  Future<Either<Failure, UserEntity?>> getCurrentUser();
  Future<Either<Failure, void>> signOut();
  Stream<UserEntity?> get authStateChanges;
}
