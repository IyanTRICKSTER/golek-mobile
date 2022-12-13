part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class LoadPostEvent extends PostEvent {}

class UploadPostEvent extends PostEvent {
  PostModel postModel;

  UploadPostEvent(this.postModel);
}

class PostRequestValidationTokenEvent extends PostEvent {
  final String postID;

  const PostRequestValidationTokenEvent({required this.postID});
}

class PostValidateTokenEvent extends PostEvent {
  final String jsonStringPayload;

  const PostValidateTokenEvent({required this.jsonStringPayload});
}
