import 'dart:convert';

import 'package:flutter/foundation.dart';

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
