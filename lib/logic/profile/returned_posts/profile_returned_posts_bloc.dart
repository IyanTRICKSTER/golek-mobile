import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:golek_mobile/api/api_repository.dart';
import 'package:golek_mobile/injector/injector.dart';
import 'package:golek_mobile/models/post/post_model.dart';
import 'package:golek_mobile/storage/sharedpreferences_manager.dart';

part 'profile_returned_posts_event.dart';
part 'profile_returned_posts_state.dart';

class ProfileReturnedPostsBloc extends Bloc<ProfileReturnedPostsEvent, ProfileReturnedPostsState> {
  bool isLoading = false;
  int perPage = 12;
  final APIRepository _apiRepository = APIRepository();
  final SharedPreferencesManager _sharedPreferencesManager = locator<SharedPreferencesManager>();
  late final int userID;

  ProfileReturnedPostsBloc() : super(ProfileReturnedPostsInitial()) {
    userID = _sharedPreferencesManager.getInt(SharedPreferencesManager.keyUserID)!;
    on<LoadProfileReturnedPostEvent>(_fetchPosts);
  }

  Future<void> _fetchPosts(LoadProfileReturnedPostEvent event, Emitter emit) async {
    ListPostModel posts;

    //If State is loaded first time, then load data from page 1
    if (state is ProfileReturnedPostsInitial) {
      if (!isLoading) {
        isLoading = true;
        posts = await _apiRepository.fetchPostsByUserID(1, perPage, userID, "1");

        //Handle 502 error
        if (posts.error != null && posts.error!.response!.statusCode == 502) {
          emit(const ProfileReturnedPostLoadFailure("Bad Gateway", 1));
          isLoading = false;
          return;
        }
        //Handle 404 error
        if (posts.error != null && posts.error!.response!.statusCode == 404) {
          emit(const ProfileReturnedPostLoadFailure("404 Not Found", 1));
          isLoading = false;
          return;
        }

        //otherwise, emit posts data
        emit(ProfileReturnedPostLoadedState(posts: posts, hasReachedMax: false, currentPage: 1));
        isLoading = false;
      }
    } else {
      //if still error, emit bad gateway error
      if (state is ProfileReturnedPostLoadFailure) {
        ProfileReturnedPostLoadFailure postLoadFailure = state as ProfileReturnedPostLoadFailure;
        if (!isLoading) {
          isLoading = true;
          posts = await _apiRepository.fetchPostsByUserID(postLoadFailure.lastPage, perPage, userID, "1");

          //Handle 502 error
          if (posts.error != null && posts.error!.response!.statusCode == 502) {
            emit(ProfileReturnedPostLoadFailure("Bad Gateway", postLoadFailure.lastPage));
            isLoading = false;
            return;
          }
          //Handle 404 error
          if (posts.error != null && posts.error!.response!.statusCode == 404) {
            emit(ProfileReturnedPostLoadFailure("404 Not Found", postLoadFailure.lastPage));
            isLoading = false;
            return;
          }
          emit(ProfileReturnedPostLoadedState(posts: posts, hasReachedMax: false, currentPage: 1));
          isLoading = false;
        }
      } else {
        ProfileReturnedPostLoadedState postLoadedState = state as ProfileReturnedPostLoadedState;
        if (!isLoading) {
          isLoading = true;
          posts = await _apiRepository.fetchPostsByUserID(postLoadedState.currentPage + 1, perPage, userID, "1");

          //Handle 502 error
          if (posts.error != null && posts.error!.response!.statusCode == 502) {
            emit(ProfileReturnedPostLoadFailure("Bad Gateway", postLoadedState.currentPage + 1));
            isLoading = false;
            return;
          }
          //Handle 404 error
          if (posts.error != null && posts.error!.response!.statusCode == 404) {
            emit(ProfileReturnedPostLoadFailure("404 Not Found", postLoadedState.currentPage + 1));
            isLoading = false;
            return;
          }

          if (posts.data!.isEmpty) {
            emit(postLoadedState.copyWith(hasReachedMax: true));
            isLoading = false;
          } else {
            ListPostModel newList = ListPostModel(postLoadedState.posts!.data! + posts.data!);

            emit(ProfileReturnedPostLoadedState(posts: newList, hasReachedMax: false, currentPage: postLoadedState.currentPage + 1));
            isLoading = false;
          }
        }
      }
    }
  }
}
