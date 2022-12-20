import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golek_mobile/logic/post/post_bloc.dart';
import 'package:golek_mobile/models/post/post_model.dart';
import 'package:golek_mobile/widget/mini_post.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchState();
}

class _SearchState extends State<SearchScreen> with AutomaticKeepAliveClientMixin<SearchScreen> {
  final TextEditingController searchInput = TextEditingController();
  final PostBloc _postBloc = PostBloc();
  final ScrollController _scrollController = ScrollController(initialScrollOffset: 0.0);
  int postRange = 0;
  bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: TextField(
          controller: searchInput,
          cursorColor: const Color.fromARGB(255, 163, 4, 33),
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black12),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 163, 4, 33)),
            ),
            hintText: 'Cari barang',
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              _postBloc.add(SearchPostEvent(keyword: searchInput.text));
            }
          },
        ),
      ),
      body: BlocProvider(
        create: (context) => _postBloc,
        child: BlocListener<PostBloc, PostState>(
          listener: (context, state) {
            if (state is PostLoadedState) {
              if (state.posts!.data!.isEmpty) {
                postRange = 0;
                isEmpty = true;
              }
              if (state.hasReachedMax) {
                postRange = state.posts!.data!.length;
              } else {
                postRange = state.posts!.data!.length + 1;
              }
            }
          },
          child: BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              if (postRange == 0 && isEmpty) {
                return const Center(
                    child: Text(
                  "Hasil tidak ditemukan",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ));
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  childAspectRatio: 3 / 4,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                ),
                itemCount: postRange,
                itemBuilder: ((context, index) {
                  if (state is PostUninitializedState) {
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
                    PostLoadedState profilePostLoadedState = state as PostLoadedState;
                    if (index < profilePostLoadedState.posts!.data!.length) {
                      return MiniPost(
                        postModel: profilePostLoadedState.posts!.data![index],
                      );
                    }
                    return Container();
                    // return Container(
                    //   margin: const EdgeInsets.only(top: 8, bottom: 8),
                    //   child: const Center(
                    //     child: SizedBox(
                    //       height: 30,
                    //       width: 30,
                    //       child: CircularProgressIndicator(
                    //         color: Color.fromARGB(255, 37, 35, 35),
                    //       ),
                    //     ),
                    //   ),
                    // );
                  }
                }),
              );
              // return GridView.builder(
              //   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              //     maxCrossAxisExtent: 150,
              //     childAspectRatio: 3 / 3,
              //     crossAxisSpacing: 0,
              //     mainAxisSpacing: 0,
              //   ),
              //   itemCount: 20,
              //   itemBuilder: ((context, index) {
              //     return MiniPost(
              //       postModel: PostModel(
              //         "1234",
              //         "titile",
              //         "https://smaller-pictures.appspot.com/images/dreamstime_xxl_65780868_small.jpg",
              //         [PostCharacteristic("wow")],
              //         "Near house",
              //       ),
              //     );
              //   }),
              //   physics: const AlwaysScrollableScrollPhysics(),
              // );
            },
          ),
        ),
      ),
      // body: GridView.count(
      //   crossAxisCount: 3,
      //   padding: const EdgeInsets.all(10),
      //   children: const [
      //     // MiniPost(),
      //     // MiniPost(),
      //     // MiniPost(),
      //     // MiniPost(),
      //     // MiniPost(),
      //     // MiniPost(),
      //     // MiniPost(),
      //     // MiniPost(),
      //     // MiniPost(),
      //     // MiniPost(),
      //     // MiniPost(),
      //     // MiniPost(),
      //     // MiniPost(),
      //     // MiniPost(),
      //     // MiniPost(),
      //     // MiniPost(),
      //     // MiniPost(),
      //     // MiniPost(),
      //     // MiniPost(),
      //     // MiniPost()
      //   ],
      // ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
