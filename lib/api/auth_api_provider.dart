import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:golek_mobile/models/login/login_body.dart';
import 'package:golek_mobile/models/token/token.dart';
import 'package:golek_mobile/models/user/user_model.dart';
import 'package:golek_mobile/utils/dio_interceptor.dart';

class APIAuthProvider {
  final Dio _dio;
  final Dio _exclusiveDio = Dio();
  late String _baseUrl;

  APIAuthProvider(this._dio) {
    _baseUrl = _dio.options.baseUrl;
  }

  Future<TokenModel> login(LoginBody loginBody) async {
    try {
      final response = await _dio.post(
        'auth/login',
        data: loginBody.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      // print(response.data);
      return TokenModel.fromJson(response.data);
    } on DioError catch (error, stacktrace) {
      _printError(error, stacktrace);
      return TokenModel.withError(error.response!.data["error"], error.response!.statusCode);
    }
  }

  Future<UserModel> whoami(String accessToken) async {
    try {
      final response = await _dio.get(
        'user/current',
      );
      // print(response.data);
      return UserModel.fromJson(response.data);
    } on DioError catch (error, stacktrace) {
      _printError(error, stacktrace);
      return UserModel.withError(error.toString());
    }
  }

  Future<TokenModel> refreshToken(String refreshToken) async {
    try {
      final response = await _exclusiveDio.get("${_baseUrl}auth/token/refresh?refresh-token=$refreshToken");
      return TokenModel.fromJson(response.data);
    } on DioError catch (error, stacktrace) {
      _printError(error, stacktrace);
      return TokenModel.withError(error.toString(), error.response!.statusCode!);
    }
  }

  void _printError(error, StackTrace stacktrace) {
    debugPrint('error: $error & stacktrace: $stacktrace');
  }
}
