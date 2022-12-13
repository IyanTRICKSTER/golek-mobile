// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookmarkModel _$BookmarkModelFromJson(Map<String, dynamic> json) =>
    BookmarkModel(
      json['id'] as String,
      json['user_id'] as String,
      (json['posts'] as List<dynamic>)
          .map((e) => MarkedPostModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BookmarkModelToJson(BookmarkModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userID,
      'posts': instance.posts,
    };

MarkedPostModel _$MarkedPostModelFromJson(Map<String, dynamic> json) =>
    MarkedPostModel(
      json['id'] as String,
      json['name'] as String,
      json['image_url'] as String,
    );

Map<String, dynamic> _$MarkedPostModelToJson(MarkedPostModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.title,
      'image_url': instance.imageUrl,
    };
