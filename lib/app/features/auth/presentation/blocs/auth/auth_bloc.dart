import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neura_app/app/features/auth/domain/usecases/guest_register.dart';
import 'package:neura_app/app/features/auth/domain/usecases/is_loggued_in.dart';
import 'package:neura_app/app/features/auth/domain/usecases/logout.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GuestRegisterUseCase guestRegisterUseCase;
  final IsLogguedInUseCase isLogguedInUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc(
    this.guestRegisterUseCase,
    this.isLogguedInUseCase,
    this.logoutUseCase,
  ) : super(AuthInitial()) {
    on<GuestRegister>(_onGuestRegister);
    on<Logout>(_onLogout);
    on<AuthCheckStatus>(_onCheckStatus);

    add(AuthCheckStatus());
  }

  Future<void> _onGuestRegister(
    GuestRegister event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await guestRegisterUseCase();
    res.fold(
      (failure) {
        emit(AuthError(failure.message));
      },
      (_) {
        emit(Authenticated());
      },
    );
  }

  Future<void> _onLogout(Logout event, Emitter<AuthState> emit) async {
    await logoutUseCase();
    emit(Unauthenticated());
  }

  Future<void> _onCheckStatus(
    AuthCheckStatus event,
    Emitter<AuthState> emit,
  ) async {
    final isLoggedIn = await isLogguedInUseCase.call();

    if (isLoggedIn) {
      emit(Authenticated());
    } else {
      emit(Unauthenticated());
      add(GuestRegister());
    }
  }
}
