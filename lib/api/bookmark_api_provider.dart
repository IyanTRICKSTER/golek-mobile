import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:golek_mobile/models/bookmark/bookmark_model.dart';

class APIBookmarkProvider {
  final Dio _dio;

  APIBookmarkProvider(this._dio);

  Future<BookmarkModel> fetchBookmarkByUserID(int userID) async {
    try {
      Response response = await _dio.get(
        "bookmark/u/$userID",
      );
      return BookmarkModel.fromJson(response.data);
    } catch (error, stacktrace) {
      _printError(error, stacktrace);
      return BookmarkModel.withError(error.toString());
    }
  }

  Future<Response> bookmarkPost(int userID, String postID) async {
    try {
      return await _dio.patch(
        "bookmark/post/$userID",
        data: BookmarkModel("", userID.toString(), <MarkedPostModel>[MarkedPostModel(postID, "", "")]).toJson(),
      );
    } on DioError catch (error, stacktrace) {
      _printError(error, stacktrace);
      return error.response!;
    }
  }

  Future<Response> unbookmarkPost(int userID, String postID) async {
    try {
      return await _dio.delete(
        "bookmark/post/$userID",
        data: BookmarkModel("", userID.toString(), <MarkedPostModel>[MarkedPostModel(postID, "", "")]).toJson(),
      );
    } on DioError catch (error, stacktrace) {
      _printError(error, stacktrace);
      return error.response!;
    }
  }

  void _printError(error, StackTrace stacktrace) {
    debugPrint('error: $error & stacktrace: $stacktrace');
  }
}
