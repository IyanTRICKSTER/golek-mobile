import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golek_mobile/logic/post/post_bloc.dart';
import 'package:golek_mobile/models/post/post_model.dart';
import 'package:path_provider/path_provider.dart';

class CreatePostScreen extends StatefulWidget {
  // final File? imageFile;

  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  List<Widget> characsInput = <Widget>[
    TextFormField(
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: '1',
      ),
    ),
    TextFormField(
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: '2',
      ),
    )
  ];

  Future<Directory> getFileDirectory() async {
    final dir = await getExternalStorageDirectory();
    final myImagePath = '${dir?.path}/MyImages';
    final directory = await Directory(myImagePath).create();

    return directory;
  }

  Future<File> getImageFile() async {
    final Directory directory = await getFileDirectory();
    File imageFile = File("${directory.path}/testpost.jpg");
    return imageFile;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostBloc(),
      child: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostUploadedState) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
        },
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            return FutureBuilder(
              future: getImageFile(),
              builder: (context, snapshot) {
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0.5,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(onPressed: () {}, child: const Icon(Icons.arrow_back)),
                        TextButton(
                          onPressed: () {
                            PostModel postData = PostModel("Kunci Motor 2", snapshot.data!.path.toString(),
                                <PostCharacteristic>[PostCharacteristic("kunci dua"), PostCharacteristic("jelek")], "Depan pintu");

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
                                    child: Text("Loading..."),
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
                          child: const Icon(Icons.arrow_forward),
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
                                        image: Image.file(snapshot.data!).image,
                                      ),
                                    ),
                                  );

                                  // return Image.file(snapshot.data!);
                                }
                                return Text("empty");
                              }),
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Judul Post',
                              ),
                            ),
                            TextFormField(
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
                              children: characsInput,
                            ),
                            TextButton(
                              onPressed: () {
                                characsInput.add(TextFormField(
                                  decoration: InputDecoration(
                                    border: const UnderlineInputBorder(),
                                    label: Text("${characsInput.length + 1}"),
                                  ),
                                ));
                                setState(() {});
                              },
                              child: const Icon(
                                Icons.add_rounded,
                                color: Colors.black,
                              ),
                            )
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
