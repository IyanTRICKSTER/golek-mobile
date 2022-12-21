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
          // log(state.toString());
        },
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
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
              PostLoadedState postLoadedState = state as PostLoadedState;
              return SafeArea(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: (postLoadedState.hasReachedMax) ? postLoadedState.posts!.data!.length : postLoadedState.posts!.data!.length + 1,
                  itemBuilder: (context, index) {
                    if (index < postLoadedState.posts!.data!.length) {
                      PostModel post = postLoadedState.posts!.data![index];
                      BookmarkModel bookmark = postLoadedState.bookmark!;
                      return Post(
                        listViewIndex: index,
                        postModel: post,
                        bookmarkModel: bookmark,
                        loggedInUserID: _sharedPreferencesManager.getInt(SharedPreferencesManager.keyUserID)!,
                        loggedInUsername: _sharedPreferencesManager.getString(SharedPreferencesManager.keyUsername)!,
                        onUpdateClicked: () {
                          PostBloc localPostBloc = PostBloc();
                          showModalBottomSheet<void>(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(
                                  6.0,
                                ),
                              ),
                            ),
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: ((BuildContext context, StateSetter modalSetState) {
                                  //
                                  final titleTextController = TextEditingController(text: post.title);
                                  final placeTextController = TextEditingController(text: post.place);
                                  final List<TextEditingController> characsInputControllers = [];
                                  final List<TextFormField> characsInput = [];

                                  for (var i = 0; i < post.characteristics.length; i++) {
                                    characsInputControllers.add(TextEditingController(text: post.characteristics[i].title));
                                    characsInput.add(
                                      TextFormField(
                                        controller: characsInputControllers[i],
                                        decoration: InputDecoration(
                                          border: const UnderlineInputBorder(),
                                          labelText: "${i + 1}",
                                        ),
                                      ),
                                    );
                                  }

                                  return Padding(
                                    padding: MediaQuery.of(context).viewInsets,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(6, 4, 6, 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          TextFormField(
                                            controller: titleTextController,
                                            decoration: const InputDecoration(
                                              border: UnderlineInputBorder(),
                                              labelText: 'Judul Post',
                                            ),
                                          ),
                                          TextFormField(
                                            controller: placeTextController,
                                            decoration: const InputDecoration(
                                              border: UnderlineInputBorder(),
                                              labelText: 'Tempat ditemukan',
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(top: 16.0),
                                            child: Text(
                                              "Ciri - ciri",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            children: characsInput,
                                          ),
                                          // ElevatedButton(
                                          //   onPressed: () {
                                          //     setState(() {
                                          //       characsInputControllers.add(TextEditingController(text: ""));
                                          //       characsInput.add(
                                          //         TextFormField(
                                          //           controller: characsInputControllers[characsInputControllers.length - 1],
                                          //           decoration: InputDecoration(
                                          //             border: const UnderlineInputBorder(),
                                          //             labelText: "${characsInputControllers.length}",
                                          //           ),
                                          //         ),
                                          //       );
                                          //       // log(characsInput.length.toString());
                                          //     });
                                          //   },
                                          //   child: const Icon(Icons.add),
                                          // ),
                                          // ElevatedButton(
                                          //   onPressed: () {
                                          //     setState(() {
                                          //       characsInputControllers.removeLast();
                                          //       characsInput.removeLast();
                                          //       // log(characsInput.length.toString());
                                          //     });
                                          //   },
                                          //   child: const Icon(Icons.remove),
                                          // ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color.fromARGB(255, 176, 39, 73),
                                              elevation: 3,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
                                              minimumSize: Size(MediaQuery.of(context).size.width, 42),
                                            ),
                                            child: const Text('Update'),
                                            onPressed: () {
                                              setState(() {
                                                post.title = titleTextController.text;
                                                post.place = placeTextController.text;
                                                for (var i = 0; i < post.characteristics.length; i++) {
                                                  post.characteristics[i].title = characsInputControllers[i].text;
                                                }
                                              });
                                              localPostBloc.close();
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              );
                            },
                          );
                        },
                        onDeleteClicked: () {
                          _postBloc.add(DeletePostEvent(postID: post.id));
                          setState(() {
                            postLoadedState.posts!.data!.removeAt(index);
                          });
                        },
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
