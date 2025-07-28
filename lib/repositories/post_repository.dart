import '../models/post_model.dart';
import 'api/post_api.dart';

class PostRepository {
  static final PostRepository _instance = PostRepository._internal();
  factory PostRepository() => _instance;
  PostRepository._internal();

  final PostApi _postApi = PostApi();

  Future<PostModel> createPost(CreatePostRequest request) async {
    try {
      return await _postApi.createPost(request);
    } catch (e) {
      throw PostRepositoryException('投稿の作成に失敗しました: ${e.toString()}');
    }
  }

  Future<List<PostModel>> getPosts({
    int? page,
    int? limit,
    double? latitude,
    double? longitude,
    double? radius,
  }) async {
    try {
      return await _postApi.getPosts(
        page: page,
        limit: limit,
        latitude: latitude,
        longitude: longitude,
        radius: radius,
      );
    } catch (e) {
      throw PostRepositoryException('投稿の取得に失敗しました: ${e.toString()}');
    }
  }

  Future<PostModel> getPost(String postId) async {
    try {
      return await _postApi.getPost(postId);
    } catch (e) {
      throw PostRepositoryException('投稿の取得に失敗しました: ${e.toString()}');
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _postApi.deletePost(postId);
    } catch (e) {
      throw PostRepositoryException('投稿の削除に失敗しました: ${e.toString()}');
    }
  }

  Future<List<PostModel>> getPostsByLocation({
    required double latitude,
    required double longitude,
    double radius = 10.0,
    int page = 1,
    int limit = 20,
  }) async {
    return await getPosts(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      page: page,
      limit: limit,
    );
  }

  Future<List<PostModel>> getRecentPosts({
    int page = 1,
    int limit = 20,
  }) async {
    return await getPosts(
      page: page,
      limit: limit,
    );
  }
}

class PostRepositoryException implements Exception {
  final String message;
  PostRepositoryException(this.message);
  
  @override
  String toString() => message;
}