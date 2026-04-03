import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/blog/data/datasources/post_crud_datasource.dart';
import 'package:blog_app/features/blog/domain/entities/post_entity.dart';
import 'package:blog_app/features/blog/domain/repositories/post_crud_repository.dart';
import 'package:dartz/dartz.dart';

class PostCrudRepositoryImpl implements PostCrudRepository {
  final PostCrudDataSource postCrudDataSource;

  PostCrudRepositoryImpl({required this.postCrudDataSource});

  @override
  Future<Either<Failure, PostEntity>> createPost({
    required String title,
    required String content,
    required String authorId,
    String? imageUrl,
    String? category,
  }) async {
    try {
      final post = await postCrudDataSource.createPost(
        title: title,
        content: content,
        authorId: authorId,
        imageUrl: imageUrl,
        category: category,
      );
      return Right(post);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> getPostById(String id) async {
    try {
      final post = await postCrudDataSource.getPostById(id);
      return Right(post);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> updatePost({
    required String id,
    String? title,
    String? content,
    String? imageUrl,
    String? category,
  }) async {
    try {
      final post = await postCrudDataSource.updatePost(
        id: id,
        title: title,
        content: content,
        imageUrl: imageUrl,
        category: category,
      );
      return Right(post);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(String id) async {
    try {
      await postCrudDataSource.deletePost(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
