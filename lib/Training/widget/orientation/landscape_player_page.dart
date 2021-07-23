import 'dart:io';

import 'package:camera/camera.dart';
import 'package:e_shop/Training/widget/orientation/video_player_fullscreen_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

import '../../../main.dart';

class LandscapePlayerPage extends StatefulWidget {
  String url;

  LandscapePlayerPage(this.url);

  @override
  _LandscapePlayerPageState createState() => _LandscapePlayerPageState();
}

class _LandscapePlayerPageState extends State<LandscapePlayerPage> {
  VideoPlayerController controller;

  // CameraController cameraController;
  //String videoPath;

  @override
  void initState() {
    super.initState();
    // cameraController = CameraController(cameras[1], ResolutionPreset.medium);
    // cameraController.initialize().then((_) {
    //   if (!mounted) {
    //     return;
    //   }
    // });

    controller = VideoPlayerController.network(widget.url)
      ..addListener(() => setState(() {}))
      ..setLooping(false)
      ..initialize();
    controller.addListener(() {
      //stopRecord();
    });

    setLandscape();
  }

  @override
  void dispose() {
    controller.dispose();
    setAllOrientations();
    super.dispose();
  }

  Future setLandscape() async {
    await SystemChrome.setEnabledSystemUIOverlays([]);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    await Wakelock.enable();
  }

  Future setAllOrientations() async {
    await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);

    await Wakelock.disable();
  }

  @override
  Widget build(BuildContext context) =>
      VideoPlayerFullscreenWidget(controller: controller);

// void stopRecord() async{
//   if (controller.value.position == Duration(seconds: 0,minutes: 0,hours: 0)){
//     print("Started: ");
//
//     final Directory appDirectory = await getTemporaryDirectory();
//     final String videoDirectory = '${appDirectory.path}/Videos';
//     await Directory(videoDirectory).create(recursive: true);
//     final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
//     final String filePath = '$videoDirectory/$currentTime.mp4';
//
//     try {
//       await cameraController.startVideoRecording(filePath);
//       print('File path: '+ filePath);
//       videoPath = filePath;
//     } on CameraException catch (e) {
//       _showCameraException(e);
//     }
//   }
//
//  if (controller.value.position == controller.value.duration){
//     print("Ended");
//       try {
//         await cameraController.stopVideoRecording();
//       } on CameraException catch (e) {
//         _showCameraException(e);
//       }
//
//   }
// }
//
// void _showCameraException(CameraException e) {
//   String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
//   print(errorText);
//
//   Fluttertoast.showToast(
//       msg: 'Error: ${e.code}\n${e.description}',
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.CENTER,
//       timeInSecForIos: 1,
//       backgroundColor: Colors.red,
//       textColor: Colors.white
//   );
// }
}
