import 'package:flutter/material.dart';
import 'package:golek_mobile/models/post/post_model.dart';

class MiniPost extends StatefulWidget {
  PostModel postModel;

  MiniPost({super.key, required this.postModel});

  @override
  State<StatefulWidget> createState() => _MiniPostState();
}

class _MiniPostState extends State<MiniPost> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      height: 120,
      width: 120,
      child: Image.network(
        widget.postModel.imageUrl,
      ),
    );
  }
}
