import 'package:dartz/dartz.dart';
import 'package:neura_app/app/core/errors/failures.dart';
import 'package:neura_app/app/features/auth/domain/repositories/auth_repository.dart';

class GuestRegisterUseCase {
  final AuthRepository _authRepository;

  GuestRegisterUseCase(this._authRepository);

  Future<Either<Failure, Unit>> call() {
    return _authRepository.guestRegister();
  }
}
