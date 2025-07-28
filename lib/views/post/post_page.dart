import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/post_view_model.dart';
import 'components/image_picker_component.dart';
import 'components/location_display_component.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostViewModel>().getCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PostViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('投稿'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            Consumer<PostViewModel>(
              builder: (context, viewModel, child) {
                return TextButton(
                  onPressed: viewModel.canPost ? () => _showPostConfirmation(context, viewModel) : null,
                  child: Text(
                    '投稿',
                    style: TextStyle(
                      color: viewModel.canPost ? Theme.of(context).primaryColor : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Consumer<PostViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextInput(viewModel),
                  const SizedBox(height: 16),
                  const LocationDisplayComponent(),
                  const SizedBox(height: 16),
                  const ImagePickerComponent(),
                  const SizedBox(height: 16),
                  if (viewModel.errorMessage != null) _buildErrorMessage(viewModel),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextInput(PostViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: viewModel.textController,
            maxLength: 256,
            maxLines: 5,
            onChanged: (_) => viewModel.onTextChanged(),
            decoration: const InputDecoration(
              hintText: '今何をしていますか？',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12),
              counterText: '',
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '文字数: ${viewModel.textController.text.length}/256',
              style: TextStyle(
                fontSize: 12,
                color: viewModel.isTextValid ? Colors.grey : Colors.red,
              ),
            ),
            if (!viewModel.isTextValid)
              const Text(
                '1文字以上256文字以下で入力してください',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildErrorMessage(PostViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              viewModel.errorMessage!,
              style: TextStyle(color: Colors.red.shade700, fontSize: 14),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: viewModel.clearError,
            color: Colors.red.shade700,
          ),
        ],
      ),
    );
  }

  Future<void> _showPostConfirmation(BuildContext context, PostViewModel viewModel) async {
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
      await _submitPost(context, viewModel);
    }
  }

  Future<void> _submitPost(BuildContext context, PostViewModel viewModel) async {
    try {
      await viewModel.submitPost();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('投稿が完了しました')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('投稿に失敗しました: $e')),
        );
      }
    }
  }
}