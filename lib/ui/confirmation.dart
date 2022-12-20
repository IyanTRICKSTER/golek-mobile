import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:golek_mobile/logic/post/post_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ConfirmationPostScreen extends StatefulWidget {
  const ConfirmationPostScreen({super.key});

  @override
  State<ConfirmationPostScreen> createState() => _ConfirmationPostScreenState();
}

class _ConfirmationPostScreenState extends State<ConfirmationPostScreen> {
  final PostBloc _postBloc = PostBloc();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    if (controller != null && mounted) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          // Expanded(
          //   flex: 1,
          //   child: FittedBox(
          //     fit: BoxFit.contain,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: <Widget>[
          //         if (result != null) Text('Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}') else const Text('Scan a code'),
          //         result != null
          //             ? TextButton(
          //                 onPressed: () => showDialog<String>(
          //                   context: context,
          //                   builder: (BuildContext context) => AlertDialog(
          //                     title: const Text('AlertDialog Title'),
          //                     content: const Text('AlertDialog description'),
          //                     actions: <Widget>[
          //                       TextButton(
          //                         onPressed: () => Navigator.pop(context, 'Cancel'),
          //                         child: const Text('Cancel'),
          //                       ),
          //                       TextButton(
          //                         onPressed: () => Navigator.pop(context, 'OK'),
          //                         child: const Text('OK'),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //                 child: const Text('Show Dialog'),
          //               )
          //             : Container(),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: <Widget>[
          //             Container(
          //               margin: const EdgeInsets.all(8),
          //               child: ElevatedButton(
          //                   onPressed: () async {
          //                     await controller?.toggleFlash();
          //                     setState(() {});
          //                   },
          //                   child: FutureBuilder(
          //                     future: controller?.getFlashStatus(),
          //                     builder: (context, snapshot) {
          //                       return Text('Flash: ${snapshot.data}');
          //                     },
          //                   )),
          //             ),
          //             Container(
          //               margin: const EdgeInsets.all(8),
          //               child: ElevatedButton(
          //                   onPressed: () async {
          //                     await controller?.flipCamera();
          //                     setState(() {});
          //                   },
          //                   child: FutureBuilder(
          //                     future: controller?.getCameraInfo(),
          //                     builder: (context, snapshot) {
          //                       if (snapshot.data != null) {
          //                         return Text('Camera facing ${describeEnum(snapshot.data!)}');
          //                       } else {
          //                         return const Text('loading');
          //                       }
          //                     },
          //                   )),
          //             )
          //           ],
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: <Widget>[
          //             Container(
          //               margin: const EdgeInsets.all(8),
          //               child: ElevatedButton(
          //                 onPressed: () async {
          //                   await controller?.pauseCamera();
          //                 },
          //                 child: const Text('pause', style: TextStyle(fontSize: 20)),
          //               ),
          //             ),
          //             Container(
          //               margin: const EdgeInsets.all(8),
          //               child: ElevatedButton(
          //                 onPressed: () async {
          //                   await controller?.resumeCamera();
          //                 },
          //                 child: const Text('resume', style: TextStyle(fontSize: 20)),
          //               ),
          //             )
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 250.0 : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: const Color.fromARGB(255, 98, 255, 216), borderRadius: 0, borderLength: 30, borderWidth: 5, cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        // result = scanData;
        _validatePost(scanData);
      });
    });
  }

  void _validatePost(Barcode barcodeResult) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => BlocProvider(
        create: (context) => _postBloc,
        child: BlocListener<PostBloc, PostState>(
          listener: (context, state) {
            log(state.toString());
          },
          child: BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              if (state is PostValidateTokenSuccessState) {
                return AlertDialog(
                  title: const Text("Konfirmasi berhasil"),
                  content: const SizedBox(
                    height: 30,
                    width: 30,
                    child: Icon(Icons.check_sharp),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/main_screen', (route) => false),
                      child: const Text('Kembali'),
                    ),
                  ],
                );
              }
              if (state is PostValidateTokenLoadingState) {
                return const AlertDialog(
                  title: Text("Loading"),
                  content: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 37, 35, 35),
                    ),
                  ),
                );
              }
              return AlertDialog(
                title: const Text('Konfirmasi pengembalian barang?'),
                // content: state is PostValidateTokenSuccessState ? const Text('Validasi berhasil') : const Text(""),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () {
                      _postBloc.add(PostValidateTokenEvent(jsonStringPayload: barcodeResult.code!.toString()));
                      // Navigator.pop(context);
                    },
                    child: const Text('Lanjut'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
