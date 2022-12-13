part of 'profile_posts_bloc.dart';

abstract class ProfilePostState extends Equatable {
  const ProfilePostState();

  @override
  List<Object> get props => [];
}

class ProfilePostUninitialized extends ProfilePostState {}

class ProfilePostLoadingState extends ProfilePostState {}

class ProfilePostLoadFailure extends ProfilePostState {
  final String error;
  final int lastPage;

  const ProfilePostLoadFailure(this.error, this.lastPage);
}

class ProfilePostLoadedState extends ProfilePostState {
  ListPostModel? posts;
  bool hasReachedMax;
  int currentPage;

  ProfilePostLoadedState({required this.posts, required this.hasReachedMax, required this.currentPage});

  ProfilePostLoadedState copyWith({ListPostModel? posts, bool? hasReachedMax, int? page}) {
    return ProfilePostLoadedState(posts: posts ?? this.posts, hasReachedMax: hasReachedMax ?? this.hasReachedMax, currentPage: page ?? currentPage);
  }

  @override
  List<Object> get props => [posts!, hasReachedMax, currentPage];
}
