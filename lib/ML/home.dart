import 'package:camera/camera.dart';
import 'package:e_shop/main.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class MLPage extends StatefulWidget {


  @override
  _MLPagestate createState() => _MLPagestate();
}

class _MLPagestate extends State<MLPage>{

  double imgHeight;
  double imgWidth;
  List recognitionsList;
  CameraImage imgCamera;
  CameraController cameraController;
  bool isWorking = false;


  initCamera()
  {
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((value)
    {
      if(!mounted)
      {
        return;
      }

      setState(() {
        cameraController.startImageStream((imageFromStream) =>
        {
          if(!isWorking)
            {
              isWorking = true,
              imgCamera = imageFromStream,
              runModelOnStreamFrame(),
            }
        });
      });
    });
  }

  runModelOnStreamFrame() async
  {
    imgHeight = imgCamera.height + 0.0;
    imgWidth = imgCamera.width + 0.0;

    recognitionsList = await Tflite.runPoseNetOnFrame(

      bytesList: imgCamera.planes.map((plane) {
        return plane.bytes;
      }).toList(),

      imageHeight: imgCamera.height,
      imageWidth: imgCamera.width,

      numResults: 2,
    );

    isWorking = false;
    setState(() {
      imgCamera;
    });
  }

  // loadModel() async
  // {
  //   Tflite.close();
  //
  //   try
  //   {
  //     String response;
  //     response = await Tflite.loadModel(
  //       // model: "assets/posenet_mv1_075_float_from_checkpoints.tflite",
  //     );
  //     print(response);
  //   }
  //   on PlatformException
  //   {
  //     print("Unable to load Model");
  //   }
  // }

  List<Widget> displayKeypoints(Size screen)
  {
    if(recognitionsList == null) return [];

    if(imgHeight == null  ||  imgWidth == null) return [];

    double factorX = screen.width;
    double factorY = imgHeight;

    var listsAll = <Widget>[];

    recognitionsList.forEach((result)
    {
      var list = result["keypoints"].values.map<Widget>((val)
      {
        return Positioned(
          left: val["x"] * factorX - 6,
          top: val["y"] * factorY - 6,
          width: 100,
          height: 20,
          child: Text(
            "◉ ${val['part']}",
            style: TextStyle(color: Colors.pink, fontSize: 14.0),
          ),
        );
      }).toList();
      listsAll..addAll(list);
    });
    return listsAll;
  }

  // @override
  // void initState() {
  //   super.initState();
  //
  //   initCamera();
  //   loadModel();
  // }

  @override
  void dispose() {
    super.dispose();

    cameraController.stopImageStream();
    Tflite.close();
  }

  @override
  Widget build(BuildContext context)
  {
    Size size = MediaQuery.of(context).size;
    List<Widget> stackChildrenWidgets = [];

    stackChildrenWidgets.add(
      Positioned(
        top: 0.0,
        left: 0.0,
        width: size.width, height: size.height-100,
        child: Container(
          height: size.height-100,
          child: (!cameraController.value.isInitialized)
              ? new Container()
              : AspectRatio(
            aspectRatio: cameraController.value.aspectRatio,
            child: CameraPreview(cameraController),
          ),
        ),
      ),
    );

    if(imgCamera != null)
    {
      stackChildrenWidgets.addAll(displayKeypoints(size));
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          margin: EdgeInsets.only(top: 50),
          color: Colors.black,
          child: Stack(
            children: stackChildrenWidgets,
          ),
        ),
      ),
    );
  }
}
