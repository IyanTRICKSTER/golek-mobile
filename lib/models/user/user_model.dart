import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: "id")
  late int id;
  @JsonKey(name: "username")
  late String username;
  @JsonKey(name: "email")
  late String email;
  @JsonKey(name: "nim")
  late String nim;
  @JsonKey(ignore: true)
  String? error = "";

  UserModel(this.id, this.username, this.email, this.nim);

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  UserModel.withError(this.error);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
