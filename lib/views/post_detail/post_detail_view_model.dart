import 'package:flutter/material.dart';
import 'package:omohide_map_flutter/models/post_model.dart';
import 'package:omohide_map_flutter/repositories/api/post.dart';

class PostDetailViewModel extends ChangeNotifier {
  final String postId;
  final PostRepository _postRepository = PostRepository();
  bool _isDisposed = false;

  PostDetailViewModel(this.postId);

  PostModel? _post;
  bool _isLoading = false;
  String? _errorMessage;

  PostModel? get post => _post;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> fetchPost() async {
    if (_isDisposed) return;
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _post = await _postRepository.getPost(postId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      if (!_isDisposed) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}