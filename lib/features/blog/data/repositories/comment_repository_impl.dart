import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/blog/data/datasources/comment_datasource.dart';
import 'package:blog_app/features/blog/domain/entities/comment_entity.dart';
import 'package:blog_app/features/blog/domain/repositories/comment_repository.dart';
import 'package:dartz/dartz.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentDataSource commentDataSource;

  CommentRepositoryImpl({required this.commentDataSource});

  @override
  Future<Either<Failure, CommentEntity>> addComment({
    required String postId,
    required String content,
    required String authorId,
  }) async {
    try {
      final comment = await commentDataSource.addComment(
        postId: postId,
        content: content,
        authorId: authorId,
      );
      return Right(comment);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<CommentEntity>>> getComments({required String postId}) async {
    try {
      final comments = await commentDataSource.getComments(postId: postId);
      return Right(comments);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment(String id) async {
    try {
      await commentDataSource.deleteComment(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Stream<Either<Failure, CommentEntity>> watchNewComments({required String postId}) {
    return commentDataSource
        .watchNewComments(postId: postId)
        .map<Either<Failure, CommentEntity>>((comment) => Right(comment))
        .handleError((error) {
          if (error is ServerException) {
            return Left(ServerFailure(error.message));
          } else {
            return Left(ServerFailure('Unexpected error: ${error.toString()}'));
          }
        });
  }

  @override
  Stream<Either<Failure, String>> watchDeletedComments({required String postId}) {
    return commentDataSource
        .watchDeletedComments(postId: postId)
        .map<Either<Failure, String>>((id) => Right(id))
        .handleError((error) {
          if (error is ServerException) {
            return Left(ServerFailure(error.message));
          } else {
            return Left(ServerFailure('Unexpected error: ${error.toString()}'));
          }
        });
  }
}
