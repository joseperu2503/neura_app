abstract class AuthEvent {}

class GuestRegister extends AuthEvent {}

class Logout extends AuthEvent {}

class AuthCheckStatus extends AuthEvent {}
