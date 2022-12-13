// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_validation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostValidationResponseModel _$PostValidationResponseModelFromJson(
        Map<String, dynamic> json) =>
    PostValidationResponseModel(
      json['qr_code_url'] as String?,
    );

Map<String, dynamic> _$PostValidationResponseModelToJson(
        PostValidationResponseModel instance) =>
    <String, dynamic>{
      'qr_code_url': instance.qrCodeUrl,
    };

PostValidationRequestModel _$PostValidationRequestModelFromJson(
        Map<String, dynamic> json) =>
    PostValidationRequestModel(
      postID: json['post_id'] as String,
      ownerID: json['owner_id'] as int,
      hash: json['hash'] as String,
    );

Map<String, dynamic> _$PostValidationRequestModelToJson(
        PostValidationRequestModel instance) =>
    <String, dynamic>{
      'post_id': instance.postID,
      'owner_id': instance.ownerID,
      'hash': instance.hash,
    };
