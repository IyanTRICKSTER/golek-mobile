import 'package:json_annotation/json_annotation.dart';

part 'post_validation_model.g.dart';

@JsonSerializable()
class PostValidationResponseModel {
  @JsonKey(name: "qr_code_url")
  late String? qrCodeUrl;
  @JsonKey(ignore: true)
  String? error;

  PostValidationResponseModel(this.qrCodeUrl);

  PostValidationResponseModel.withError(this.error);

  factory PostValidationResponseModel.fromJson(Map<String, dynamic> json) => _$PostValidationResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostValidationResponseModelToJson(this);
}

@JsonSerializable()
class PostValidationRequestModel {
  @JsonKey(name: "post_id")
  late final String postID;
  @JsonKey(name: "owner_id")
  late final int ownerID;
  @JsonKey(name: "hash")
  late final String hash;
  @JsonKey(ignore: true)
  late String? error;

  PostValidationRequestModel({required this.postID, required this.ownerID, required this.hash});

  PostValidationRequestModel.withError(this.error);

  factory PostValidationRequestModel.fromJson(Map<String, dynamic> json) => _$PostValidationRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostValidationRequestModelToJson(this);
}
