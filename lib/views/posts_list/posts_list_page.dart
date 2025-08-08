import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omohide_map_flutter/models/post_model.dart';
import 'package:omohide_map_flutter/views/posts_list/posts_list_view_model.dart';
import 'package:provider/provider.dart';

class PostsListPage extends StatelessWidget {
  const PostsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('投稿一覧'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const _PostsListBody(),
    );
  }
}

class _PostsListBody extends StatelessWidget {
  const _PostsListBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PostsListViewModel>();

    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'エラー: ${viewModel.errorMessage}',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => viewModel.fetchPosts(),
              child: const Text('再試行'),
            ),
          ],
        ),
      );
    }

    if (viewModel.posts.isEmpty) {
      return const Center(
        child: Text('投稿がありません'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: viewModel.posts.length,
      itemBuilder: (context, index) {
        final post = viewModel.posts[index];
        return _PostCard(
          post: post,
          onTap: () => context.push('/post-detail/${post.id}'),
        );
      },
    );
  }
}

class _PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback onTap;

  const _PostCard({
    required this.post,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (post.text.isNotEmpty) ...[
                Text(
                  post.text,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
              ],
              if (post.imageUrls.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    post.imageUrls.first,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        child: const Icon(Icons.error),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${post.latitude.toStringAsFixed(6)}, ${post.longitude.toStringAsFixed(6)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
