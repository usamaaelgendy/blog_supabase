import 'package:blog_app/features/blog/domain/repositories/comment_repository.dart';
import 'package:blog_app/features/blog/presentation/bloc/comment/comment_event.dart';
import 'package:blog_app/features/blog/presentation/bloc/comment/comment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository commentRepository;

  CommentBloc({required this.commentRepository}) : super(CommentInitial()) {
    on<GetCommentsEvent>(_onGetComments);
    on<AddCommentEvent>(_onAddComment);
    on<DeleteCommentEvent>(_onDeleteComment);
  }

  Future<void> _onGetComments(GetCommentsEvent event, Emitter<CommentState> emit) async {
    emit(CommentLoading());
    final result = await commentRepository.getComments(postId: event.postId);
    result.fold(
      (failure) => emit(CommentError(failure.message)),
      (comments) => emit(CommentsLoaded(comments)),
    );
  }

  Future<void> _onAddComment(AddCommentEvent event, Emitter<CommentState> emit) async {
    emit(CommentLoading());
    final result = await commentRepository.addComment(
      postId: event.postId,
      content: event.content,
      authorId: event.authorId,
    );
    result.fold(
      (failure) => emit(CommentError(failure.message)),
      (comment) {
        emit(CommentAdded(comment));
        add(GetCommentsEvent(event.postId));
      },
    );
  }

  Future<void> _onDeleteComment(DeleteCommentEvent event, Emitter<CommentState> emit) async {
    emit(CommentLoading());
    final result = await commentRepository.deleteComment(event.commentId);
    result.fold(
      (failure) => emit(CommentError(failure.message)),
      (_) {
        emit(CommentDeleted());
        add(GetCommentsEvent(event.postId));
      },
    );
  }
}
