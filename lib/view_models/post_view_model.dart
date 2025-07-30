import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:omohide_map_flutter/repositories/api/post.dart';
import '../models/post_model.dart';
import '../services/location_service.dart';
import '../services/image_service.dart';

class PostViewModel extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final ImageService _imageService = ImageService();
  final PostRepository _postRepository = PostRepository();

  final TextEditingController textController = TextEditingController();

  bool _isLoading = false;
  bool _isLocationLoading = false;
  Position? _currentPosition;
  String? _currentAddress;
  final List<ProcessedImage> _selectedImages = [];

  bool get isLoading => _isLoading;
  bool get isLocationLoading => _isLocationLoading;
  Position? get currentPosition => _currentPosition;
  String? get currentAddress => _currentAddress;
  List<ProcessedImage> get selectedImages => _selectedImages;

  bool get canPost =>
      textController.text.trim().isNotEmpty &&
      textController.text.trim().length <= 256 &&
      _currentPosition != null &&
      !_isLoading;

  int get remainingTextCount => 256 - textController.text.length;
  bool get isTextValid =>
      textController.text.trim().isNotEmpty &&
      textController.text.length <= 256;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setLocationLoading(bool loading) {
    _isLocationLoading = loading;
    notifyListeners();
  }

  Future<void> getCurrentLocation() async {
    _setLocationLoading(true);

    try {
      final position = await _locationService.getCurrentLocation();
      if (position != null) {
        _currentPosition = position;
        _currentAddress = await _locationService.getAddressFromCoordinates(
          position.latitude,
          position.longitude,
        );
      }
    } finally {
      _setLocationLoading(false);
    }
  }

  Future<void> setPosition(Position position) async {
    _setLocationLoading(true);

    try {
      _currentPosition = position;
      _currentAddress = await _locationService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );
    } finally {
      _setLocationLoading(false);
    }
  }

  Future<void> pickImagesFromGallery() async {
    try {
      final remainingSlots =
          ImageService.maxImageCount - _selectedImages.length;
      if (remainingSlots <= 0) {
        return;
      }

      final images = await _imageService.pickImagesFromGallery();

      if (images.length > remainingSlots) {
        return;
      }

      _selectedImages.addAll(images);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> takePhoto() async {
    try {
      if (_selectedImages.length >= ImageService.maxImageCount) {
        return;
      }

      final image = await _imageService.takePhoto();
      if (image != null) {
        _selectedImages.add(image);
        notifyListeners();
      }
    } catch (e) {
      return;
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < _selectedImages.length) {
      _selectedImages.removeAt(index);
      notifyListeners();
    }
  }

  void clearImages() {
    _selectedImages.clear();
    notifyListeners();
  }

  void onTextChanged() {
    notifyListeners();
  }

  void reset() {
    textController.clear();
    _selectedImages.clear();
    _currentPosition = null;
    _currentAddress = null;
    _isLoading = false;
    _isLocationLoading = false;
    notifyListeners();
  }

  Future<PostModel> submitPost() async {
    if (!canPost) throw Exception('投稿できません');
    _setLoading(true);

    try {
      final request = CreatePostRequest(
        text: textController.text.trim(),
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        images: _selectedImages.map((img) => img.base64Data).toList(),
      );

      final result = await _postRepository.createPost(request);
      reset();
      return result;
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
}
