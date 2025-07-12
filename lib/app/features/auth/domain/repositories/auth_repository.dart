import 'package:dartz/dartz.dart';
import 'package:neura_app/app/core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, Unit>> guestRegister();

  Future<bool> isLoggedIn();

  Future<void> logout();
}
