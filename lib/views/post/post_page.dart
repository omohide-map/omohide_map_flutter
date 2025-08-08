import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:omohide_map_flutter/constants/routes.dart';
import 'package:omohide_map_flutter/models/image_model.dart';
import 'package:omohide_map_flutter/views/post/components/post_button.dart';
import 'package:omohide_map_flutter/views/post/sections/text_section.dart';
import 'package:provider/provider.dart';
import 'post_view_model.dart';
import 'sections/image_section.dart';
import 'sections/location_section.dart';

class PostPage extends HookWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PostViewModel>();

    final textController = useTextEditingController();
    final position = useState<Position?>(null);
    final address = useState<String?>(null);
    final images = useState<List<ProcessedImage>>([]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('投稿'),
        actions: [
          PostButton(
            text: textController.text,
            address: address.value,
            position: position.value,
            images: images.value,
            onSubmit: () async {
              try {
                await viewModel.submitPost(
                  textController.text,
                  position.value,
                  images.value,
                );

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('投稿が完了しました')),
                  );
                  context.push(Routes.main);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('投稿に失敗しました: $e')),
                  );
                }
              }
            },
            canPost: viewModel.isValidPost(
              textController.text,
              position.value,
              images.value,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextSection(textController: textController),
            LocationSection(
              position: position,
              address: address,
              onRefetch: () async {
                final result = await viewModel.getCurrentLocation();
                position.value = result.$1;
                address.value = result.$2;
              },
              isLocationPermissionGranted:
                  viewModel.isLocationPermissionGranted,
              openLocationSettings: viewModel.openLocationSettings,
            ),
            ImageSection(
              images: images.value,
              onPickImagesFromGallery: () async {
                images.value = await viewModel.pickImagesFromGallery(
                  images.value,
                );
              },
              onTakePhoto: () async {
                images.value = await viewModel.takePhoto(images.value);
              },
              onClearImages: () {
                images.value = [];
              },
              onRemoveImage: (index) {
                images.value = List.from(images.value)..removeAt(index);
              },
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
