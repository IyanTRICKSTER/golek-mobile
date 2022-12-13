part of 'profile_returned_posts_bloc.dart';

abstract class ProfileReturnedPostsState extends Equatable {
  const ProfileReturnedPostsState();

  @override
  List<Object> get props => [];
}

class ProfileReturnedPostsInitial extends ProfileReturnedPostsState {}

class ProfileReturnedPostLoadFailure extends ProfileReturnedPostsState {
  final String error;
  final int lastPage;

  const ProfileReturnedPostLoadFailure(this.error, this.lastPage);
}

class ProfileReturnedPostLoadedState extends ProfileReturnedPostsState {
  ListPostModel? posts;
  bool hasReachedMax;
  int currentPage;

  ProfileReturnedPostLoadedState({required this.posts, required this.hasReachedMax, required this.currentPage});

  ProfileReturnedPostLoadedState copyWith({ListPostModel? posts, bool? hasReachedMax, int? page}) {
    return ProfileReturnedPostLoadedState(
        posts: posts ?? this.posts, hasReachedMax: hasReachedMax ?? this.hasReachedMax, currentPage: page ?? currentPage);
  }

  @override
  List<Object> get props => [posts!, hasReachedMax, currentPage];
}
