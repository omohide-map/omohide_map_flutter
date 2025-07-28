import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../view_models/post_view_model.dart';
import '../../../services/image_service.dart';

class ImagePickerComponent extends StatelessWidget {
  const ImagePickerComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PostViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.photo, color: Colors.green.shade700, size: 20),
                const SizedBox(width: 8),
                const Text(
                  '写真',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Text(
                  '${viewModel.selectedImages.length}/${ImageService.maxImageCount}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildImageGrid(context, viewModel),
            const SizedBox(height: 12),
            _buildActionButtons(context, viewModel),
          ],
        );
      },
    );
  }

  Widget _buildImageGrid(BuildContext context, PostViewModel viewModel) {
    if (viewModel.selectedImages.isEmpty) {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_photo_alternate_outlined, 
                   size: 40, 
                   color: Colors.grey.shade500),
              const SizedBox(height: 8),
              Text(
                '写真を追加',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: viewModel.selectedImages.length,
      itemBuilder: (context, index) {
        final image = viewModel.selectedImages[index];
        return _buildImageTile(context, viewModel, image, index);
      },
    );
  }

  Widget _buildImageTile(BuildContext context, PostViewModel viewModel, ProcessedImage image, int index) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
              image.bytes,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => viewModel.removeImage(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 4,
          left: 4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              image.formattedSize,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, PostViewModel viewModel) {
    final canAddMore = viewModel.selectedImages.length < ImageService.maxImageCount;
    
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: canAddMore ? viewModel.pickImagesFromGallery : null,
            icon: const Icon(Icons.photo_library, size: 16),
            label: const Text('ギャラリー'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: canAddMore ? viewModel.takePhoto : null,
            icon: const Icon(Icons.camera_alt, size: 16),
            label: const Text('カメラ'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        if (viewModel.selectedImages.isNotEmpty) ...[
          const SizedBox(width: 12),
          IconButton(
            onPressed: viewModel.clearImages,
            icon: const Icon(Icons.delete_outline),
            tooltip: 'すべて削除',
            color: Colors.red.shade600,
          ),
        ],
      ],
    );
  }
}