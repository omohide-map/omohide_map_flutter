import 'package:flutter/material.dart';
import 'package:omohide_map_flutter/models/post_model.dart';
import 'package:omohide_map_flutter/repositories/api/post.dart';

class PostsListViewModel extends ChangeNotifier {
  final PostRepository _postRepository = PostRepository();

  List<PostModel> _posts = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false;

  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> fetchPosts() async {
    if (_isDisposed) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _posts = await _postRepository.getMyPosts();
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
