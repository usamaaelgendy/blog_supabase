import 'dart:async';

import 'package:blog_app/features/blog/domain/entities/post_entity.dart';
import 'package:blog_app/features/blog/domain/repositories/post_query_repository.dart';
import 'package:blog_app/features/blog/presentation/bloc/post_query/post_query_event.dart';
import 'package:blog_app/features/blog/presentation/bloc/post_query/post_query_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostQueryBloc extends Bloc<PostQueryEvent, PostQueryState> {
  final PostQueryRepository postQueryRepository;

  static const int _pageSize = 10;
  List<PostEntity> _allPosts = [];
  String? _currentCategory;

  StreamSubscription? _newPost;

  PostQueryBloc({required this.postQueryRepository}) : super(PostQueryInitial()) {
    on<GetPostsEvent>(_onGetPosts);
    on<LoadMorePostsEvent>(_onLoadMorePosts);
    on<GetMyPostsEvent>(_onGetMyPosts);
    on<SearchPostsEvent>(_onSearchPosts);
    on<RefreshPostsEvent>(_onRefreshPosts);
    on<NewPostReceivedEvent>(_onNewPostReceived);
  }

  Future<void> _onGetPosts(GetPostsEvent event, Emitter<PostQueryState> emit) async {
    emit(PostQueryLoading());
    _allPosts = [];
    _currentCategory = event.category;
    final result = await postQueryRepository.getPosts(rangeFrom: 0, rangeTo: _pageSize - 1, category: _currentCategory);
    result.fold((failure) => emit(PostQueryError(failure.message)), (posts) {
      _allPosts = posts;
      emit(PostsLoaded(posts: _allPosts, hasMore: posts.length >= _pageSize));
      _startLiveFeed();
    });
  }

  Future<void> _onLoadMorePosts(LoadMorePostsEvent event, Emitter<PostQueryState> emit) async {
    final rangeFrom = _allPosts.length;
    final rangeTo = rangeFrom + _pageSize - 1;
    final result = await postQueryRepository.getPosts(
      rangeFrom: rangeFrom,
      rangeTo: rangeTo,
      category: _currentCategory,
    );
    result.fold((failure) => emit(PostQueryError(failure.message)), (posts) {
      _allPosts = [..._allPosts, ...posts];
      emit(PostsLoaded(posts: _allPosts, hasMore: posts.length >= _pageSize));
    });
  }

  Future<void> _onGetMyPosts(GetMyPostsEvent event, Emitter<PostQueryState> emit) async {
    emit(PostQueryLoading());
    final result = await postQueryRepository.getMyPosts(userId: event.userId, category: event.category);
    result.fold(
      (failure) => emit(PostQueryError(failure.message)),
      (posts) => emit(PostsLoaded(posts: posts, hasMore: false)),
    );
  }

  Future<void> _onSearchPosts(SearchPostsEvent event, Emitter<PostQueryState> emit) async {
    if (event.query.isEmpty) {
      add(const GetPostsEvent());
      return;
    }
    emit(PostQueryLoading());
    final result = await postQueryRepository.searchPosts(query: event.query);
    result.fold(
      (failure) => emit(PostQueryError(failure.message)),
      (posts) => emit(PostsLoaded(posts: posts, hasMore: false)),
    );
  }

  Future<void> _onRefreshPosts(RefreshPostsEvent event, Emitter<PostQueryState> emit) async {
    _allPosts = [];
    final result = await postQueryRepository.getPosts(rangeFrom: 0, rangeTo: _pageSize - 1, category: _currentCategory);
    result.fold((failure) => emit(PostQueryError(failure.message)), (posts) {
      _allPosts = posts;
      emit(PostsLoaded(posts: _allPosts, hasMore: posts.length >= _pageSize));
    });
  }

  void _startLiveFeed() {
    _newPost?.cancel();
    _newPost = postQueryRepository.watchNewPosts().listen((either) {
      either.fold((_) => null, (right) {
        add(NewPostReceivedEvent(right));
      });
    });
  }

  void _onNewPostReceived(NewPostReceivedEvent event, Emitter<PostQueryState> emit) {
    if (state is! PostsLoaded) return;

    final alreadyThere = _allPosts.any((post) => post.id == event.post.id);
    if (alreadyThere) return;

    _allPosts = [event.post, ..._allPosts];
    emit(PostsLoaded(posts: _allPosts));
  }

  @override
  Future<void> close() {
    _newPost?.cancel();
    return super.close();
  }

}
