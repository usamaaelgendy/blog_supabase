import 'dart:async';

import 'package:blog_app/features/blog/data/models/post_model.dart';

abstract class PostQueryDataSource {
  Future<List<PostModel>> getPosts({int? rangeFrom, int? rangeTo, String? category});

  Future<List<PostModel>> getMyPosts({required String userId, String? category});

  Future<List<PostModel>> searchPosts({required String query});

  Stream<PostModel> watchNewPosts();
}
