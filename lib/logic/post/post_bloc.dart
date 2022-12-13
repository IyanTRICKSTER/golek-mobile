import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:golek_mobile/api/api_repository.dart';
import 'package:golek_mobile/injector/injector.dart';
import 'package:golek_mobile/models/bookmark/bookmark_model.dart';
import 'package:golek_mobile/models/post/post_model.dart';
import 'package:golek_mobile/models/post_validation/post_validation_model.dart';
import 'package:golek_mobile/storage/sharedpreferences_manager.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final APIRepository _apiRepository = APIRepository();
  final SharedPreferencesManager _sharedPreferencesManager = locator<SharedPreferencesManager>();
  late final int userID;
  bool isLoading = false;
  late BookmarkModel bookmark;

  PostBloc() : super(PostUninitialized()) {
    userID = _sharedPreferencesManager.getInt(SharedPreferencesManager.keyUserID)!;
    on<LoadPostEvent>(_fetchPost);
    on<UploadPostEvent>(_uploadPost);
    on<PostRequestValidationTokenEvent>(_requestPostValidationToken);
    on<PostValidateTokenEvent>(_validatePostOwner);
  }

  Future<void> _fetchPost(LoadPostEvent event, Emitter emit) async {
    ListPostModel posts;

    //If State is loaded first time, then load data from page 1
    if (state is PostUninitialized) {
      if (!isLoading) {
        isLoading = true;
        posts = await _apiRepository.fetchPosts(1, 5);
        bookmark = await _apiRepository.fetchBookmarkByUserID(userID);

        //If load bookmark failed, then set empty bookmark;
        if (bookmark.error != null && bookmark.error!.isNotEmpty) {
          bookmark = BookmarkModel("", "", <MarkedPostModel>[]);
        }

        //if server down, emit bad gateway error
        if (posts.error != null && posts.error!.response!.statusCode == 502 || bookmark.error != null) {
          emit(PostLoadFailure("Bad Gateway", 1));
          isLoading = false;
          return;
        }
        if (posts.error != null && posts.error!.response!.statusCode == 404) {
          emit(PostLoadFailure("404 Not Found", 1));
          isLoading = false;
          return;
        }
        //otherwise, emit posts data
        emit(PostLoadedState(
          posts: posts,
          hasReachedMax: false,
          currentPage: 1,
          bookmark: bookmark,
        ));
        isLoading = false;
      }
    } else {
      //if still error, emit bad gateway error
      if (state is PostLoadFailure) {
        PostLoadFailure postLoadFailure = state as PostLoadFailure;
        if (!isLoading) {
          isLoading = true;
          posts = await _apiRepository.fetchPosts(postLoadFailure.lastPage, 5);
          if (posts.error != null && posts.error!.response!.statusCode == 502) {
            emit(PostLoadFailure("Bad Gateway", postLoadFailure.lastPage));
            isLoading = false;
            return;
          }
          if (posts.error != null && posts.error!.response!.statusCode == 404) {
            emit(PostLoadFailure("404 Not Found", 1));
            isLoading = false;
            return;
          }
          emit(PostLoadedState(
            posts: posts,
            hasReachedMax: false,
            currentPage: 1,
            bookmark: bookmark,
          ));
          isLoading = false;
        }
      } else {
        PostLoadedState postLoadedState = state as PostLoadedState;
        if (!isLoading) {
          isLoading = true;
          posts = await _apiRepository.fetchPosts(postLoadedState.currentPage + 1, 5);
          if (posts.error != null && posts.error!.response!.statusCode == 502) {
            emit(PostLoadFailure("Bad Gateway", postLoadedState.currentPage + 1));
            isLoading = false;
            return;
          }

          if (posts.data!.isEmpty) {
            emit(postLoadedState.copyWith(hasReachedMax: true));
            isLoading = false;
          } else {
            ListPostModel newList = ListPostModel(postLoadedState.posts!.data! + posts.data!);

            emit(PostLoadedState(
              posts: newList,
              hasReachedMax: false,
              currentPage: postLoadedState.currentPage + 1,
              bookmark: bookmark,
            ));
            isLoading = false;
          }
        }
      }
    }
  }

  Future<void> _uploadPost(UploadPostEvent event, Emitter emit) async {
    emit(PostLoadingState());

    PostModel res = await _apiRepository.uploadPost(event.postModel);

    if (res.error == null) {
      emit(PostUploadedState(res));
      return;
    }
  }

  Future<void> _requestPostValidationToken(PostRequestValidationTokenEvent event, Emitter emit) async {
    emit(PostRequestValidationTokenLoadingState());

    PostValidationResponseModel response = await _apiRepository.requestPostValidationToken(event.postID);

    if (response.error != null) {
      emit(PostRequestValidationTokenFailureState(error: response.error!));
      return;
    }

    emit(PostRequestValidationTokenSuccessState(qrCodeUrl: response.qrCodeUrl!));
    return;
  }

  Future<void> _validatePostOwner(PostValidateTokenEvent event, Emitter emit) async {
    emit(PostValidateTokenLoadingState());

    final payload = jsonDecode(event.jsonStringPayload.replaceAll(RegExp(r"\\"), ""));
    if (payload["post_id"] == null || payload["post_id"] == "") {
      emit(const PostValidateTokenFailureState(error: "post_id is required in json structure!"));
      return;
    }
    if (payload["hash"] == null || payload["hash"] == "") {
      emit(const PostValidateTokenFailureState(error: "hash token is required in json structure!"));
      return;
    }

    log(payload.toString());

    Response response =
        await _apiRepository.postValidate(PostValidationRequestModel(postID: payload["post_id"], ownerID: userID, hash: payload["hash"]));
    if (response.statusCode != 200) {
      emit(PostValidateTokenFailureState(error: response.data["error"]));
    }
    emit(PostValidateTokenSuccessState());
  }
}
