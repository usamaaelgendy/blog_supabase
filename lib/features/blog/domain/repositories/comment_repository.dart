import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/blog/domain/entities/comment_entity.dart';
import 'package:dartz/dartz.dart';

abstract class CommentRepository {
  Future<Either<Failure, CommentEntity>> addComment({
    required String postId,
    required String content,
    required String authorId,
  });

  Future<Either<Failure, List<CommentEntity>>> getComments({required String postId});

  Future<Either<Failure, void>> deleteComment(String id);
}
