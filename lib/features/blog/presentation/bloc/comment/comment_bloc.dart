import 'dart:async';

import 'package:blog_app/features/blog/domain/entities/comment_entity.dart';
import 'package:blog_app/features/blog/domain/repositories/comment_repository.dart';
import 'package:blog_app/features/blog/presentation/bloc/comment/comment_event.dart';
import 'package:blog_app/features/blog/presentation/bloc/comment/comment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository commentRepository;

  List<CommentEntity> _allComments = [];

  StreamSubscription? _newCommentSub;
  StreamSubscription? _deletedCommentSub;

  CommentBloc({required this.commentRepository}) : super(CommentInitial()) {
    on<GetCommentsEvent>(_onGetComments);
    on<AddCommentEvent>(_onAddComment);
    on<DeleteCommentEvent>(_onDeleteComment);
    on<NewCommentReceivedEvent>(_onNewCommentReceived);
    on<CommentRemovedEvent>(_onCommentRemoved);
  }

  Future<void> _onGetComments(GetCommentsEvent event, Emitter<CommentState> emit) async {
    emit(CommentLoading());
    final result = await commentRepository.getComments(postId: event.postId);
    result.fold((failure) => emit(CommentError(failure.message)), (comments) {
      _allComments = comments;
      emit(CommentsLoaded(List.from(_allComments)));
      _startCommentLiveFeed(event.postId);
    });
  }

  Future<void> _onAddComment(AddCommentEvent event, Emitter<CommentState> emit) async {
    final result = await commentRepository.addComment(
      postId: event.postId,
      content: event.content,
      authorId: event.authorId,
    );
    result.fold((failure) => emit(CommentError(failure.message)), (comment) {
      if (!_allComments.any((c) => c.id == comment.id)) {
        _allComments = [..._allComments, comment];
      }
      emit(CommentAdded(comment));
      emit(CommentsLoaded(List.from(_allComments)));
    });
  }

  Future<void> _onDeleteComment(DeleteCommentEvent event, Emitter<CommentState> emit) async {
    final result = await commentRepository.deleteComment(event.commentId);
    result.fold((failure) => emit(CommentError(failure.message)), (_) {
      _allComments = _allComments.where((c) => c.id != event.commentId).toList();
      emit(CommentDeleted());
      emit(CommentsLoaded(List.from(_allComments)));
    });
  }

  void _startCommentLiveFeed(String postId) {
    _newCommentSub?.cancel();
    _deletedCommentSub?.cancel();

    _newCommentSub = commentRepository.watchNewComments(postId: postId).listen((either) {
      either.fold((_) => null, (comment) {
        add(NewCommentReceivedEvent(comment));
      });
    });

    _deletedCommentSub = commentRepository.watchDeletedComments(postId: postId).listen((either) {
      either.fold((_) => null, (id) {
        add(CommentRemovedEvent(id));
      });
    });
  }

  void _onNewCommentReceived(NewCommentReceivedEvent event, Emitter<CommentState> emit) {
    if (state is! CommentsLoaded) return;

    final alreadyThere = _allComments.any((c) => c.id == event.comment.id);
    if (alreadyThere) return;

    _allComments = [..._allComments, event.comment];
    emit(CommentsLoaded(List.from(_allComments)));
  }

  void _onCommentRemoved(CommentRemovedEvent event, Emitter<CommentState> emit) {
    if (state is! CommentsLoaded) return;

    final exists = _allComments.any((c) => c.id == event.commentId);
    if (!exists) return;

    _allComments = _allComments.where((c) => c.id != event.commentId).toList();
    emit(CommentsLoaded(List.from(_allComments)));
  }

  @override
  Future<void> close() {
    _newCommentSub?.cancel();
    _deletedCommentSub?.cancel();
    return super.close();
  }
}
