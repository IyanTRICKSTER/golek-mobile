part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostUninitializedState extends PostState {}

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
  BookmarkModel? bookmark;
  String? keyword;

  PostLoadedState({required this.posts, required this.hasReachedMax, required this.currentPage, required this.bookmark, this.keyword});

  PostLoadedState copyWith({ListPostModel? posts, bool? hasReachedMax, int? page, String? keyword}) {
    return PostLoadedState(
        posts: posts ?? this.posts,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        currentPage: page ?? currentPage,
        bookmark: bookmark,
        keyword: keyword ?? this.keyword);
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
class PostValidateTokenSuccessState extends PostState {
  final String? message;

  const PostValidateTokenSuccessState(this.message);

  @override
  List<Object> get props => [message!];
}

class PostValidateTokenFailureState extends PostState {
  final String error;

  const PostValidateTokenFailureState({required this.error});
}

class PostValidateTokenLoadingState extends PostState {}
