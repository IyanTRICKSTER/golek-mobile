import 'package:flutter/material.dart';

class MiniPost extends StatefulWidget {
  const MiniPost({super.key});

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
      child: Image.asset("assets/images/post1.jpeg"),
    );
  }
}
