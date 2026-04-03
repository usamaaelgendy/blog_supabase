import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserEntity>> updateProfile({String? name, String? avatarUrl});
  Future<Either<Failure, String>> uploadProfilePicture({required String filePath});
  Future<Either<Failure, void>> deleteAccount();
}
