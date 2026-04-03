import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class SocialAuthRepository {
  Future<Either<Failure, UserEntity>> signInWithGoogle();
  Future<Either<Failure, UserEntity>> signInWithApple();
  Future<Either<Failure, void>> signInWithGitHub();
}
