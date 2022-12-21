part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class LoadPostEvent extends PostEvent {}

class SearchPostEvent extends PostEvent {
  final String keyword;

  const SearchPostEvent({required this.keyword});
}

class UploadPostEvent extends PostEvent {
  final PostModel postModel;

  const UploadPostEvent(this.postModel);
}

class DeletePostEvent extends PostEvent {
  final String postID;

  const DeletePostEvent({required this.postID});
}

class PostRequestValidationTokenEvent extends PostEvent {
  final String postID;

  const PostRequestValidationTokenEvent({required this.postID});
}

class PostValidateTokenEvent extends PostEvent {
  final String jsonStringPayload;

  const PostValidateTokenEvent({required this.jsonStringPayload});
}
