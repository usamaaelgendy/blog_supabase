import 'package:blog_app/core/di/injection_container.dart';
import 'package:blog_app/features/auth/presentation/bloc/session/session_bloc.dart';
import 'package:blog_app/features/auth/presentation/bloc/session/session_state.dart';
import 'package:blog_app/features/blog/domain/entities/comment_entity.dart';
import 'package:blog_app/features/blog/presentation/bloc/comment/comment_bloc.dart';
import 'package:blog_app/features/blog/presentation/bloc/comment/comment_event.dart';
import 'package:blog_app/features/blog/presentation/bloc/comment/comment_state.dart';
import 'package:blog_app/features/blog/presentation/bloc/post_crud/post_crud_bloc.dart';
import 'package:blog_app/features/blog/presentation/bloc/post_crud/post_crud_event.dart';
import 'package:blog_app/features/blog/presentation/bloc/post_crud/post_crud_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PostDetailPage extends StatelessWidget {
  final String postId;

  const PostDetailPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<PostCrudBloc>()..add(GetPostByIdEvent(postId))),
        BlocProvider(create: (context) => sl<CommentBloc>()..add(GetCommentsEvent(postId))),
      ],
      child: PostDetailView(postId: postId),
    );
  }
}

class PostDetailView extends StatefulWidget {
  final String postId;

  const PostDetailView({super.key, required this.postId});

  @override
  State<PostDetailView> createState() => _PostDetailViewState();
}

class _PostDetailViewState extends State<PostDetailView> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<PostCrudBloc, PostCrudState>(
        listener: (context, state) {
          if (state is PostDeleted) {
            Navigator.of(context).pop(true);
          } else if (state is PostCrudError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is PostCrudLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PostLoaded) {
            final post = state.post;
            final sessionState = context.read<SessionBloc>().state;
            final isOwner = sessionState is Authenticated && sessionState.user.id == post.authorId;

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: post.imageUrl != null ? 300 : 0,
                  pinned: true,
                  flexibleSpace: post.imageUrl != null
                      ? FlexibleSpaceBar(
                          background: Image.network(post.imageUrl!, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(color: Theme.of(context).colorScheme.surfaceContainerHighest)),
                        )
                      : null,
                  actions: isOwner
                      ? [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => Navigator.of(context).pushNamed('/edit-post', arguments: post),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _showDeleteDialog(context),
                          ),
                        ]
                      : null,
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (post.category != null)
                          Chip(label: Text(post.category!)),
                        const SizedBox(height: 8),
                        Text(post.title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: post.author?.avatarUrl != null ? NetworkImage(post.author!.avatarUrl!) : null,
                              child: post.author?.avatarUrl == null ? const Icon(Icons.person) : null,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(post.author?.name ?? 'Unknown', style: Theme.of(context).textTheme.titleSmall),
                                Text(DateFormat.yMMMd().format(post.createdAt), style: Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                            const Spacer(),
                            Icon(Icons.visibility, size: 18, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Text('${post.viewCount}', style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                        const Divider(height: 32),
                        Text(post.content, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6)),
                        const Divider(height: 32),
                        Text('Comments', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 16),
                        _buildCommentInput(context),
                        const SizedBox(height: 16),
                        BlocBuilder<CommentBloc, CommentState>(
                          builder: (context, commentState) {
                            if (commentState is CommentLoading) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (commentState is CommentsLoaded) {
                              if (commentState.comments.isEmpty) {
                                return const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('No comments yet')));
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: commentState.comments.length,
                                itemBuilder: (context, index) => _CommentTile(
                                  comment: commentState.comments[index],
                                  postId: widget.postId,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          if (state is PostCrudError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _commentController,
            decoration: InputDecoration(
              hintText: 'Write a comment...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          onPressed: () {
            final text = _commentController.text.trim();
            if (text.isEmpty) return;
            final sessionState = context.read<SessionBloc>().state;
            if (sessionState is Authenticated) {
              context.read<CommentBloc>().add(AddCommentEvent(
                postId: widget.postId,
                content: text,
                authorId: sessionState.user.id,
              ));
              _commentController.clear();
            }
          },
          icon: const Icon(Icons.send),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<PostCrudBloc>().add(DeletePostEvent(widget.postId));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final CommentEntity comment;
  final String postId;

  const _CommentTile({required this.comment, required this.postId});

  @override
  Widget build(BuildContext context) {
    final sessionState = context.read<SessionBloc>().state;
    final isOwner = sessionState is Authenticated && sessionState.user.id == comment.authorId;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: comment.author?.avatarUrl != null ? NetworkImage(comment.author!.avatarUrl!) : null,
            child: comment.author?.avatarUrl == null ? const Icon(Icons.person, size: 16) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(comment.author?.name ?? 'Unknown', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(width: 8),
                    Text(DateFormat.yMMMd().format(comment.createdAt), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment.content),
              ],
            ),
          ),
          if (isOwner)
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              onPressed: () {
                context.read<CommentBloc>().add(DeleteCommentEvent(commentId: comment.id, postId: postId));
              },
            ),
        ],
      ),
    );
  }
}
