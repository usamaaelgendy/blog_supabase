import 'package:blog_app/core/di/injection_container.dart';
import 'package:blog_app/features/auth/presentation/bloc/session/session_bloc.dart';
import 'package:blog_app/features/auth/presentation/bloc/session/session_state.dart';
import 'package:blog_app/features/blog/domain/entities/post_entity.dart';
import 'package:blog_app/features/blog/presentation/bloc/post_query/post_query_bloc.dart';
import 'package:blog_app/features/blog/presentation/bloc/post_query/post_query_event.dart';
import 'package:blog_app/features/blog/presentation/bloc/post_query/post_query_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MyPostsPage extends StatelessWidget {
  const MyPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionState = context.read<SessionBloc>().state;
    final userId = sessionState is Authenticated ? sessionState.user.id : '';

    return BlocProvider(
      create: (context) => sl<PostQueryBloc>()..add(GetMyPostsEvent(userId: userId)),
      child: const MyPostsView(),
    );
  }
}

class MyPostsView extends StatelessWidget {
  const MyPostsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Posts')),
      body: BlocBuilder<PostQueryBloc, PostQueryState>(
        builder: (context, state) {
          if (state is PostQueryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PostQueryError) {
            return Center(child: Text(state.message));
          }
          if (state is PostsLoaded) {
            if (state.posts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit_note, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text("You haven't written any posts yet", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts[index];
                return _MyPostCard(post: post);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _MyPostCard extends StatelessWidget {
  final PostEntity post;

  const _MyPostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: post.imageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(post.imageUrl!, width: 60, height: 60, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(width: 60, height: 60, color: Colors.grey[300], child: const Icon(Icons.image))),
              )
            : Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.article),
              ),
        title: Text(post.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(post.content, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.visibility, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text('${post.viewCount}', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(width: 12),
                Text(DateFormat.yMMMd().format(post.createdAt), style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
        onTap: () => Navigator.of(context).pushNamed('/post-detail', arguments: post.id),
      ),
    );
  }
}
