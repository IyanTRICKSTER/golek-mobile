part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final LoginBody loginBody;

  const LoginEvent({required this.loginBody});
}

class LogoutEvent extends AuthEvent {}
