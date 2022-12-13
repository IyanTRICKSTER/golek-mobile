part of 'bookmark_bloc.dart';

abstract class BookmarkState extends Equatable {
  const BookmarkState();

  @override
  List<Object> get props => [];
}

class BookmarkInitial extends BookmarkState {}

class BookmarkLoadedState extends BookmarkState {
  BookmarkModel? bookmark;

  BookmarkLoadedState(this.bookmark);

  @override
  List<Object> get props => [bookmark!];
}

class BookmarkRefreshState extends BookmarkState {
  BookmarkModel? bookmark;

  BookmarkRefreshState(this.bookmark);

  @override
  List<Object> get props => [bookmark!];
}

class BookmarkLoadFailureState extends BookmarkState {
  final String error;

  const BookmarkLoadFailureState(this.error);
}

class BookmarkLoadingState extends BookmarkState {}

class BookmarkAddedState extends BookmarkState {}

class BookmarkRevokedState extends BookmarkState {}

class BookmarkProcessFailed extends BookmarkState {
  final String error;

  const BookmarkProcessFailed(this.error);
}
