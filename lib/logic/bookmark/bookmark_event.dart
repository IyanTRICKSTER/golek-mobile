part of 'bookmark_bloc.dart';

abstract class BookmarkEvent extends Equatable {
  const BookmarkEvent();

  @override
  List<Object> get props => [];
}

class BookmarkLoadEvent extends BookmarkEvent {}

class BookmarkRefreshEvent extends BookmarkEvent {}

class BookmarkRemoveEvent extends BookmarkEvent {}

class BookmarkAddPostEvent extends BookmarkEvent {
  final String postID;

  const BookmarkAddPostEvent({required this.postID});
}

class BookmarkRevokePostEvent extends BookmarkEvent {
  final String postID;

  const BookmarkRevokePostEvent({required this.postID});
}
