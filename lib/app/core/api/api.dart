import 'package:dio/dio.dart';
import 'package:neura_app/app/core/constants/environment.dart';
import 'package:neura_app/app/core/constants/storage_keys.dart';
import 'package:neura_app/app/core/services/encrypt_service.dart';
import 'package:neura_app/app/core/services/storage_service.dart';

InterceptorsWrapper _interceptor = InterceptorsWrapper(
  onRequest: (options, handler) async {
    final token = await StorageService.get<String>(StorageKeys.token);
    options.headers['Authorization'] = 'Bearer $token';
    options.headers['Accept'] = 'application/json';
    if (options.data != null) {
      options.data = await EncryptionService.encrypt<dynamic>(options.data);
      // print(options.data);
    }

    return handler.next(options);
  },
  onResponse: (response, handler) async {
    if (response.data != null && response.data is Map<String, dynamic>) {
      try {
        response.data = await EncryptionService.decrypt<dynamic>(response.data);
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
);

class Api {
  static final Dio _dioBase = Dio(BaseOptions(baseUrl: Environment.baseUrl))
    ..interceptors.add(_interceptor);

  static Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dioBase.get(path, queryParameters: queryParameters);
  }

  static Future<Response> post(String path, {Object? data}) async {
    return _dioBase.post(path, data: data);
  }

  static Future<Response> put(String path, {Object? data}) async {
    return _dioBase.put(path, data: data);
  }

  static Future<Response> delete(String path) async {
    return _dioBase.delete(path);
  }

  static Future<Response> postStream(String path, {Object? data}) async {
    return _dioBase.post(
      path,
      data: data,
      options: Options(responseType: ResponseType.stream),
    );
  }
}
