import 'package:flutter/material.dart';

class RequestConfirmation extends StatefulWidget {
  const RequestConfirmation({super.key});

  @override
  State<RequestConfirmation> createState() => _RequestConfirmationState();
}

class _RequestConfirmationState extends State<RequestConfirmation> {
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

  Widget _buildQrCodeImage() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Container(
          height: 260,
          width: 260,
          child: Image.network("https://resources.infosecinstitute.com/wp-content/uploads/032915_0005_SecurityAtt1.png"),
        ),
        Text(
          "Scan dari device pemilik barang",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ]),
    );
  }
}
