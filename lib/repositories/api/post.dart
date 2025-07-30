import 'package:dio/dio.dart';
import '../../models/post_model.dart';
import '../api.dart';

// 投稿API
// httpリクエストのpostではないので注意
class PostRepository {
  static final PostRepository _instance = PostRepository._internal();
  factory PostRepository() => _instance;
  PostRepository._internal();

  Future<PostModel> createPost(CreatePostRequest request) async {
    try {
      final response = await postApi<Map<String, dynamic>>(
        '/api/posts',
        data: request.toJson(),
        timeout: const Duration(seconds: 30), // 画像アップロードのため長めに設定
      );

      if (response.data == null || response.statusCode != 201) {
        throw Exception('投稿の作成に失敗しました');
      }

      return PostModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw Exception('投稿の作成に失敗しました: ${e.toString()}');
    } catch (e) {
      throw Exception('投稿の作成に失敗しました: ${e.toString()}');
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
      final queryParameters = <String, dynamic>{};
      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;
      if (latitude != null) queryParameters['latitude'] = latitude;
      if (longitude != null) queryParameters['longitude'] = longitude;
      if (radius != null) queryParameters['radius'] = radius;

      final response = await getApi<List<dynamic>>(
        '/api/posts',
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );

      if (response.data == null || response.statusCode != 200) {
        return [];
      }

      return response.data!
          .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('投稿の取得に失敗しました: ${e.toString()}');
    } catch (e) {
      throw Exception('投稿の取得に失敗しました: ${e.toString()}');
    }
  }

  Future<PostModel> getPost(String postId) async {
    try {
      final response = await getApi<Map<String, dynamic>>('/api/posts/$postId');

      if (response.data == null || response.statusCode != 200) {
        throw Exception('投稿が見つかりません');
      }

      return PostModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw Exception('投稿の取得に失敗しました: ${e.toString()}');
    } catch (e) {
      throw Exception('投稿の取得に失敗しました: ${e.toString()}');
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await deleteApi(
        '/api/posts/$postId',
      );
    } on DioException catch (e) {
      throw Exception('投稿の削除に失敗しました: ${e.toString()}');
    } catch (e) {
      throw Exception('投稿の削除に失敗しました: ${e.toString()}');
    }
  }
}
