import 'package:neura_app/app/features/auth/domain/repositories/auth_repository.dart';

class IsLogguedInUseCase {
  final AuthRepository _authRepository;

  IsLogguedInUseCase(this._authRepository);

  Future<bool> call() async {
    return await _authRepository.isLoggedIn();
  }
}
