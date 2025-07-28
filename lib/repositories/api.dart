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
