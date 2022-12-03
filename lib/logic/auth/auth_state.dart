part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class LoginSuccessState extends AuthState {}

class LogoutSuccessState extends AuthState {}

class LoginFailState extends AuthState {
  final String error;

  const LoginFailState({required this.error});
}

class LoginLodingState extends AuthState {}
