import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:golek_mobile/api/api_repository.dart';
import 'package:golek_mobile/injector/injector.dart';
import 'package:golek_mobile/models/token/token.dart';
import 'package:golek_mobile/storage/sharedpreferences_manager.dart';

class DioLoggingInterceptors extends Interceptor {
  final Dio _dio;
  final SharedPreferencesManager _sharedPreferencesManager = locator<SharedPreferencesManager>();

  DioLoggingInterceptors(this._dio);

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    debugHttpRequest(options);

    // log('Access Token: ${_sharedPreferencesManager.getString(SharedPreferencesManager.keyAccessToken)}\n');
    String? accessToken = _sharedPreferencesManager.getString(SharedPreferencesManager.keyAccessToken);
    options.headers.addAll({'Authorization': 'Bearer $accessToken'});

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugHttpResponse(response);
    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    debugHttpError(err);

    //Get http error code, if we get 401 then request new access_token
    int? responseCode = err.response!.statusCode;
    //Get old access token
    String? oldAccessToken = _sharedPreferencesManager.getString(SharedPreferencesManager.keyAccessToken);

    //if we still has token and gets unathorized, then reauthorize
    if (oldAccessToken != null) {
      if (oldAccessToken!.isNotEmpty && responseCode! == 401) {
        //Lock Interceptor
        _dio.interceptors.requestLock.lock();
        _dio.interceptors.responseLock.lock();

        //Load refreshToken from storage
        String? refreshToken = _sharedPreferencesManager.getString(SharedPreferencesManager.keyRefreshToken);

        //Request new access token
        APIRepository authRepository = APIRepository();
        TokenModel newToken = await authRepository.refreshToken(refreshToken!);

        //if request new token success, save new token to localstorage
        if (newToken.error.isNotEmpty && newToken.errorCode! == 401) {
          log("Refresh token has expired!");
          _sharedPreferencesManager.clearAll();
          locator<NavigationService>().navigateTo('/login_screen');
          return null;
        }

        if (newToken.error.isEmpty) {
          //Replace old access token
          log("Saving new Access token");
          await _sharedPreferencesManager.putString(SharedPreferencesManager.keyAccessToken, newToken.accessToken);
          // await _sharedPreferencesManager.putString(SharedPreferencesManager.keyRefreshToken, newToken.refreshToken);
        }

        //Unlock Interceptor
        _dio.interceptors.requestLock.unlock();
        _dio.interceptors.responseLock.unlock();

        RequestOptions? options = err.response!.requestOptions;

        if (options.data is FormData) {
          FormData formData = FormData();
          formData.fields.addAll(options.data.fields);
          for (MapEntry mapFile in options.data.files) {
            formData.files.add(MapEntry(mapFile.key, MultipartFile.fromFileSync(options.extra['image_path'], filename: mapFile.value.filename)));
          }
          options.data = formData;
        }

        final cloneRequest = await _dio.request(
          options.path,
          data: options.data,
          options: Options(
            method: options.method,
            headers: options.headers
              ..addAll(<String, dynamic>{
                'Authorization': 'Bearer ${newToken.accessToken}',
              }),
          ),
        );
        handler.resolve(cloneRequest);
        return;
      } else {
        super.onError(err, handler);
        return;
      }
    }
    super.onError(err, handler);
  }

  void debugHttpRequest(RequestOptions options) {
    print("--START REQUEST-------------------------------------------------->\n");
    print("${options.method != "" ? options.method.toUpperCase() : 'METHOD'} ${"${options.baseUrl}${options.path}"}");
    print("[x] Request Header:");
    options.headers.forEach((k, v) => print('$k: $v'));
    if (options.queryParameters != null) {
      print("[x] Query Parameters:");
      options.queryParameters.forEach((k, v) => print('$k: $v'));
    }
    if (options.data != null) {
      print("[x] Request Body: ${options.data}");
    }
    print("<--END REQUEST----------------------------------------------------\n");
  }

  void debugHttpResponse(Response response) {
    print("--START RESPONSE------------------------------------------------->\n");
    print("[x] Response Headers:");
    response.headers.forEach((k, v) => print('$k: $v'));
    print("[x] Response Data: ${response.data}");
    print("<--END RESPONSE---------------------------------------------------------------\n");
  }

  void debugHttpError(DioError err) {
    print("--START ERROR---------------------------------------------------->\n");

    if (err.response != null) {
      print(
          "<-- ${err.message} ${(err.response!.requestOptions.toString().isNotEmpty ? (err.response!.requestOptions.baseUrl + err.response!.requestOptions.path) : 'URL')}");
    }
    print("${err.message}");
    print("${err.response != null ? err.response!.data : 'Unknown Error'}");
    print("<--END ERROR------------------------------------------------------\n");
  }
}
