import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  @JsonKey(name: "id")
  late String id;
  @JsonKey(name: "user_id")
  late int userID;
  @JsonKey(name: "is_returned")
  late bool isReturned;
  @JsonKey(name: "title")
  late String title;
  @JsonKey(name: "place")
  late String place;
  @JsonKey(name: "image_url")
  late String imageUrl;
  @JsonKey(name: "characteristics")
  late List<PostCharacteristic> characteristics;
  @JsonKey(name: "user")
  late UserInfo user;
  @JsonKey(ignore: true)
  String? error;

  PostModel(this.id, this.title, this.imageUrl, this.characteristics, this.place);

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);

  PostModel.withError(this.error);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}

@JsonSerializable()
class PostCharacteristic {
  @JsonKey(name: "title")
  late String title;
  @JsonKey(ignore: true)
  late String error;

  PostCharacteristic(this.title);

  factory PostCharacteristic.fromJson(Map<String, dynamic> json) => _$PostCharacteristicFromJson(json);

  PostCharacteristic.withError(this.error);

  Map<String, dynamic> toJson() => _$PostCharacteristicToJson(this);
}

@JsonSerializable()
class UserInfo {
  @JsonKey(name: "username")
  late String username;
  @JsonKey(name: "usermajor")
  late String usermajor;
  @JsonKey(ignore: true)
  late Exception error;

  UserInfo(this.username, this.usermajor);

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);

  UserInfo.withError(this.error);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}

@JsonSerializable()
class ListPostModel {
  @JsonKey(name: "data")
  List<PostModel>? data;
  @JsonKey(ignore: true)
  DioError? error;

  ListPostModel(this.data);

  ListPostModel.withError(this.error);

  factory ListPostModel.fromJson(Map<String, dynamic> json) => _$ListPostModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListPostModelToJson(this);
}
