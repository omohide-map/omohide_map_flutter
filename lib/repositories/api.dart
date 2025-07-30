import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const apiBaseUrl = 'http://localhost:8080';

Dio createDioInstance() {
  final dio = Dio(
    BaseOptions(
      validateStatus: (status) {
        return status != null;
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Supabaseから現在のセッションを取得
        final session = Supabase.instance.client.auth.currentSession;
        final accessToken = session?.accessToken;

        // アクセストークンが存在する場合は、Authorizationヘッダーに追加
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }

        // Content-Typeが設定されていない場合は、デフォルトで設定
        options.headers['Content-Type'] ??= 'application/json';

        handler.next(options);
      },
      onError: (error, handler) {
        // 401エラーの場合は認証エラーとして処理
        if (error.response?.statusCode == 401) {
          // 必要に応じて、ここで再認証処理を実装可能
        }
        handler.next(error);
      },
    ),
  );

  return dio;
}

Future<Response<T>> getApi<T>(
  String path, {
  Map<String, dynamic>? queryParameters,
  Options? options,
  CancelToken? cancelToken,
  ProgressCallback? onReceiveProgress,
  Duration? timeout,
}) async {
  final url = '$apiBaseUrl$path';
  final dio = createDioInstance();

  try {
    final response = await dio
        .get<T>(
          url,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
        )
        .timeout(timeout ?? const Duration(seconds: 10));
    return response;
  } on DioException catch (e) {
    throw Exception(e.message);
  }
}

Future<Response<T>> postApi<T>(
  String path, {
  dynamic data,
  Map<String, dynamic>? queryParameters,
  Options? options,
  CancelToken? cancelToken,
  ProgressCallback? onSendProgress,
  ProgressCallback? onReceiveProgress,
  Duration? timeout,
}) async {
  final url = '$apiBaseUrl$path';
  final dio = createDioInstance();

  try {
    final response = await dio
        .post<T>(
          url,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        )
        .timeout(timeout ?? const Duration(seconds: 10));
    return response;
  } on DioException catch (e) {
    throw Exception(e.message);
  }
}

Future<Response<T>> putApi<T>(
  String path, {
  dynamic data,
  Map<String, dynamic>? queryParameters,
  Options? options,
  CancelToken? cancelToken,
  ProgressCallback? onSendProgress,
  ProgressCallback? onReceiveProgress,
  Duration? timeout,
}) async {
  final url = '$apiBaseUrl$path';
  final dio = createDioInstance();

  try {
    final response = await dio
        .put<T>(
          url,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        )
        .timeout(timeout ?? const Duration(seconds: 10));
    return response;
  } on DioException catch (e) {
    throw Exception(e.message);
  }
}

Future<Response<T>> deleteApi<T>(
  String path, {
  dynamic data,
  Map<String, dynamic>? queryParameters,
  Options? options,
  CancelToken? cancelToken,
  Duration? timeout,
}) async {
  final url = '$apiBaseUrl$path';
  final dio = createDioInstance();

  try {
    final response = await dio
        .delete<T>(
          url,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        )
        .timeout(timeout ?? const Duration(seconds: 10));
    return response;
  } on DioException catch (e) {
    throw Exception(e.message);
  }
}
