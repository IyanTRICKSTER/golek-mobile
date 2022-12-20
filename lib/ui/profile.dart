import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golek_mobile/injector/injector.dart';
import 'package:golek_mobile/logic/bookmark/bookmark_bloc.dart';
import 'package:golek_mobile/logic/profile/posts/profile_posts_bloc.dart';
import 'package:golek_mobile/logic/profile/returned_posts/profile_returned_posts_bloc.dart';
import 'package:golek_mobile/models/bookmark/bookmark_model.dart';
import 'package:golek_mobile/models/post/post_model.dart';
import 'package:golek_mobile/storage/sharedpreferences_manager.dart';

import '../widget/mini_post.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<ProfileScreen> {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController(initialScrollOffset: 0.0);
  final SharedPreferencesManager _sharedPreferencesManager = locator<SharedPreferencesManager>();
  final ProfilePostBloc _profilePostBloc = ProfilePostBloc();
  final ProfileReturnedPostsBloc _profileReturnedPostsBloc = ProfileReturnedPostsBloc();
  final BookmarkBloc _bookmarkBloc = BookmarkBloc();
  int postRange = 0;
  int returnedPostRange = 0;
  int bookmarkPostRange = 0;

  Widget BuildImageProfile() {
    return ClipOval(
      child: Material(
          color: Colors.transparent,
          child: Ink.image(
            fit: BoxFit.cover,
            width: 128,
            height: 128,
            image: const AssetImage("assets/images/user.jpg"),
            child: InkWell(onTap: () => {}),
          )),
    );
  }

  Widget BuildEditProfileIcon() {
    return ClipOval(
        child: Container(
      padding: const EdgeInsets.all(8),
      color: const Color.fromRGBO(161, 20, 68, 1.0),
      child: const Icon(
        Icons.edit,
        color: Colors.white,
      ),
    ));
  }

  Widget BuildProfileInformation() {
    final double fontTitleSize = 13.0;
    final double fontSize = 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
            child: Text(
          "${_sharedPreferencesManager.getString(SharedPreferencesManager.keyUsername)}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        )),
        Center(
            child: Text(
          "${_sharedPreferencesManager.getString(SharedPreferencesManager.keyEmail)}",
          style: TextStyle(color: Colors.grey[600]),
        )),
        Container(
          padding: EdgeInsets.only(left: 44, top: 20, right: 44),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "NIM",
                  style: TextStyle(fontSize: fontTitleSize),
                ),
              ),
              Text(
                "11310920001112 static",
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "Major",
                  style: TextStyle(fontSize: fontTitleSize),
                ),
              ),
              Text(
                "Computer Science static",
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "Faculty",
                  style: TextStyle(fontSize: fontTitleSize),
                ),
              ),
              Text("Science & Technology static",
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  )),
              Divider(
                color: Colors.black,
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(() {
      if (_tabController.index == 1) {
        _profileReturnedPostsBloc.add(LoadProfileReturnedPostEvent());
      }
      if (_tabController.index == 2) {
        // _bookmarkBloc.add(BookmarkRefreshEvent());
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.95) {
        if (_tabController.index == 1) {
          _profileReturnedPostsBloc.add(LoadProfileReturnedPostEvent());
        } else if (_tabController.index == 0) {
          _profilePostBloc.add(LoadProfilePostEvent());
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              floating: true,
              backgroundColor: Colors.white,
              forceElevated: boxIsScrolled,
              expandedHeight: 500,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 22, bottom: 22),
                            child: BuildImageProfile(),
                          ),
                          Positioned(
                            right: 4,
                            bottom: 15,
                            child: BuildEditProfileIcon(),
                          )
                        ],
                      ),
                    ),
                    BuildProfileInformation(),
                  ],
                ),
              ),
              bottom: TabBar(
                indicatorColor: Colors.black,
                indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(width: 2.0),
                    insets: EdgeInsets.symmetric(
                      horizontal: 8.0,
                    )),
                labelColor: Colors.black,
                tabs: const <Widget>[
                  Tab(
                    text: "Post",
                    icon: Icon(
                      Icons.post_add,
                      color: Colors.black,
                    ),
                  ),
                  Tab(
                    text: "Returned",
                    icon: Icon(
                      Icons.check_box,
                      color: Colors.black,
                    ),
                  ),
                  Tab(
                    text: "Bookmark",
                    icon: Icon(
                      Icons.bookmark_added,
                      color: Colors.black,
                    ),
                  )
                ],
                controller: _tabController,
              ),
            )
          ];
        },
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => _profilePostBloc..add(LoadProfilePostEvent()),
            ),
            BlocProvider(
              create: (context) => _profileReturnedPostsBloc,
            ),
            BlocProvider(
              create: (context) => _bookmarkBloc..add(BookmarkRefreshEvent()),
            ),
          ],
          child: MultiBlocListener(
            listeners: [
              BlocListener<ProfilePostBloc, ProfilePostState>(
                listener: (context, state) {
                  //Item counter for post gridview builder
                  if (state is ProfilePostLoadedState) {
                    if (state.hasReachedMax) {
                      postRange = state.posts!.data!.length;
                    } else {
                      postRange = state.posts!.data!.length + 1;
                    }
                  }
                },
              ),
              BlocListener<ProfileReturnedPostsBloc, ProfileReturnedPostsState>(
                listener: (context, state) {
                  // log("state >> $state");
                  if (state is ProfileReturnedPostLoadedState) {
                    if (state.hasReachedMax) {
                      returnedPostRange = state.posts!.data!.length;
                    } else {
                      returnedPostRange = state.posts!.data!.length + 1;
                    }
                  }
                },
              ),
              BlocListener<BookmarkBloc, BookmarkState>(
                listener: (context, state) {
                  log("profile >> $state");
                  if (state is BookmarkRefreshState) {
                    // if (state.hasReachedMax) {
                    //   returnedPostRange = state.posts!.data!.length;
                    // } else {
                    //   returnedPostRange = state.posts!.data!.length + 1;
                    // }
                    bookmarkPostRange = state.bookmark!.posts.length;
                  }
                  if (state is BookmarkAddedState || state is BookmarkRevokedState) {
                    // context.read<BookmarkBloc>().add(BookmarkRefreshEvent());
                  }
                },
              )
            ],
            child: TabBarView(
              controller: _tabController,
              children: [
                BlocBuilder<ProfilePostBloc, ProfilePostState>(
                  builder: (context, state) {
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 150,
                        childAspectRatio: 3 / 4,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                      ),
                      itemCount: postRange,
                      itemBuilder: ((context, index) {
                        if (state is ProfilePostUninitialized) {
                          return const Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                color: Color.fromARGB(255, 37, 35, 35),
                              ),
                            ),
                          );
                        } else if (state is ProfilePostLoadFailure) {
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
                                        _profilePostBloc.add(LoadProfilePostEvent());
                                      },
                                      child: const Text("refresh"))
                                ],
                              ),
                            ),
                          );
                        } else {
                          ProfilePostLoadedState profilePostLoadedState = state as ProfilePostLoadedState;
                          if (index < profilePostLoadedState.posts!.data!.length) {
                            return MiniPost(
                              postModel: profilePostLoadedState.posts!.data![index],
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
                        }
                      }),
                    );
                  },
                ),
                BlocBuilder<ProfileReturnedPostsBloc, ProfileReturnedPostsState>(
                  builder: (context, state) {
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 150,
                        childAspectRatio: 3 / 5,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0,
                      ),
                      itemCount: returnedPostRange,
                      itemBuilder: ((context, index) {
                        if (state is ProfilePostUninitialized) {
                          return const Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                color: Color.fromARGB(255, 37, 35, 35),
                              ),
                            ),
                          );
                        } else if (state is ProfileReturnedPostLoadFailure) {
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
                                        _profileReturnedPostsBloc.add(LoadProfileReturnedPostEvent());
                                      },
                                      child: const Text("refresh"))
                                ],
                              ),
                            ),
                          );
                        } else {
                          ProfileReturnedPostLoadedState profileReturnedPostLoadedState = state as ProfileReturnedPostLoadedState;
                          if (index < profileReturnedPostLoadedState.posts!.data!.length) {
                            return MiniPost(
                              postModel: profileReturnedPostLoadedState.posts!.data![index],
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
                        }
                      }),
                    );
                  },
                ),
                BlocBuilder<BookmarkBloc, BookmarkState>(
                  builder: (context, state) {
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 150,
                        childAspectRatio: 3 / 5,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0,
                      ),
                      itemCount: bookmarkPostRange,
                      itemBuilder: ((context, index) {
                        if (state is BookmarkInitial) {
                          return const Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                color: Color.fromARGB(255, 37, 35, 35),
                              ),
                            ),
                          );
                        } else if (state is BookmarkLoadFailureState) {
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
                                        // _bookmarkBloc.add(BookmarkLoadEvent());
                                        context.read<BookmarkBloc>().add(BookmarkRefreshEvent());
                                      },
                                      child: const Text("refresh"))
                                ],
                              ),
                            ),
                          );
                        } else if (state is BookmarkRefreshState) {
                          BookmarkRefreshState bookmarkLoadedState = state;
                          if (index < bookmarkLoadedState.bookmark!.posts.length) {
                            MarkedPostModel markedPostModel = bookmarkLoadedState.bookmark!.posts[index];
                            return MiniPost(
                              postModel: PostModel(
                                markedPostModel.id,
                                markedPostModel.title,
                                markedPostModel.imageUrl,
                                <PostCharacteristic>[
                                  PostCharacteristic(""),
                                ],
                                "",
                              ),
                            );
                          }
                        } else {
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
                        }
                        return Container();
                      }),
                    );
                  },
                )
              ],

              // children: <Widget>[
              //   GridView.count(
              //     crossAxisCount: 3,
              //     padding: EdgeInsets.all(10),
              //     children: [
              //       MiniPost(),
              //       MiniPost(),
              //       MiniPost(),
              //       MiniPost(),
              //       MiniPost(),
              //       MiniPost(),
              //       MiniPost(),
              //       MiniPost(),
              //       MiniPost(),
              //     ],
              //   ),
              //   GridView.count(
              //     crossAxisCount: 3,
              //     padding: EdgeInsets.all(10),
              //     children: [
              //       MiniPost(),
              //       MiniPost(),
              //     ],
              //   ),
              //   GridView.count(
              //     crossAxisCount: 3,
              //     padding: EdgeInsets.all(10),
              //     children: [
              //       MiniPost(),
              //     ],
              //   ),
              // ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
