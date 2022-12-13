import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:golek_mobile/ui/camera/camera_ui.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = [];

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CameraScreenState();
  }
}

class _CameraScreenState extends State<CameraScreen> {
  Future<void> ensureCamera() async {
    try {
      cameras = await availableCameras();
    } on CameraException catch (e) {
      print('Error in fetching the cameras: $e');
    }
  }

  Future<bool> showStatusBar() async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
    // Navigator.pushNamedAndRemoveUntil(context, '/main_screen', (route) => false);
    Navigator.pop(context);
    return true;
  }

  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack, overlays: []);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    ensureCamera();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showStatusBar,
      child: const CameraUI(),
    );
  }
}
