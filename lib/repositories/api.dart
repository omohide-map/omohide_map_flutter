import 'package:dio/dio.dart';

const apiBaseUrl = 'http://localhost:8080';

Future<Response<T>> getApi<T>(
  String path, {
  Map<String, dynamic>? queryParameters,
  Options? options,
  CancelToken? cancelToken,
  ProgressCallback? onReceiveProgress,
  Duration? timeout,
}) async {
  final url = '$apiBaseUrl$path';
  final dio = Dio();

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
  final dio = Dio();

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
  final dio = Dio();

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
  final dio = Dio();

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
