import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/post_model.dart';
import '../api.dart';

class PostApi {
  static final PostApi _instance = PostApi._internal();
  factory PostApi() => _instance;
  PostApi._internal();

  Future<PostModel> createPost(CreatePostRequest request) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw PostApiException('ユーザーが認証されていません');
      }

      final session = Supabase.instance.client.auth.currentSession;
      final accessToken = session?.accessToken;
      if (accessToken == null) {
        throw PostApiException('アクセストークンが取得できません');
      }

      final response = await postApi<Map<String, dynamic>>(
        '/api/posts',
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
        timeout: const Duration(seconds: 30), // 画像アップロードのため長めに設定
      );

      if (response.data == null) {
        throw PostApiException('レスポンスデータが空です');
      }

      return PostModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw PostApiException('投稿の作成に失敗しました: ${e.toString()}');
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

      if (response.data == null) {
        return [];
      }

      return response.data!
          .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw PostApiException('投稿の取得に失敗しました: ${e.toString()}');
    }
  }

  Future<PostModel> getPost(String postId) async {
    try {
      final response = await getApi<Map<String, dynamic>>('/api/posts/$postId');

      if (response.data == null) {
        throw PostApiException('投稿が見つかりません');
      }

      return PostModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw PostApiException('投稿の取得に失敗しました: ${e.toString()}');
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw PostApiException('ユーザーが認証されていません');
      }

      final session = Supabase.instance.client.auth.currentSession;
      final accessToken = session?.accessToken;
      if (accessToken == null) {
        throw PostApiException('アクセストークンが取得できません');
      }

      await deleteApi(
        '/api/posts/$postId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw PostApiException('投稿の削除に失敗しました: ${e.toString()}');
    }
  }

  PostApiException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return PostApiException('通信がタイムアウトしました');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? e.message;
        switch (statusCode) {
          case 400:
            return PostApiException('リクエストが無効です: $message');
          case 401:
            return PostApiException('認証が必要です');
          case 403:
            return PostApiException('アクセスが拒否されました');
          case 404:
            return PostApiException('リソースが見つかりません');
          case 413:
            return PostApiException('ファイルサイズが大きすぎます');
          case 422:
            return PostApiException('バリデーションエラー: $message');
          case 500:
            return PostApiException('サーバーエラーが発生しました');
          default:
            return PostApiException('HTTPエラー($statusCode): $message');
        }
      case DioExceptionType.cancel:
        return PostApiException('リクエストがキャンセルされました');
      case DioExceptionType.unknown:
        if (e.error.toString().contains('SocketException')) {
          return PostApiException('ネットワークに接続できません');
        }
        return PostApiException('不明なエラーが発生しました: ${e.message}');
      default:
        return PostApiException('通信エラーが発生しました: ${e.message}');
    }
  }
}

class PostApiException implements Exception {
  final String message;
  PostApiException(this.message);
  
  @override
  String toString() => message;
}