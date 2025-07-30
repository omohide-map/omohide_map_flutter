import 'package:flutter/material.dart';
import 'package:omohide_map_flutter/view_models/post_view_model.dart';
import 'package:provider/provider.dart';

class PostButton extends StatelessWidget {
  const PostButton({
    super.key,
    required this.onSubmit,
  });

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PostViewModel>();
    return TextButton(
      onPressed: viewModel.canPost
          ? () => _showPostConfirmation(context, viewModel)
          : null,
      child: Text(
        '投稿',
        style: TextStyle(
          color:
              viewModel.canPost ? Theme.of(context).primaryColor : Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _showPostConfirmation(
    BuildContext context,
    PostViewModel viewModel,
  ) async {
    final shouldPost = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('投稿確認'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('以下の内容で投稿しますか？'),
            const SizedBox(height: 16),
            Text('テキスト: ${viewModel.textController.text.trim()}'),
            if (viewModel.currentAddress != null)
              Text('場所: ${viewModel.currentAddress}'),
            if (viewModel.selectedImages.isNotEmpty)
              Text('画像: ${viewModel.selectedImages.length}枚'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('投稿'),
          ),
        ],
      ),
    );

    if (shouldPost == true && context.mounted) {
      onSubmit();
    }
  }
}
