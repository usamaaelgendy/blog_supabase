import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/auth/data/datasources/profile_datasource.dart';
import 'package:blog_app/features/auth/domain/entities/user_entity.dart';
import 'package:blog_app/features/auth/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource profileDataSource;

  ProfileRepositoryImpl({required this.profileDataSource});

  @override
  Future<Either<Failure, UserEntity>> updateProfile({String? name, String? avatarUrl}) async {
    try {
      final user = await profileDataSource.updateProfile(name: name, avatarUrl: avatarUrl);
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
  Future<Either<Failure, String>> uploadProfilePicture({required String filePath}) async {
    try {
      final url = await profileDataSource.uploadProfilePicture(filePath: filePath);
      return Right(url);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await profileDataSource.deleteAccount();
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
