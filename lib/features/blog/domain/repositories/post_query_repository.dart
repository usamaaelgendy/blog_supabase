import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/blog/domain/entities/post_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PostQueryRepository {
  Future<Either<Failure, List<PostEntity>>> getPosts({int? rangeFrom, int? rangeTo});

  Future<Either<Failure, List<PostEntity>>> getMyPosts({required String userId, String? category});

  Future<Either<Failure, List<PostEntity>>> searchPosts({required String query});
}
