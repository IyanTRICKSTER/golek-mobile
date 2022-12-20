import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golek_mobile/api/streamchat_provider.dart';
import 'package:golek_mobile/logic/bookmark/bookmark_bloc.dart';
import 'package:golek_mobile/models/bookmark/bookmark_model.dart';
import 'package:golek_mobile/models/post/post_model.dart';
import 'package:golek_mobile/ui/chat_screen.dart';
import 'package:golek_mobile/ui/request_confirmation.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class Post extends StatefulWidget {
  final PostModel postModel;
  final BookmarkModel bookmarkModel;
  final int loggedInUserID;
  final String loggedInUsername;
  final int listViewIndex;
  late bool isOwner;
  late Function? onDeleteClicked;
  late Function? onUpdateClicked;

  Post({
    super.key,
    required this.postModel,
    required this.loggedInUserID,
    required this.bookmarkModel,
    required this.loggedInUsername,
    required this.listViewIndex,
    this.onDeleteClicked,
    this.onUpdateClicked,
  }) {
    postModel.userID == loggedInUserID ? isOwner = true : isOwner = false;
  }

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final BookmarkBloc _bookmarkBloc = BookmarkBloc();
  late bool isBookmarked = false;
  late int? postIndex;
  String characs = "";

  bool isPostBookmarked(PostModel postModel, BookmarkModel bookmarkModel) {
    for (var i = 0; i < bookmarkModel.posts.length; i++) {
      if (bookmarkModel.posts[i].id == postModel.id) {
        postIndex = i;
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    isBookmarked = isPostBookmarked(widget.postModel, widget.bookmarkModel);
  }

  @override
  Widget build(BuildContext context) {
    int count = 1;
    for (var e in widget.postModel.characteristics) {
      characs += "\n ${count.toString()}. ${e.title}";
      count++;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage("assets/images/user.jpg"),
                        )),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.postModel.user.username,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        widget.postModel.user.usermajor,
                        style: const TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                ],
              ),
              widget.isOwner
                  ? PopupMenuButton(
                      padding: const EdgeInsets.all(0.0),
                      itemBuilder: ((context) {
                        return const [
                          PopupMenuItem<int>(
                            value: 0,
                            child: Center(child: Text("update")),
                          ),
                          PopupMenuItem<int>(
                            value: 1,
                            child: Center(
                              child: Text(
                                "remove",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ];
                      }),
                      onSelected: ((value) {
                        // log("index post: ${widget.listViewIndex}");
                        switch (value) {
                          case 0:
                            widget.onUpdateClicked!();
                            break;
                          case 1:
                            widget.onDeleteClicked!();
                            break;
                          default:
                        }
                      }),
                    )
                  : Container(),
            ],
          ),
        ),
        Container(
          height: 414,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(widget.postModel.imageUrl),
          )),
        ),
        Container(
          // color: Colors.red,
          padding: const EdgeInsets.only(bottom: 0),
          child: Row(
            children: [
              BlocProvider(
                create: (context) => _bookmarkBloc,
                child: BlocListener<BookmarkBloc, BookmarkState>(
                  listener: (context, state) {
                    if (state is BookmarkAddedState) {
                      isBookmarked = true;
                    }
                    if (state is BookmarkRevokedState) {
                      isBookmarked = false;
                    }
                    // log("Bookmark ${state.toString()}");
                  },
                  child: IconButton(onPressed: () {
                    setState(() {
                      if (isBookmarked) {
                        _bookmarkBloc.add(BookmarkRevokePostEvent(postID: widget.postModel.id));
                        if (postIndex != null) {
                          widget.bookmarkModel.posts.removeAt(postIndex!);
                        }
                      } else {
                        _bookmarkBloc.add(BookmarkAddPostEvent(postID: widget.postModel.id));
                        widget.bookmarkModel.posts.add(MarkedPostModel(widget.postModel.id, "", ""));
                      }
                      isBookmarked = !isBookmarked;
                    });

                    // print("Bookmark button clicked!");
                  }, icon: BlocBuilder<BookmarkBloc, BookmarkState>(
                    builder: (context, state) {
                      if (state is BookmarkLoadingState) {
                        return const Center(
                          child: SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              color: Color.fromARGB(255, 37, 35, 35),
                            ),
                          ),
                        );
                      }
                      return Icon(
                        isBookmarked ? Icons.bookmark_added : Icons.bookmark_add_outlined,
                        size: 29,
                      );
                    },
                  )),
                ),
              ),
              widget.isOwner
                  ? Container(
                      height: 0,
                      width: 0,
                      margin: EdgeInsets.all(0),
                    )
                  : IconButton(
                      onPressed: () => {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                client: StreamChat.of(context).client,
                                channel: StreamChatProvider.instance.setupChannel([widget.postModel.userID.toString()]),
                              ),
                            ),
                          );
                        }),
                      },
                      icon: const Icon(
                        Icons.chat_bubble_outline_sharp,
                        size: 27,
                      ),
                    ),
              widget.isOwner
                  ? !widget.postModel.isReturned
                      ? IconButton(
                          onPressed: () => {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RequestConfirmationScreen(
                                            postID: widget.postModel.id,
                                          )));
                            }),
                          },
                          icon: const Icon(
                            Icons.handshake_outlined,
                            size: 27,
                          ),
                        )
                      : Container()
                  : Container(),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 0, bottom: 6, left: 14, right: 14),
          child: ExpandableText(
            "telah menemukan ${widget.postModel.title} di ${widget.postModel.place} dengan ciri ciri berikut: $characs \n ${characs = ''}",
            expandText: 'selengkapnya',
            collapseText: '\nlebih sedikit',
            maxLines: 2,
            linkColor: const Color.fromARGB(255, 151, 151, 151),
            animation: true,
            collapseOnTextTap: true,
            prefixText: widget.postModel.user.username,
            // onPrefixTap: () => {},
            prefixStyle: const TextStyle(fontWeight: FontWeight.bold),
            // onHashtagTap: (name) => showHashtag(name),
            hashtagStyle: const TextStyle(
              color: Color(0xFF30B6F9),
            ),
            // onMentionTap: (username) => showProfile(username),
            mentionStyle: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
            // onUrlTap: (url) => launchUrl(url),
            urlStyle: const TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
        )
      ],
    );
  }
}
