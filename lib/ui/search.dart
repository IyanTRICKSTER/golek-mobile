import 'package:flutter/material.dart';
import 'package:golek_mobile/widget/mini_post.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchState();
}

class _SearchState extends State<SearchScreen> with AutomaticKeepAliveClientMixin<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: const TextField(
            decoration: InputDecoration(
              hoverColor: Colors.deepPurpleAccent,
              border: UnderlineInputBorder(),
              hintText: 'Search Item',
            ),
          ),
        ),
        body: GridView.count(
          crossAxisCount: 3,
          padding: const EdgeInsets.all(10),
          children: const [
            MiniPost(),
            MiniPost(),
            MiniPost(),
            MiniPost(),
            MiniPost(),
            MiniPost(),
            MiniPost(),
            MiniPost(),
            MiniPost(),
            MiniPost(),
            MiniPost(),
            MiniPost(),
            MiniPost(),
            MiniPost(),
            MiniPost(),
            MiniPost(),
            MiniPost(),
            MiniPost(),
            MiniPost(),
            MiniPost()
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
