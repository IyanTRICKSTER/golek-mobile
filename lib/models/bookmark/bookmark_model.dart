import 'package:json_annotation/json_annotation.dart';

part 'bookmark_model.g.dart';

@JsonSerializable()
class BookmarkModel {
  @JsonKey(name: "id")
  late String id;
  @JsonKey(name: "user_id")
  late String userID;
  @JsonKey(name: "posts")
  late List<MarkedPostModel> posts;
  @JsonKey(ignore: true)
  String? error;

  BookmarkModel(this.id, this.userID, this.posts);

  factory BookmarkModel.fromJson(Map<String, dynamic> json) => _$BookmarkModelFromJson(json);

  BookmarkModel.withError(this.error);

  Map<String, dynamic> toJson() => _$BookmarkModelToJson(this);
}

@JsonSerializable()
class MarkedPostModel {
  @JsonKey(name: "id")
  late String id;
  @JsonKey(name: "name")
  late String title;
  @JsonKey(name: "image_url")
  late String imageUrl;
  @JsonKey(ignore: true)
  String? error;

  MarkedPostModel(this.id, this.title, this.imageUrl);

  factory MarkedPostModel.fromJson(Map<String, dynamic> json) => _$MarkedPostModelFromJson(json);

  MarkedPostModel.withError(this.error);

  Map<String, dynamic> toJson() => _$MarkedPostModelToJson(this);
}
