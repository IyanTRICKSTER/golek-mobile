import 'package:dio/dio.dart';
import 'package:golek_mobile/api/auth_api_provider.dart';
import 'package:golek_mobile/api/post_api_provider.dart';
import 'package:golek_mobile/models/login/login_body.dart';
import 'package:golek_mobile/models/post/post_model.dart';
import 'package:golek_mobile/models/token/token.dart';
import 'package:golek_mobile/models/user/user_model.dart';
import 'package:golek_mobile/utils/dio_interceptor.dart';

class APIRepository {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://224b-103-233-89-235.ngrok.io/';
  // final String _baseUrl = 'http://gateway.golek.api/';
  late final APIAuthProvider _apiAuthProvider;
  late final APIPostProvider _apiPostProvider;

  APIRepository() {
    _dio.options.baseUrl = _baseUrl;
    _dio.interceptors.add(DioLoggingInterceptors(_dio));
    _apiAuthProvider = APIAuthProvider(_dio);
    _apiPostProvider = APIPostProvider(_dio);
  }

  //Auth
  Future<TokenModel> login(LoginBody loginBody) async => await _apiAuthProvider.login(loginBody);
  Future<UserModel> whoami(String accessToken) async => await _apiAuthProvider.whoami(accessToken);
  Future<TokenModel> refreshToken(String refreshToken) async => await _apiAuthProvider.refreshToken(refreshToken);

  //Post
  Future<ListPostModel> fetchPosts(int page, int limit) async => await _apiPostProvider.fetchPost(page, limit);
  Future<PostModel> uploadPost(PostModel data) async => await _apiPostProvider.uploadPost(data);
}
