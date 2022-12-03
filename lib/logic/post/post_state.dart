part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostUninitialized extends PostState {}

class PostLoadingState extends PostState {}

class PostLoadFailure extends PostState {
  final String error;
  final int lastPage;

  const PostLoadFailure(this.error, this.lastPage);
}

class PostLoadedState extends PostState {
  ListPostModel posts;
  bool hasReachedMax;
  int currentPage;

  PostLoadedState({required this.posts, required this.hasReachedMax, required this.currentPage});

  PostLoadedState copyWith({ListPostModel? posts, bool? hasReachedMax, int? page}) {
    return PostLoadedState(posts: posts ?? this.posts, hasReachedMax: hasReachedMax ?? this.hasReachedMax, currentPage: page ?? currentPage);
  }

  @override
  List<Object> get props => [posts, hasReachedMax, currentPage];
}

class PostUploadedState extends PostState {
  PostModel post;

  PostUploadedState(this.post);

  @override
  List<Object> get props => [post];
}
