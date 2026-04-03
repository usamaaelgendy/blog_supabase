import 'package:blog_app/core/di/injection_container.dart';
import 'package:blog_app/features/blog/domain/entities/post_entity.dart';
import 'package:blog_app/features/blog/presentation/bloc/post_query/post_query_bloc.dart';
import 'package:blog_app/features/blog/presentation/bloc/post_query/post_query_event.dart';
import 'package:blog_app/features/blog/presentation/bloc/post_query/post_query_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PostsListPage extends StatelessWidget {
  const PostsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PostQueryBloc>()..add(const GetPostsEvent()),
      child: const PostsListView(),
    );
  }
}

class PostsListView extends StatefulWidget {
  const PostsListView({super.key});

  @override
  State<PostsListView> createState() => _PostsListViewState();
}

class _PostsListViewState extends State<PostsListView> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<PostQueryBloc>().state;
      if (state is PostsLoaded && state.hasMore) {
        context.read<PostQueryBloc>().add(const LoadMorePostsEvent());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Search posts...', border: InputBorder.none),
                onChanged: (query) {
                  context.read<PostQueryBloc>().add(SearchPostsEvent(query));
                },
              )
            : const Text('Blog'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  context.read<PostQueryBloc>().add(const GetPostsEvent());
                }
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<PostQueryBloc, PostQueryState>(
        builder: (context, state) {
          if (state is PostQueryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PostQueryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 16),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.read<PostQueryBloc>().add(const GetPostsEvent()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is PostsLoaded) {
            if (state.posts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.article_outlined, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text('No posts yet', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey)),
                    const SizedBox(height: 8),
                    const Text('Be the first to create a post!'),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<PostQueryBloc>().add(const RefreshPostsEvent());
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: state.posts.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.posts.length) {
                    return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
                  }
                  return _PostCard(post: state.posts[index]);
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('/create-post'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final PostEntity post;

  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed('/post-detail', arguments: post.id),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  post.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.image, size: 64, color: Colors.grey),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (post.category != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Chip(
                        label: Text(post.category!, style: const TextStyle(fontSize: 12)),
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  Text(post.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    post.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: post.author?.avatarUrl != null ? NetworkImage(post.author!.avatarUrl!) : null,
                        child: post.author?.avatarUrl == null ? const Icon(Icons.person, size: 16) : null,
                      ),
                      const SizedBox(width: 8),
                      Text(post.author?.name ?? 'Unknown', style: Theme.of(context).textTheme.bodySmall),
                      const Spacer(),
                      Icon(Icons.visibility, size: 16, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text('${post.viewCount}', style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(width: 12),
                      Icon(Icons.access_time, size: 16, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(DateFormat.yMMMd().format(post.createdAt), style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
