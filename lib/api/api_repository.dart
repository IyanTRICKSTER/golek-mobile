import 'package:dio/dio.dart';
import 'package:golek_mobile/api/auth_api_provider.dart';
import 'package:golek_mobile/api/bookmark_api_provider.dart';
import 'package:golek_mobile/api/post_api_provider.dart';
import 'package:golek_mobile/models/bookmark/bookmark_model.dart';
import 'package:golek_mobile/models/login/login_body.dart';
import 'package:golek_mobile/models/post/post_model.dart';
import 'package:golek_mobile/models/post_validation/post_validation_model.dart';
import 'package:golek_mobile/models/token/token.dart';
import 'package:golek_mobile/models/user/user_model.dart';
import 'package:golek_mobile/utils/dio_interceptor.dart';

class APIRepository {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://c418-101-255-164-62.ngrok.io/';
  // final String _baseUrl = 'http://gateway.golek.api/';
  late final APIAuthProvider _apiAuthProvider;
  late final APIPostProvider _apiPostProvider;
  late final APIBookmarkProvider _apiBookmarkProvider;

  APIRepository() {
    _dio.options.baseUrl = _baseUrl;
    _dio.interceptors.add(DioLoggingInterceptors(_dio));
    _apiAuthProvider = APIAuthProvider(_dio);
    _apiPostProvider = APIPostProvider(_dio);
    _apiBookmarkProvider = APIBookmarkProvider(_dio);
  }

  //Auth
  Future<TokenModel> login(LoginBody loginBody) async => await _apiAuthProvider.login(loginBody);
  Future<UserModel> whoami(String accessToken) async => await _apiAuthProvider.whoami(accessToken);
  Future<TokenModel> refreshToken(String refreshToken) async => await _apiAuthProvider.refreshToken(refreshToken);

  //Post
  Future<ListPostModel> fetchPosts(int page, int limit) async => await _apiPostProvider.fetchPost(page, limit);
  Future<ListPostModel> fetchPostsByUserID(int page, int limit, int userID, String isReturned) async =>
      await _apiPostProvider.fetchPostsByUserID(page, limit, userID, isReturned);
  Future<PostModel> uploadPost(PostModel data) async => await _apiPostProvider.uploadPost(data);
  Future<PostValidationResponseModel> requestPostValidationToken(String postID) async => await _apiPostProvider.requestPostValidation(postID);
  Future<Response> postValidate(PostValidationRequestModel requestModel) async => await _apiPostProvider.postValidate(requestModel);
  Future<ListPostModel> searchPost(String postID, int page, int limit) async => await _apiPostProvider.searchPost(postID, page, limit);

  //Bookmark
  Future<BookmarkModel> fetchBookmarkByUserID(int userID) async => await _apiBookmarkProvider.fetchBookmarkByUserID(userID);
  Future<Response> bookmarkPost(int userID, String postID) async => await _apiBookmarkProvider.bookmarkPost(userID, postID);
  Future<Response> unbookmarkPost(int userID, String postID) async => await _apiBookmarkProvider.unbookmarkPost(userID, postID);
}
