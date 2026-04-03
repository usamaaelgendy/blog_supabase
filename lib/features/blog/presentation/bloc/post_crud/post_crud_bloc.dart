import 'package:blog_app/features/blog/domain/repositories/post_crud_repository.dart';
import 'package:blog_app/features/blog/presentation/bloc/post_crud/post_crud_event.dart';
import 'package:blog_app/features/blog/presentation/bloc/post_crud/post_crud_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostCrudBloc extends Bloc<PostCrudEvent, PostCrudState> {
  final PostCrudRepository postCrudRepository;

  PostCrudBloc({required this.postCrudRepository}) : super(PostCrudInitial()) {
    on<CreatePostEvent>(_onCreatePost);
    on<GetPostByIdEvent>(_onGetPostById);
    on<UpdatePostEvent>(_onUpdatePost);
    on<DeletePostEvent>(_onDeletePost);
  }

  Future<void> _onCreatePost(CreatePostEvent event, Emitter<PostCrudState> emit) async {
    emit(PostCrudLoading());
    final result = await postCrudRepository.createPost(
      title: event.title,
      content: event.content,
      authorId: event.authorId,
      imageUrl: event.imagePath,
      category: event.category,
    );
    result.fold(
      (failure) => emit(PostCrudError(failure.message)),
      (post) => emit(PostCreated(post)),
    );
  }

  Future<void> _onGetPostById(GetPostByIdEvent event, Emitter<PostCrudState> emit) async {
    emit(PostCrudLoading());
    final result = await postCrudRepository.getPostById(event.postId);
    result.fold(
      (failure) => emit(PostCrudError(failure.message)),
      (post) => emit(PostLoaded(post)),
    );
  }

  Future<void> _onUpdatePost(UpdatePostEvent event, Emitter<PostCrudState> emit) async {
    emit(PostCrudLoading());
    final result = await postCrudRepository.updatePost(
      id: event.id,
      title: event.title,
      content: event.content,
      imageUrl: event.imagePath,
      category: event.category,
    );
    result.fold(
      (failure) => emit(PostCrudError(failure.message)),
      (post) => emit(PostUpdated(post)),
    );
  }

  Future<void> _onDeletePost(DeletePostEvent event, Emitter<PostCrudState> emit) async {
    emit(PostCrudLoading());
    final result = await postCrudRepository.deletePost(event.postId);
    result.fold(
      (failure) => emit(PostCrudError(failure.message)),
      (_) => emit(PostDeleted()),
    );
  }
}
