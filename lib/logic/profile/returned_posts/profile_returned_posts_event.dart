part of 'profile_returned_posts_bloc.dart';

abstract class ProfileReturnedPostsEvent extends Equatable {
  const ProfileReturnedPostsEvent();

  @override
  List<Object> get props => [];
}

class LoadProfileReturnedPostEvent extends ProfileReturnedPostsEvent {}
