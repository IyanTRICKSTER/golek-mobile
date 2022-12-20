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

  void submitForm() {}

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostBloc(),
      child: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostUploadedState) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
                            // log(snapshot.data!.path.toString());

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
                                label: 'cancel',
                                onPressed: () {
                                  // Some code to undo the change.
                                },
                              ),
                            );

                            // Find the ScaffoldMessenger in the widget tree
                            // and use it to show a SnackBar.
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Judul Post',
                              ),
                            ),
                            TextFormField(
                              controller: placeController,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Tempat ditemukan',
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text("Ciri - ciri"),
                            ),
                            Column(
                              children: [
                                TextFormField(
                                  controller: input1,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
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
