import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:golek_mobile/models/post/post_model.dart';
import 'package:golek_mobile/utils/extended_multipart.dart';

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

  Future<PostModel> uploadPost(PostModel data) async {
    try {
      var formData = FormData.fromMap({
        'title': data.title,
        'place': data.place,
        'image': MultipartFileExtended.fromFileSync(data.imageUrl),
      });
      for (var v in data.characteristics) {
        formData.fields.add(MapEntry('characteristics', jsonEncode(v)));
      }
      Response res = await _dio.post("posts/", data: formData);
      return PostModel.fromJson(res.data["data"]);
    } catch (error, stacktrace) {
      _printError(error, stacktrace);
      return PostModel.withError(error.toString());
    }
  }

  void _printError(error, StackTrace stacktrace) {
    debugPrint('error: $error & stacktrace: $stacktrace');
  }
}
