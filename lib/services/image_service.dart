import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'dart:ui' as ui;

class ImageService {
  static final ImageService _instance = ImageService._internal();
  factory ImageService() => _instance;
  ImageService._internal();

  final ImagePicker _picker = ImagePicker();
  static const int maxImageCount = 4;
  static const int maxFileSizeBytes = 5 * 1024 * 1024; // 5MB
  static const int targetWidth = 1080;
  static const int targetHeight = 1080;

  Future<List<ProcessedImage>> pickImagesFromGallery() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: targetWidth.toDouble(),
        maxHeight: targetHeight.toDouble(),
        imageQuality: 85,
      );

      if (images.length > maxImageCount) {
        throw ImageServiceException('画像は$maxImageCount枚まで選択できます');
      }

      return await _processImages(images);
    } catch (e) {
      if (e is ImageServiceException) {
        rethrow;
      }
      throw ImageServiceException('ギャラリーからの画像選択に失敗しました: ${e.toString()}');
    }
  }

  Future<ProcessedImage?> takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: targetWidth.toDouble(),
        maxHeight: targetHeight.toDouble(),
        imageQuality: 85,
      );

      if (image == null) return null;

      final processedImages = await _processImages([image]);
      return processedImages.isNotEmpty ? processedImages.first : null;
    } catch (e) {
      throw ImageServiceException('写真撮影に失敗しました: ${e.toString()}');
    }
  }

  Future<List<ProcessedImage>> _processImages(List<XFile> images) async {
    final List<ProcessedImage> processedImages = [];

    for (final image in images) {
      try {
        final processedImage = await _processImage(image);
        processedImages.add(processedImage);
      } catch (e) {
        throw ImageServiceException('画像の処理に失敗しました: ${e.toString()}');
      }
    }

    return processedImages;
  }

  Future<ProcessedImage> _processImage(XFile image) async {
    final File file = File(image.path);
    final int fileSize = await file.length();

    if (fileSize > maxFileSizeBytes) {
      throw ImageServiceException('画像サイズが大きすぎます (最大5MB)');
    }

    // EXIF情報を削除
    final Uint8List imageBytes = await _removeExifData(file);

    // Base64エンコード
    final String base64String = base64Encode(imageBytes);

    // MIMEタイプを取得
    final String? mimeType = lookupMimeType(image.path);

    return ProcessedImage(
      base64Data: base64String,
      mimeType: mimeType ?? 'image/jpeg',
      originalFileName: image.name,
      fileSizeBytes: imageBytes.length,
    );
  }

  Future<Uint8List> _removeExifData(File imageFile) async {
    try {
      // 簡易EXIF削除: 元のファイルのbytesを返すが、将来的にはEXIF削除処理を実装
      return await imageFile.readAsBytes();
    } catch (e) {
      // エラーが発生した場合は元のファイルを使用
      return await imageFile.readAsBytes();
    }
  }

  Future<ui.Image> decodeImage(Uint8List bytes) async {
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  bool isValidImageType(String? mimeType) {
    if (mimeType == null) return false;
    return ['image/jpeg', 'image/png', 'image/jpg']
        .contains(mimeType.toLowerCase());
  }

  String formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
}

class ProcessedImage {
  final String base64Data;
  final String mimeType;
  final String originalFileName;
  final int fileSizeBytes;

  ProcessedImage({
    required this.base64Data,
    required this.mimeType,
    required this.originalFileName,
    required this.fileSizeBytes,
  });

  String get dataUrl => 'data:$mimeType;base64,$base64Data';

  Uint8List get bytes => base64Decode(base64Data);

  String get formattedSize {
    if (fileSizeBytes < 1024) return '${fileSizeBytes}B';
    if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)}KB';
    }
    return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  @override
  String toString() {
    return 'ProcessedImage(fileName: $originalFileName, mimeType: $mimeType, size: $formattedSize)';
  }
}

class ImageServiceException implements Exception {
  final String message;
  ImageServiceException(this.message);

  @override
  String toString() => message;
}
