import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golek_mobile/injector/injector.dart';
import 'package:golek_mobile/logic/post/post_bloc.dart';
import 'package:golek_mobile/models/post/post_model.dart';
import 'package:golek_mobile/ui/home.dart';
import 'package:path_provider/path_provider.dart';

class CreatePostScreen extends StatefulWidget {
  // String? imageFile;
  File? imageFile;

  CreatePostScreen({super.key, this.imageFile});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController placeController = TextEditingController();

  final TextEditingController input1 = TextEditingController();
  final TextEditingController input3 = TextEditingController();
  final TextEditingController input2 = TextEditingController();

  // List<Widget> characsInput = <Widget>[];

  Future<Directory> getFileDirectory() async {
    final dir = await getExternalStorageDirectory();
    final myImagePath = '${dir?.path}/MyImages';
    final directory = await Directory(myImagePath).create();

    return directory;
  }

  Future<String> getImageFile() async {
    // final Directory directory = await getFileDirectory();
    // File imageFile = File("${directory.path}/100.jpg");
    // return imageFile;
    return "custom path";
  }

  @override
  void initState() {
    super.initState();
  }

  String? get _titleErrorText {
    // at any time, we can get the text from _controller.value.text
    final text = titleController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length < 3) {
      return 'Too short';
    }
    // return null if the text is valid
    return null;
  }

  String? get _placeErrorText {
    // at any time, we can get the text from _controller.value.text
    final text = placeController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length < 3) {
      return 'Too short';
    }
    // return null if the text is valid
    return null;
  }

  String? get _charac1ErrorText {
    // at any time, we can get the text from _controller.value.text
    final text = input1.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length < 3) {
      return 'Too short';
    }
    // return null if the text is valid
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostBloc(),
      child: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostUploadedState) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            Navigator.pushNamedAndRemoveUntil(context, "/main_screen", (route) => false);
          }
        },
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            return FutureBuilder(
              future: getImageFile(),
              builder: (context, snapshot) {
                return Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                    // actions: [],
                    elevation: 0.5,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back, color: Colors.black)),
                        TextButton(
                          onPressed: () {
                            if (_titleErrorText == null && _placeErrorText == null && _charac1ErrorText == null) {
                              PostModel postData = PostModel(
                                "",
                                titleController.text,
                                widget.imageFile!.path,
                                <PostCharacteristic>[
                                  PostCharacteristic(input1.text),
                                  PostCharacteristic(input2.text),
                                  PostCharacteristic(input3.text),
                                ],
                                placeController.text,
                              );

                              BlocProvider.of<PostBloc>(context).add(UploadPostEvent(postData));

                              final snackBar = SnackBar(
                                duration: const Duration(minutes: 1),
                                content: Row(
                                  children: const [
                                    SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 12.0),
                                      child: Text("Mengunggah post..."),
                                    )
                                  ],
                                ),
                                action: SnackBarAction(
                                  textColor: Colors.red,
                                  label: 'cancel',
                                  onPressed: () {
                                    // Some code to undo the change.
                                  },
                                ),
                              );

                              // Find the ScaffoldMessenger in the widget tree
                              // and use it to show a SnackBar.
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          },
                          child: const Icon(
                            Icons.check,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
                        child: Column(
                          children: [
                            FutureBuilder(
                              future: getImageFile(),
                              builder: ((context, snapshot) {
                                if (snapshot.hasData) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height / 2.3,
                                    decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image: Image.file(widget.imageFile!).image,
                                      ),
                                    ),
                                  );

                                  // return Image.file(snapshot.data!);
                                }
                                return Text("empty");
                              }),
                            ),
                            TextFormField(
                              controller: titleController,
                              decoration: InputDecoration(
                                border: const UnderlineInputBorder(),
                                labelText: 'Judul Post',
                              ),
                            ),
                            TextFormField(
                              controller: placeController,
                              decoration: InputDecoration(
                                border: const UnderlineInputBorder(),
                                labelText: 'Tempat ditemukan',
                              ),
                            ),
                            Divider(),
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                "Tuliskan ciri-ciri barang agar mudah dikenali pemilik!",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Column(
                              children: [
                                TextFormField(
                                  controller: input1,
                                  decoration: InputDecoration(
                                    border: const UnderlineInputBorder(),
                                    labelText: '1',
                                  ),
                                ),
                                TextFormField(
                                  controller: input2,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: '2',
                                  ),
                                ),
                                TextFormField(
                                  controller: input3,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: '3',
                                  ),
                                )
                              ],
                            ),
                            // TextButton(
                            //   onPressed: () {
                            //     characsInput.add(TextFormField(
                            //       decoration: InputDecoration(
                            //         border: const UnderlineInputBorder(),
                            //         label: Text("${characsInput.length + 1}"),
                            //       ),
                            //     ));
                            //     setState(() {});
                            //   },
                            //   child: const Icon(
                            //     Icons.add_rounded,
                            //     color: Colors.black,
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
