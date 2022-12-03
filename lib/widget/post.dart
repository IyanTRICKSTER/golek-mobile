import 'package:flutter/material.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:golek_mobile/models/post/post_model.dart';
import 'package:golek_mobile/ui/request_confirmation.dart';

class Post extends StatefulWidget {
  final PostModel postModel;

  const Post({super.key, required this.postModel});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  String characs = "";

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
            mainAxisAlignment: MainAxisAlignment.start,
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
              )
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
              IconButton(
                onPressed: () => {print("Bookmark button clicked!")},
                icon: const Icon(
                  Icons.bookmark_add_outlined,
                  size: 29,
                ),
              ),
              IconButton(
                onPressed: () => {print("Chat button clicked!")},
                icon: const Icon(
                  Icons.chat_bubble_outline_sharp,
                  size: 27,
                ),
              ),
              IconButton(
                onPressed: () => {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const RequestConfirmation()));
                  }),
                },
                icon: const Icon(
                  Icons.handshake_outlined,
                  size: 27,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 0, bottom: 6, left: 14, right: 14),
          child: ExpandableText(
            "telah menemukan ${widget.postModel.title} di ${widget.postModel.place} dengan ciri ciri berikut: $characs\n ${characs = ''}",
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
