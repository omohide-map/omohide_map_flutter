import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:omohide_map_flutter/views/post/components/post_button.dart';
import 'package:omohide_map_flutter/views/post/components/post_text_field.dart';
import 'package:provider/provider.dart';
import 'post_view_model.dart';
import 'components/image_picker_section.dart';
import 'components/location_display.dart';

class PostPage extends HookWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PostViewModel>();

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<PostViewModel>().getCurrentLocation();
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('投稿'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          PostButton(onSubmit: () async {
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
          }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PostTextField(),
            const SizedBox(height: 16),
            const LocationDisplay(),
            const SizedBox(height: 16),
            const ImagePickerSection(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
