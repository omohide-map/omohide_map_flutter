import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../repositories/post_repository.dart';

class PostProvider extends ChangeNotifier {
  final PostRepository _postRepository = PostRepository();

  List<PostModel> _posts = [];
  bool _isLoading = false;
  bool _isCreating = false;
  String? _errorMessage;
  bool _hasMore = true;
  int _currentPage = 1;
  static const int _pageSize = 20;

  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setCreating(bool creating) {
    _isCreating = creating;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> createPost(CreatePostRequest request) async {
    _setCreating(true);
    _setError(null);

    try {
      final newPost = await _postRepository.createPost(request);
      _posts.insert(0, newPost);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setCreating(false);
    }
  }

  Future<void> loadPosts({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _posts.clear();
    }

    if (!_hasMore) return;

    _setLoading(true);
    _setError(null);

    try {
      final newPosts = await _postRepository.getRecentPosts(
        page: _currentPage,
        limit: _pageSize,
      );

      if (newPosts.length < _pageSize) {
        _hasMore = false;
      }

      if (refresh) {
        _posts = newPosts;
      } else {
        _posts.addAll(newPosts);
      }

      _currentPage++;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadPostsByLocation({
    required double latitude,
    required double longitude,
    double radius = 10.0,
    bool refresh = false,
  }) async {
    if (_isLoading) return;

    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _posts.clear();
    }

    if (!_hasMore) return;

    _setLoading(true);
    _setError(null);

    try {
      final newPosts = await _postRepository.getPostsByLocation(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        page: _currentPage,
        limit: _pageSize,
      );

      if (newPosts.length < _pageSize) {
        _hasMore = false;
      }

      if (refresh) {
        _posts = newPosts;
      } else {
        _posts.addAll(newPosts);
      }

      _currentPage++;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _postRepository.deletePost(postId);
      _posts.removeWhere((post) => post.id == postId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  Future<PostModel?> getPost(String postId) async {
    try {
      return await _postRepository.getPost(postId);
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }

  void clearError() {
    _setError(null);
  }

  void reset() {
    _posts.clear();
    _currentPage = 1;
    _hasMore = true;
    _isLoading = false;
    _isCreating = false;
    _errorMessage = null;
    notifyListeners();
  }

  PostModel? findPostById(String postId) {
    try {
      return _posts.firstWhere((post) => post.id == postId);
    } catch (e) {
      return null;
    }
  }

  void updatePost(PostModel updatedPost) {
    final index = _posts.indexWhere((post) => post.id == updatedPost.id);
    if (index != -1) {
      _posts[index] = updatedPost;
      notifyListeners();
    }
  }
}