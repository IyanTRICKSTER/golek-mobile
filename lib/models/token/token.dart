import 'package:json_annotation/json_annotation.dart';

part 'token.g.dart';

@JsonSerializable()
class TokenModel {
  @JsonKey(name: 'access_token')
  late String accessToken;
  @JsonKey(name: 'refresh_token', nullable: true)
  late String? refreshToken;
  @JsonKey(ignore: true)
  late String error = "";
  @JsonKey(ignore: true)
  late int? errorCode;

  TokenModel(this.accessToken, this.refreshToken);

  factory TokenModel.fromJson(Map<String, dynamic> json) => _$TokenModelFromJson(json);

  TokenModel.withError(this.error, this.errorCode);

  Map<String, dynamic> toJson() => _$TokenModelToJson(this);

  @override
  String toString() {
    return 'Token{accessToken: $accessToken, refreshToken: $refreshToken}';
  }
}
