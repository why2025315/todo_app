import 'package:dio/dio.dart';

enum ApiErrorType { network, server, unauthorized, notFound, validation, other }

class ApiError {
  final ApiErrorType type;
  final String message;
  final int? statusCode;

  ApiError({required this.type, required this.message, this.statusCode});

  factory ApiError.fromDioException(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return ApiError(
        type: ApiErrorType.network,
        message: 'Network error occurred. Please check your connection.',
      );
    }

    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      switch (statusCode) {
        case 401:
          return ApiError(
            type: ApiErrorType.unauthorized,
            message: 'Unauthorized access. Please login again.',
            statusCode: statusCode,
          );
        case 404:
          return ApiError(
            type: ApiErrorType.notFound,
            message: 'Resource not found.',
            statusCode: statusCode,
          );
        case 422:
          return ApiError(
            type: ApiErrorType.validation,
            message: 'Validation error occurred.',
            statusCode: statusCode,
          );
        case 500:
        case 501:
        case 502:
        case 503:
        case 504:
          return ApiError(
            type: ApiErrorType.server,
            message: 'Server error occurred. Please try again later.',
            statusCode: statusCode,
          );
        default:
          return ApiError(
            type: ApiErrorType.other,
            message:
                e.response?.data['message'] ?? 'An unexpected error occurred.',
            statusCode: statusCode,
          );
      }
    }

    return ApiError(
      type: ApiErrorType.other,
      message: e.message ?? 'An unexpected error occurred.',
    );
  }
}
