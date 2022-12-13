import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golek_mobile/logic/post/post_bloc.dart';

class RequestConfirmationScreen extends StatefulWidget {
  final String postID;

  const RequestConfirmationScreen({super.key, required this.postID});

  @override
  State<RequestConfirmationScreen> createState() => _RequestConfirmationScreenState();
}

class _RequestConfirmationScreenState extends State<RequestConfirmationScreen> {
  final PostBloc _postBloc = PostBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: _buildQrCodeImage(),
    );
  }

  @override
  void initState() {
    _postBloc.add(PostRequestValidationTokenEvent(postID: widget.postID));
    super.initState();
  }

  Widget _buildQrCodeImage() {
    return BlocProvider(
      create: (context) => _postBloc,
      child: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostRequestValidationTokenLoadingState) {
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
          if (state is PostRequestValidationTokenSuccessState) {
            return Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                SizedBox(
                  height: 260,
                  width: 260,
                  child: Image.network(state.qrCodeUrl),
                ),
                const Text(
                  "Scan dari device pemilik barang",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ]),
            );
          }
          return Container();
        },
      ),
    );
  }
}
