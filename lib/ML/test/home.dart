import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:e_shop/main.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

import '../../main.dart';
import 'camera.dart';
import 'bndbox.dart';
import 'models.dart';

class HomePageML extends StatefulWidget {
  ItemModel itemModel;
  HomePageML(this.itemModel);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePageML> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";

  @override
  void initState() {
    super.initState();
  }

  // loadModel() async {
  //   String res;
  //   switch (_model) {
  //
  //   //   case posenet:
  //   //     res = await Tflite.loadModel(
  //   //         // model: "assets/posenet_model.tflite");
  //   //     break;
  //   // }
  //   print(res);
  // }

  onSelect(model) {
    setState(() {
      _model = model;
    });
    // loadModel();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed:() {
            Route route = MaterialPageRoute(builder: (c) => ProductPage(itemModel: widget.itemModel,bought: true,));
            Navigator.pushReplacement(context, route);
          },
        ),
        title: Text("Training View"),
        centerTitle: true,
      ),
      body: _model == ""
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: const Text(posenet),
                    onPressed: () => onSelect(posenet),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                Camera(
                  cameras,
                  _model,
                  setRecognitions,
                ),
                BndBox(
                    _recognitions == null ? [] : _recognitions,
                    math.max(_imageHeight, _imageWidth),
                    math.min(_imageHeight, _imageWidth),
                    screen.height,
                    screen.width,
                    _model),
              ],
            ),
    );
  }
}
