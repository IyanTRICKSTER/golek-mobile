import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:golek_mobile/api/api_repository.dart';
import 'package:golek_mobile/models/post/post_model.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final APIRepository _apiRepository = APIRepository();
  bool isLoading = false;

  PostBloc() : super(PostUninitialized()) {
    on<LoadPostEvent>(_fetchPost);
    on<UploadPostEvent>(_uploadPost);
  }

  Future<void> _fetchPost(LoadPostEvent event, Emitter emit) async {
    ListPostModel posts;

    //If State is loaded first time, then load data from page 1
    if (state is PostUninitialized) {
      if (!isLoading) {
        isLoading = true;
        posts = await _apiRepository.fetchPosts(1, 5);
        //if server down, emit bad gateway error
        if (posts.error != null && posts.error!.response!.statusCode == 502) {
          emit(PostLoadFailure("Bad Gateway", 1));
          isLoading = false;
          return;
        }
        //otherwise, emit posts data
        emit(PostLoadedState(posts: posts, hasReachedMax: false, currentPage: 1));
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
          emit(PostLoadedState(posts: posts, hasReachedMax: false, currentPage: 1));
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
            ListPostModel newList = ListPostModel(postLoadedState.posts.data! + posts.data!);

            emit(PostLoadedState(posts: newList, hasReachedMax: false, currentPage: postLoadedState.currentPage + 1));
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
}
