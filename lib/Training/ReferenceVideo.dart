import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReferenceVideo extends StatefulWidget {
  const ReferenceVideo({Key key}) : super(key: key);

  @override
  _ReferenceVideoState createState() => _ReferenceVideoState();
}

class _ReferenceVideoState extends State<ReferenceVideo> {
  VideoPlayerController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    controller = VideoPlayerController.network(
        'https://firebasestorage.googleapis.com/v0/b/motion-learn.appspot.com/o/Items%2Ftutorial_1623178249763.mp4?alt=media&token=22613cc6-9ab6-46db-b6a8-4aec4da34a7a')
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => controller.play());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
          extendBodyBehindAppBar: true,
    );
  }
}
