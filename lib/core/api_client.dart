import 'package:dio/dio.dart';

/// Base URL for the JSONPlaceholder REST API.
const String kBaseUrl = 'https://jsonplaceholder.typicode.com';

/// Creates a configured [Dio] instance for talking to JSONPlaceholder.
Dio createDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: kBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      responseType: ResponseType.json,
      headers: const {'Accept': 'application/json'},
    ),
  );
  return dio;
}

/// Turns a raw [DioException] into a short, user-readable message.
String describeDioError(Object error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'The connection timed out. Check your internet and try again.';
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode;
        return 'Server responded with an error${code != null ? ' ($code)' : ''}.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      default:
        return 'Something went wrong while loading data.';
    }
  }
  return 'Unexpected error: $error';
}
