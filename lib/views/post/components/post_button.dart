import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:omohide_map_flutter/models/image_model.dart';

class PostButton extends StatelessWidget {
  const PostButton({
    super.key,
    required this.text,
    required this.address,
    required this.position,
    required this.images,
    required this.onSubmit,
    required this.canPost,
  });

  final String text;
  final String? address;
  final Position? position;
  final List<ProcessedImage> images;
  final VoidCallback onSubmit;
  final bool canPost;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: canPost ? () => _showPostConfirmation(context) : null,
      child: Text(
        '投稿',
        style: TextStyle(
          color: canPost ? Theme.of(context).primaryColor : Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _showPostConfirmation(BuildContext context) async {
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
            Text('テキスト: $text'),
            Text('場所: $address'),
            if (images.isNotEmpty) Text('画像: ${images.length}枚'),
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
