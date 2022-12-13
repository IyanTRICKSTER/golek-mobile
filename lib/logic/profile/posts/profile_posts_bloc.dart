import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:golek_mobile/api/api_repository.dart';
import 'package:golek_mobile/injector/injector.dart';
import 'package:golek_mobile/models/post/post_model.dart';
import 'package:golek_mobile/storage/sharedpreferences_manager.dart';

part 'profile_posts_event.dart';
part 'profile_posts_state.dart';

class ProfilePostBloc extends Bloc<ProfilePostEvent, ProfilePostState> {
  final APIRepository _apiRepository = APIRepository();
  bool isLoading = false;
  final SharedPreferencesManager _sharedPreferencesManager = locator<SharedPreferencesManager>();
  late final int userID;

  ProfilePostBloc() : super(ProfilePostUninitialized()) {
    userID = _sharedPreferencesManager.getInt(SharedPreferencesManager.keyUserID)!;
    on<LoadProfilePostEvent>(_fetchPosts);
  }

  Future<void> _fetchPosts(LoadProfilePostEvent event, Emitter emit) async {
    ListPostModel posts;

    //If State is loaded first time, then load data from page 1
    if (state is ProfilePostUninitialized) {
      if (!isLoading) {
        isLoading = true;
        posts = await _apiRepository.fetchPostsByUserID(1, 12, userID, "");

        //Handle 502 error
        if (posts.error != null && posts.error!.response!.statusCode == 502) {
          emit(const ProfilePostLoadFailure("Bad Gateway", 1));
          isLoading = false;
          return;
        }
        //Handle 404 error
        if (posts.error != null && posts.error!.response!.statusCode == 404) {
          emit(const ProfilePostLoadFailure("404 Not Found", 1));
          isLoading = false;
          return;
        }

        //otherwise, emit posts data
        emit(ProfilePostLoadedState(posts: posts, hasReachedMax: false, currentPage: 1));
        isLoading = false;
      }
    } else {
      //if still error, emit bad gateway error
      if (state is ProfilePostLoadFailure) {
        ProfilePostLoadFailure postLoadFailure = state as ProfilePostLoadFailure;
        if (!isLoading) {
          isLoading = true;
          posts = await _apiRepository.fetchPostsByUserID(postLoadFailure.lastPage, 12, userID, "");

          //Handle 502 error
          if (posts.error != null && posts.error!.response!.statusCode == 502) {
            emit(ProfilePostLoadFailure("Bad Gateway", postLoadFailure.lastPage));
            isLoading = false;
            return;
          }
          //Handle 404 error
          if (posts.error != null && posts.error!.response!.statusCode == 404) {
            emit(ProfilePostLoadFailure("404 Not Found", postLoadFailure.lastPage));
            isLoading = false;
            return;
          }
          emit(ProfilePostLoadedState(posts: posts, hasReachedMax: false, currentPage: 1));
          isLoading = false;
        }
      } else {
        ProfilePostLoadedState postLoadedState = state as ProfilePostLoadedState;
        if (!isLoading) {
          isLoading = true;
          posts = await _apiRepository.fetchPostsByUserID(postLoadedState.currentPage + 1, 12, userID, "");

          //Handle 502 error
          if (posts.error != null && posts.error!.response!.statusCode == 502) {
            emit(ProfilePostLoadFailure("Bad Gateway", postLoadedState.currentPage + 1));
            isLoading = false;
            return;
          }
          //Handle 404 error
          if (posts.error != null && posts.error!.response!.statusCode == 404) {
            emit(ProfilePostLoadFailure("404 Not Found", postLoadedState.currentPage + 1));
            isLoading = false;
            return;
          }

          if (posts.data!.isEmpty) {
            emit(postLoadedState.copyWith(hasReachedMax: true));
            isLoading = false;
          } else {
            ListPostModel newList = ListPostModel(postLoadedState.posts!.data! + posts.data!);

            emit(ProfilePostLoadedState(posts: newList, hasReachedMax: false, currentPage: postLoadedState.currentPage + 1));
            isLoading = false;
          }
        }
      }
    }
  }
}
