import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:golek_mobile/ui/camera/camera_screen.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = [];

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CameraPageState();
  }
}

class _CameraPageState extends State<CameraPage> {
  Future<void> ensureCamera() async {
    try {
      cameras = await availableCameras();
    } on CameraException catch (e) {
      print('Error in fetching the cameras: $e');
    }
  }

  Future<bool> showStatusBar() async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    ensureCamera();
    return WillPopScope(
      onWillPop: showStatusBar,
      child: const CameraScreen(),
    );
  }
}
