import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/blog/data/datasources/post_query_datasource.dart';
import 'package:blog_app/features/blog/domain/entities/post_entity.dart';
import 'package:blog_app/features/blog/domain/repositories/post_query_repository.dart';
import 'package:dartz/dartz.dart';

class PostQueryRepositoryImpl implements PostQueryRepository {
  final PostQueryDataSource postQueryDataSource;

  PostQueryRepositoryImpl({required this.postQueryDataSource});

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts({int? rangeFrom, int? rangeTo}) async {
    try {
      final posts = await postQueryDataSource.getPosts(rangeFrom: rangeFrom, rangeTo: rangeTo);
      return Right(posts);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getMyPosts({required String userId, String? category}) async {
    try {
      final posts = await postQueryDataSource.getMyPosts(userId: userId, category: category);
      return Right(posts);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<PostEntity>>> searchPosts({required String query}) async {
    try {
      final posts = await postQueryDataSource.searchPosts(query: query);
      return Right(posts);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
