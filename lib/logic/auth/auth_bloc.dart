import 'dart:async';
import 'dart:developer';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:golek_mobile/api/api_repository.dart';
import 'package:golek_mobile/api/streamchat_provider.dart';
import 'package:golek_mobile/injector/injector.dart';
import 'package:golek_mobile/models/login/login_body.dart';
import 'package:golek_mobile/models/token/token.dart';
import 'package:golek_mobile/models/user/user_model.dart';
import 'package:golek_mobile/storage/sharedpreferences_manager.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SharedPreferencesManager sharedPreferencesManager = locator<SharedPreferencesManager>();
  final APIRepository authRepository = APIRepository();

  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(_login);
    on<LogoutEvent>(_logout);
  }

  //Login Logic
  Future<void> _login(LoginEvent event, Emitter<AuthState> emit) async {
    //Emit loading state
    emit(LoginLodingState());

    //Checking input
    if (event.loginBody.email.isEmpty) {
      emit(const LoginFailState(error: "email is required"));
      return;
    }

    if (event.loginBody.password.isEmpty) {
      emit(const LoginFailState(error: "password is required"));
      return;
    }

    //Hit login endpoint
    // print(event.loginBody);

    //Retrieve JWT Token
    TokenModel token = await authRepository.login(event.loginBody);
    if (token.error.isNotEmpty) {
      emit(LoginFailState(error: token.error));
      return;
    }

    //If not error, store jwt token to localstorage
    await sharedPreferencesManager.putString(SharedPreferencesManager.keyAccessToken, token.accessToken);
    await sharedPreferencesManager.putString(SharedPreferencesManager.keyRefreshToken, token.refreshToken!);
    await sharedPreferencesManager.putBool(SharedPreferencesManager.keyIsLoggedIn, true);
    await sharedPreferencesManager.putString(SharedPreferencesManager.keyEmail, event.loginBody.email);

    //Retrive User Information
    UserModel user = await authRepository.whoami(token.accessToken);
    await sharedPreferencesManager.putInt(SharedPreferencesManager.keyUserID, user.id);
    await sharedPreferencesManager.putString(SharedPreferencesManager.keyUsername, user.username);

    //Instantiate StreamchatAPI
    StreamChatProvider.instance.connectUser();

    emit(LoginSuccessState());
  }

  Future<void> _logout(LogoutEvent event, Emitter<AuthState> emit) async {
    await sharedPreferencesManager.clearAll();
    StreamChatProvider.instance.client.disconnectUser();
    StreamChatProvider.dispose();
    emit(LogoutSuccessState());
  }
}
