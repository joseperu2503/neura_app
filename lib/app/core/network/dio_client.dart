import 'package:dio/dio.dart';
import 'package:neura_app/app/core/encrypt/encrypt_service.dart';
import 'package:neura_app/app/core/environments/environments.dart';
import 'package:neura_app/app/core/storage/storage_keys.dart';
import 'package:neura_app/app/core/storage/storage_service.dart';
import 'package:neura_app/app/core/token/token_service.dart';

class DioClient {
  final Dio _dio;
  final TokenService tokenService;
  final StorageService storageService;

  DioClient({required this.tokenService, required this.storageService})
    : _dio = Dio(
        BaseOptions(
          baseUrl: '${Environments.baseUrl}/api',
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storageService.get<String>(StorageKeys.token);
          if (token != null) {
            final isValidToken = tokenService.isValid(token);
            if (isValidToken) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          if (options.data != null && Environments.encrypt) {
            options.data = await EncryptService.encrypt<dynamic>(options.data);
          }

          return handler.next(options);
        },
        onResponse: (response, handler) async {
          if (response.data != null &&
              response.data is Map<String, dynamic> &&
              Environments.encrypt) {
            try {
              response.data = await EncryptService.decrypt<dynamic>(
                response.data,
              );
            } catch (e) {
              return handler.reject(
                DioException(
                  requestOptions: response.requestOptions,
                  response: response,
                  type: DioExceptionType.badResponse,
                  error: 'Failed to decrypt response: $e',
                ),
              );
            }
          }

          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {
            return handler.next(
              e.copyWith(message: e.response?.data['message']),
            );
          }

          if (e.response?.statusCode == 400) {
            return handler.next(
              e.copyWith(message: e.response?.data['message']),
            );
          }

          return handler.next(e);
        },
      ),
    );
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get<T>(path, queryParameters: queryParameters);
  }

  Future<Response<T>> post<T>(String path, {dynamic data}) {
    return _dio.post<T>(path, data: data);
  }

  Future<Response> postStream(String path, {Object? data}) async {
    return _dio.post(
      path,
      data: data,
      options: Options(responseType: ResponseType.stream),
    );
  }
}
