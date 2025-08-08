import 'package:flutter/material.dart';
import 'package:omohide_map_flutter/models/image_model.dart';
import '../../../services/image_service.dart';

class ImageSection extends StatelessWidget {
  const ImageSection({
    super.key,
    required this.images,
    required this.onPickImagesFromGallery,
    required this.onTakePhoto,
    required this.onClearImages,
    required this.onRemoveImage,
  });

  final List<ProcessedImage> images;
  final void Function() onPickImagesFromGallery;
  final void Function() onTakePhoto;
  final void Function() onClearImages;
  final void Function(int index) onRemoveImage;

  @override
  Widget build(BuildContext context) {
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
              '${images.length}/${ImageService.maxImageCount}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _ImageGrid(
          images: images,
          onRemoveImage: onRemoveImage,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onPickImagesFromGallery,
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
                onPressed: onTakePhoto,
                icon: const Icon(Icons.camera_alt, size: 16),
                label: const Text('カメラ'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            if (images.isNotEmpty) ...[
              const SizedBox(width: 12),
              IconButton(
                onPressed: onClearImages,
                icon: const Icon(Icons.delete_outline),
                tooltip: 'すべて削除',
                color: Colors.red.shade600,
              ),
            ],
          ],
        )
      ],
    );
  }
}

class _ImageGrid extends StatelessWidget {
  const _ImageGrid({
    required this.images,
    required this.onRemoveImage,
  });

  final List<ProcessedImage> images;
  final void Function(int index) onRemoveImage;

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border:
              Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                size: 40,
                color: Colors.grey.shade500,
              ),
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
      itemCount: images.length,
      itemBuilder: (context, index) {
        final image = images[index];
        return _ImageTile(
          image: image,
          onRemoveImage: () => onRemoveImage(index),
        );
      },
    );
  }
}

class _ImageTile extends StatelessWidget {
  const _ImageTile({
    required this.image,
    required this.onRemoveImage,
  });

  final ProcessedImage image;
  final void Function() onRemoveImage;

  @override
  Widget build(BuildContext context) {
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
            onTap: onRemoveImage,
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
}
