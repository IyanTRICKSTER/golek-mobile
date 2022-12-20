import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:golek_mobile/models/post/post_model.dart';
import 'package:golek_mobile/models/post_validation/post_validation_model.dart';
import 'package:http_parser/http_parser.dart';

class APIPostProvider {
  final Dio _dio;

  APIPostProvider(this._dio);

  Future<ListPostModel> fetchPost(int page, int limit) async {
    try {
      Response response = await _dio.get("posts/list?page=$page&limit=$limit");
      return ListPostModel.fromJson(response.data);
    } on DioError catch (error, stacktrace) {
      _printError(error, stacktrace);
      return ListPostModel.withError(error);
    }
  }

  Future<ListPostModel> searchPost(String keyword, int page, int limit) async {
    try {
      Response response = await _dio.get("posts/s/$keyword?page=$page&limit=$limit");
      return ListPostModel.fromJson(response.data);
    } on DioError catch (error, stacktrace) {
      _printError(error, stacktrace);
      return ListPostModel.withError(error);
    }
  }

  Future<ListPostModel> fetchPostsByUserID(int page, int limit, int userID, String isReturned) async {
    try {
      Response response = await _dio.get("posts/list?page=$page&limit=$limit&user-id=$userID&returned=$isReturned");
      return ListPostModel.fromJson(response.data);
    } on DioError catch (error, stacktrace) {
      _printError(error, stacktrace);
      return ListPostModel.withError(error);
    }
  }

  Future<PostModel> uploadPost(PostModel data) async {
    try {
      var formData = FormData.fromMap({
        'title': data.title,
        'place': data.place,
        'image': await MultipartFile.fromFile(data.imageUrl),
      });
      for (var v in data.characteristics) {
        formData.fields.add(MapEntry('characteristics', jsonEncode(v)));
      }
      Response response = await _dio.post(
        "posts/",
        data: formData,
        options: Options(
          extra: {'image_path': data.imageUrl},
          contentType: Headers.contentTypeHeader,
          headers: {
            'Content-Type': 'multipart/form-data; boundary=${formData.boundary}',
            'Content-Length': formData.length,
          },
        ),
      );

      return PostModel.fromJson(response.data["data"]);
    } catch (error, stacktrace) {
      _printError(error, stacktrace);
      return PostModel.withError(error.toString());
    }
  }

  Future<PostValidationResponseModel> requestPostValidation(String postID) async {
    try {
      Response response = await _dio.get("posts/validate/$postID");
      return PostValidationResponseModel.fromJson(response.data["data"]);
    } catch (error, stacktrace) {
      _printError(error, stacktrace);
      return PostValidationResponseModel.withError(error.toString());
    }
  }

  Future<Response> postValidate(PostValidationRequestModel requestModel) async {
    try {
      Response response = await _dio.post(
        "posts/validate/",
        data: requestModel.toJson(),
      );
      return response;
    } on DioError catch (error, stacktrace) {
      _printError(error, stacktrace);
      return error.response!;
    }
  }

  Future<Response> deletePost(String postID) async {
    try {
      Response response = await _dio.delete("posts/$postID");
      return response;
    } on DioError catch (error, stacktrace) {
      _printError(error, stacktrace);
      return error.response!;
    }
  }

  void _printError(error, StackTrace stacktrace) {
    debugPrint('error: $error & stacktrace: $stacktrace');
  }
}
