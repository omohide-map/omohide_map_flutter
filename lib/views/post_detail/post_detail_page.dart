import 'package:flutter/material.dart';
import 'package:omohide_map_flutter/models/post_model.dart';
import 'package:omohide_map_flutter/views/post_detail/post_detail_view_model.dart';
import 'package:provider/provider.dart';

class PostDetailPage extends StatelessWidget {
  final String postId;

  const PostDetailPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PostDetailViewModel(postId)..fetchPost(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('投稿詳細'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: const _PostDetailBody(),
      ),
    );
  }
}

class _PostDetailBody extends StatelessWidget {
  const _PostDetailBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PostDetailViewModel>();

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
              onPressed: () => viewModel.fetchPost(),
              child: const Text('再試行'),
            ),
          ],
        ),
      );
    }

    if (viewModel.post == null) {
      return const Center(
        child: Text('投稿が見つかりません'),
      );
    }

    return _PostDetailContent(post: viewModel.post!);
  }
}

class _PostDetailContent extends StatelessWidget {
  final PostModel post;

  const _PostDetailContent({required this.post});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post.text.isNotEmpty) ...[
            Text(
              post.text,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
          ],
          if (post.imageUrls.isNotEmpty) ...[
            _ImageCarousel(imageUrls: post.imageUrls),
            const SizedBox(height: 16),
          ],
          _LocationInfo(
            latitude: post.latitude,
            longitude: post.longitude,
          ),
          const SizedBox(height: 16),
          _DateInfo(createdAt: post.createdAt),
        ],
      ),
    );
  }
}

class _ImageCarousel extends StatelessWidget {
  final List<String> imageUrls;

  const _ImageCarousel({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    if (imageUrls.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrls.first,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 250,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.error),
            );
          },
        ),
      );
    }

    return SizedBox(
      height: 250,
      child: PageView.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrls[index],
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.error),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LocationInfo extends StatelessWidget {
  final double latitude;
  final double longitude;

  const _LocationInfo({
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_on,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '位置情報',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                '緯度: ${latitude.toStringAsFixed(6)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '経度: ${longitude.toStringAsFixed(6)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DateInfo extends StatelessWidget {
  final DateTime createdAt;

  const _DateInfo({required this.createdAt});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.schedule,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '投稿日時',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                '${createdAt.year}年${createdAt.month}月${createdAt.day}日',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}