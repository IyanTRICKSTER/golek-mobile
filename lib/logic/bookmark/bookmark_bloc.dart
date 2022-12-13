import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:golek_mobile/api/api_repository.dart';
import 'package:golek_mobile/injector/injector.dart';
import 'package:golek_mobile/models/bookmark/bookmark_model.dart';
import 'package:golek_mobile/storage/sharedpreferences_manager.dart';

part 'bookmark_event.dart';
part 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final APIRepository _apiRepository = APIRepository();
  final SharedPreferencesManager _sharedPreferencesManager = locator<SharedPreferencesManager>();
  late final int userID;

  BookmarkBloc() : super(BookmarkInitial()) {
    userID = _sharedPreferencesManager.getInt(SharedPreferencesManager.keyUserID)!;
    on<BookmarkLoadEvent>(_fetchBookmark);
    on<BookmarkAddPostEvent>(_bookmarkPost);
    on<BookmarkRevokePostEvent>(_unbookmarkPost);
    on<BookmarkRefreshEvent>(_refreshBookmark);
  }

  Future<void> _fetchBookmark(BookmarkLoadEvent event, Emitter emit) async {
    BookmarkModel bookmarkModel;

    emit(BookmarkLoadingState());

    bookmarkModel = await _apiRepository.fetchBookmarkByUserID(userID);
    if (bookmarkModel.error != null) {
      emit(BookmarkLoadFailureState(bookmarkModel.error!));
      return;
    }

    emit(BookmarkLoadedState(bookmarkModel));
  }

  Future<void> _bookmarkPost(BookmarkAddPostEvent event, Emitter emit) async {
    emit(BookmarkLoadingState());

    Response response = await _apiRepository.bookmarkPost(userID, event.postID);

    if (response.statusCode == 400) {
      emit(BookmarkProcessFailed(response.statusMessage!));
      return;
    }

    emit(BookmarkAddedState());
  }

  Future<void> _unbookmarkPost(BookmarkRevokePostEvent event, Emitter emit) async {
    emit(BookmarkLoadingState());

    Response response = await _apiRepository.unbookmarkPost(userID, event.postID);

    if (response.statusCode == 400) {
      emit(BookmarkProcessFailed(response.statusMessage!));
      return;
    }

    emit(BookmarkRevokedState());
  }

  Future<void> _refreshBookmark(BookmarkRefreshEvent event, Emitter emit) async {
    BookmarkModel bookmarkModel;

    emit(BookmarkLoadingState());

    bookmarkModel = await _apiRepository.fetchBookmarkByUserID(userID);
    if (bookmarkModel.error != null) {
      emit(BookmarkLoadFailureState(bookmarkModel.error!));
      return;
    }

    emit(BookmarkRefreshState(bookmarkModel));
  }
}
