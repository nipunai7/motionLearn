import 'dart:io';
import 'package:camera/camera.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:e_shop/Training/widget/orientation/landscape_player_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pip_view/pip_view.dart';

import '../main.dart';

class TrainingPage extends StatefulWidget {
  final ItemModel itemModel;

  TrainingPage(this.itemModel);

  @override
  _TrainingPageState createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  File file2;
  final picker = ImagePicker();
  CameraController cameraController;

  @override
  void initState() {
    super.initState();
    cameraController = CameraController(cameras[1], ResolutionPreset.medium);
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PIPView(builder: (context, isFloating) {
      return WillPopScope(
          onWillPop: () {
            // Navigator.pushReplacement(
            //     context, MaterialPageRoute(builder: (c) => StoreHome()));
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text("Training View"),
              centerTitle: true,
              backgroundColor: Colors.deepPurple,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (c) => ProductPage(
                                itemModel: widget.itemModel,
                                bought: true,
                              )));
                },
              ),
            ),
            body: Center(
              child: Container(
                padding: EdgeInsets.only(top: 20.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                        aspectRatio: cameraController.value.aspectRatio,
                        child: CameraPreview(cameraController)),
                    InkWell(
                        onTap: () {
                          setLandscape();
                          PIPView.of(context).presentBelow(
                              LandscapePlayerPage(widget.itemModel.videoUrl));
                        },
                        child: Column(
                          children: [
                            Icon(Icons.camera,size: 50.0,color: Colors.deepPurple,)
                          ],
                        ))
                  ],
                ),
              ),
            ),
          ));
    });
  }

  cameraCapture2() async {
    //Navigator.pop(context);
    final pickedFile = await picker.getVideo(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );
    setState(() {
      if (pickedFile != null) {
        file2 = File(pickedFile.path);
      } else {
        print('No Video selected.');
      }
    });
  }

  Future setLandscape() async {
    await SystemChrome.setEnabledSystemUIOverlays([]);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}
