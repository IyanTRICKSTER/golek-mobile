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
  ListPostModel? posts;
  bool hasReachedMax;
  int currentPage;
  BookmarkModel bookmark;

  PostLoadedState({required this.posts, required this.hasReachedMax, required this.currentPage, required this.bookmark});

  PostLoadedState copyWith({ListPostModel? posts, bool? hasReachedMax, int? page}) {
    return PostLoadedState(
        posts: posts ?? this.posts, hasReachedMax: hasReachedMax ?? this.hasReachedMax, currentPage: page ?? currentPage, bookmark: bookmark);
  }

  @override
  List<Object> get props => [posts!, hasReachedMax, currentPage];
}

class PostUploadedState extends PostState {
  PostModel? post;

  PostUploadedState(this.post);

  @override
  List<Object> get props => [post!];
}

//
class PostRequestValidationTokenSuccessState extends PostState {
  final String qrCodeUrl;

  const PostRequestValidationTokenSuccessState({required this.qrCodeUrl});

  @override
  List<Object> get props => [qrCodeUrl];
}

class PostRequestValidationTokenFailureState extends PostState {
  final String error;

  const PostRequestValidationTokenFailureState({required this.error});

  @override
  List<Object> get props => [error];
}

class PostRequestValidationTokenLoadingState extends PostState {}

//
class PostValidateTokenSuccessState extends PostState {}

class PostValidateTokenFailureState extends PostState {
  final String error;

  const PostValidateTokenFailureState({required this.error});
}

class PostValidateTokenLoadingState extends PostState {}
