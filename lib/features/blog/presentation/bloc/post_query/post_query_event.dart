import 'package:equatable/equatable.dart';

abstract class PostQueryEvent extends Equatable {
  const PostQueryEvent();

  @override
  List<Object?> get props => [];
}

class GetPostsEvent extends PostQueryEvent {
  final String? category;

  const GetPostsEvent({this.category});

  @override
  List<Object?> get props => [category];
}

class LoadMorePostsEvent extends PostQueryEvent {
  const LoadMorePostsEvent();
}

class GetMyPostsEvent extends PostQueryEvent {
  final String userId;
  final String? category;

  const GetMyPostsEvent({required this.userId, this.category});

  @override
  List<Object?> get props => [userId, category];
}

class SearchPostsEvent extends PostQueryEvent {
  final String query;

  const SearchPostsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class RefreshPostsEvent extends PostQueryEvent {
  const RefreshPostsEvent();
}
