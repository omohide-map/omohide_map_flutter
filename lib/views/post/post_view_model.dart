import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:omohide_map_flutter/models/image_model.dart';
import 'package:omohide_map_flutter/repositories/api/post.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/post_model.dart';
import '../../services/image_service.dart';
import '../../services/location_service.dart';

class PostViewModel extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final ImageService _imageService = ImageService();
  final PostRepository _postRepository = PostRepository();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isLocationPermissionGranted = false; // 位置情報許可
  bool _isLocationPermissionPermanentlyDenied = false; // 永久的に拒否された

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLocationPermissionGranted => _isLocationPermissionGranted;
  bool get isLocationPermissionPermanentlyDenied =>
      _isLocationPermissionPermanentlyDenied;

// 位置情報
  Future<(Position?, String?)> getCurrentLocation() async {
    try {
      await _updatePermissionStatus();
      _errorMessage = null;

      final position = await _locationService.getCurrentLocation();
      if (position != null) {
        final address = await _locationService.getAddressFromCoordinates(
          position.latitude,
          position.longitude,
        );
        return (position, address);
      }
      return (null, null);
    } catch (e) {
      _errorMessage = e.toString();
      await _updatePermissionStatus();
      return (null, null);
    }
  }

  Future<void> _updatePermissionStatus() async {
    final status = await Permission.locationWhenInUse.status;
    _isLocationPermissionGranted = status.isGranted;
    _isLocationPermissionPermanentlyDenied = status.isPermanentlyDenied;
    notifyListeners();
  }

  Future<void> openLocationSettings() async {
    await openAppSettings();
    await _updatePermissionStatus();
    if (_isLocationPermissionGranted) {
      await getCurrentLocation();
    }
  }

  // 画像
  Future<List<ProcessedImage>> pickImagesFromGallery(
    List<ProcessedImage> selectedImages,
  ) async {
    try {
      final remainingSlots = ImageService.maxImageCount - selectedImages.length;
      if (remainingSlots <= 0) {
        return selectedImages;
      }

      final images = await _imageService.pickImagesFromGallery();

      if (images.length > remainingSlots) {
        return selectedImages;
      }

      return [...selectedImages, ...images];
    } catch (e) {
      _errorMessage = e.toString();
      return selectedImages;
    }
  }

  Future<List<ProcessedImage>> takePhoto(
    List<ProcessedImage> selectedImages,
  ) async {
    try {
      if (selectedImages.length >= ImageService.maxImageCount) {
        return selectedImages;
      }

      final image = await _imageService.takePhoto();
      if (image != null) {
        return [...selectedImages, image];
      }
      return selectedImages;
    } catch (e) {
      _errorMessage = e.toString();
      return selectedImages;
    }
  }

  // 投稿
  Future<PostModel> submitPost(
    String text,
    Position? position,
    List<ProcessedImage> images,
  ) async {
    _isLoading = true;
    notifyListeners();

    if (isValidPost(text, position, images) || position == null) {
      throw Exception('投稿できません');
    }

    try {
      final request = CreatePostRequest(
        text: text,
        latitude: position.latitude,
        longitude: position.longitude,
        images: images.map((img) => img.base64Data).toList(),
      );

      final result = await _postRepository.createPost(request);
      return result;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isValidPost(
      String text, Position? position, List<ProcessedImage> images) {
    if (text.trim().isEmpty || text.trim().length > 256) return false;
    if (position == null) return false;
    if (images.length > 4) return false;
    return true;
  }
}
