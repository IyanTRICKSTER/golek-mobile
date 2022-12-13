import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golek_mobile/injector/injector.dart';
import 'package:golek_mobile/logic/post/post_bloc.dart';
import 'package:golek_mobile/models/bookmark/bookmark_model.dart';
import 'package:golek_mobile/models/post/post_model.dart';
import 'package:golek_mobile/storage/sharedpreferences_manager.dart';
import 'package:golek_mobile/widget/post.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin<HomeScreen> {
  final SharedPreferencesManager _sharedPreferencesManager = locator<SharedPreferencesManager>();
  final ScrollController _scrollController = ScrollController();
  final PostBloc _postBloc = PostBloc();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.95) {
        _postBloc.add(LoadPostEvent());
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider(
      create: (context) => _postBloc..add(LoadPostEvent()),
      child: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          // if (state is PostLoadedState) {
          //   log("wkwk!!");
          // }
          // log(state.toString());
        },
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostUninitialized) {
              return const Center(
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 37, 35, 35),
                  ),
                ),
              );
            } else if (state is PostLoadFailure) {
              return Center(
                child: SizedBox(
                  // height: 30,
                  // width: 30,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.error,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            _postBloc.add(LoadPostEvent());
                          },
                          child: const Text("refresh"))
                    ],
                  ),
                ),
              );
            } else {
              PostLoadedState postLoadedState = state as PostLoadedState;
              return SafeArea(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: (postLoadedState.hasReachedMax) ? postLoadedState.posts!.data!.length : postLoadedState.posts!.data!.length + 1,
                  itemBuilder: (context, index) {
                    if (index < postLoadedState.posts!.data!.length) {
                      PostModel post = postLoadedState.posts!.data![index];
                      BookmarkModel bookmark = postLoadedState.bookmark;
                      return Post(
                        postModel: post,
                        bookmarkModel: bookmark,
                        loggedInUserID: _sharedPreferencesManager.getInt(SharedPreferencesManager.keyUserID)!,
                      );
                    }
                    return Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 8),
                      child: const Center(
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            color: Color.fromARGB(255, 37, 35, 35),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );

    // return SingleChildScrollView(
    //   child: Column(children: [
    //     Post(
    //       username: "Iyan",
    //       userMajor: "Teknik Informatika",
    //     ),
    //     Post(
    //       username: "Putra",
    //       userMajor: "Sistem Informasi",
    //     ),
    //     Post(
    //       username: "Iyan",
    //       userMajor: "Teknik Informatika",
    //     ),
    //     Post(
    //       username: "Putra",
    //       userMajor: "Sistem Informasi",
    //     ),
    //   ]),
    // );
  }

  @override
  bool get wantKeepAlive => true;
}
