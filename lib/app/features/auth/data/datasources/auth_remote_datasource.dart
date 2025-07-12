import 'package:dio/dio.dart';
import 'package:neura_app/app/core/errors/exceptions.dart';
import 'package:neura_app/app/core/network/dio_client.dart';
import 'package:neura_app/app/features/auth/data/models/login_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> guestRegister();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthResponseModel> guestRegister() async {
    try {
      final response = await dio.get(
        '/auth/guest/register',
      );

      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException();
    }
  }
}
