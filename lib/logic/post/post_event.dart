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
