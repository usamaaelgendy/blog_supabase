import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/blog/domain/entities/post_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PostCrudRepository {
  Future<Either<Failure, PostEntity>> createPost({
    required String title,
    required String content,
    required String authorId,
    String? imageUrl,
    String? category,
  });

  Future<Either<Failure, PostEntity>> getPostById(String id);

  Future<Either<Failure, PostEntity>> updatePost({
    required String id,
    String? title,
    String? content,
    String? imageUrl,
    String? category,
  });

  Future<Either<Failure, void>> deletePost(String id);

  Future<Either<Failure, String>> uploadPostImage({required String authorId, required String filePath});
}
