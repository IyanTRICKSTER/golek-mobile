// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      json['id'] as String,
      json['title'] as String,
      json['image_url'] as String,
      (json['characteristics'] as List<dynamic>)
          .map((e) => PostCharacteristic.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['place'] as String,
    )
      ..userID = json['user_id'] as int
      ..isReturned = json['is_returned'] as bool
      ..user = UserInfo.fromJson(json['user'] as Map<String, dynamic>);

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userID,
      'is_returned': instance.isReturned,
      'title': instance.title,
      'place': instance.place,
      'image_url': instance.imageUrl,
      'characteristics': instance.characteristics,
      'user': instance.user,
    };

PostCharacteristic _$PostCharacteristicFromJson(Map<String, dynamic> json) =>
    PostCharacteristic(
      json['title'] as String,
    );

Map<String, dynamic> _$PostCharacteristicToJson(PostCharacteristic instance) =>
    <String, dynamic>{
      'title': instance.title,
    };

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      json['username'] as String,
      json['usermajor'] as String,
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'username': instance.username,
      'usermajor': instance.usermajor,
    };

ListPostModel _$ListPostModelFromJson(Map<String, dynamic> json) =>
    ListPostModel(
      (json['data'] as List<dynamic>?)
          ?.map((e) => PostModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListPostModelToJson(ListPostModel instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
