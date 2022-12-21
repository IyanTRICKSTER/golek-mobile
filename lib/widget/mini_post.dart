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
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: FittedBox(
        fit: BoxFit.fill,
        child: Image.network(
          widget.postModel.imageUrl == ""
              ? "https://user-images.githubusercontent.com/24848110/33519396-7e56363c-d79d-11e7-969b-09782f5ccbab.png"
              : widget.postModel.imageUrl,
        ),
      ),
    );
  }
}
