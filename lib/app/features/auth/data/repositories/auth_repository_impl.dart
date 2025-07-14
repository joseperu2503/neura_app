import 'package:dartz/dartz.dart';
import 'package:neura_app/app/core/errors/exceptions.dart';
import 'package:neura_app/app/core/errors/failures.dart';
import 'package:neura_app/app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:neura_app/app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:neura_app/app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;

  AuthRepositoryImpl(this._authRemoteDataSource, this._authLocalDataSource);

  @override
  Future<Either<Failure, Unit>> guestRegister() async {
    try {
      final res = await _authRemoteDataSource.guestRegister();

      await _authLocalDataSource.set(res.accessToken);
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure());
    }
  }

  @override
  Future<bool> isLoggedIn() {
    return _authLocalDataSource.validate();
  }

  @override
  Future<void> logout() {
    return _authLocalDataSource.remove();
  }
}
