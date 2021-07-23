import 'dart:convert';
import 'dart:io';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class VideoPlay extends StatefulWidget {
  final String url;
  final ItemModel itemModel;

  const VideoPlay({Key key, this.url, this.itemModel}) : super(key: key);

  @override
  _VideoPlayState createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  String attempt="1";
  String uName=EcommerceApp.sharedPreferences.getString(EcommerceApp.userName);
  String uid=EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID);
  String tuteName;
  String refTuteRep;
  String tuteID;

  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Upload Your Training Video",
          ),
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
              }),
        ),
        body: Container(
          child: Column(children: [
            Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(),
            ),
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (c) => ProductPage(
                                      itemModel: widget.itemModel,
                                      bought: true,
                                    )));
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0)),
                        primary: Colors.deepPurple,
                      ),
                      child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 44.0,
                          child: Center(
                              child: Text(
                            "Cancel",
                            style: TextStyle(fontSize: 18.0),
                          ))),
                    ),
                    ElevatedButton(
                      onPressed: () {uploadDataToFirebase();},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0)),
                        primary: Colors.deepPurple,
                      ),
                      child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 44.0,
                          child: Center(
                              child: Text(
                            "Submit",
                            style: TextStyle(fontSize: 18.0),
                          ))),
                    ),
                  ]),
            )
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  uploadDataToFirebase() async {
    tuteName = widget.itemModel.title;
    refTuteRep = widget.itemModel.reportURL;
    tuteID = widget.itemModel.id;

    String imgdownUrl1 = await uploadVideo(File(widget.url));

    saveItemInfo(imgdownUrl1);
  }

  Future<String> uploadVideo(image2) async {
    final StorageReference storageReference =
    FirebaseStorage.instance.ref().child("Reports/"+uid+"/"+tuteID+" "+attempt+"/");
    StorageUploadTask uploadTask2 =
    storageReference.child("training_$tuteID.mp4").putFile(image2);
    StorageTaskSnapshot taskSnapshot2 = await uploadTask2.onComplete;
    String downloadUrl2 = await taskSnapshot2.ref.getDownloadURL();
    return downloadUrl2;
  }

  saveItemInfo(String downUrl1) async {
    final response = await createReport(downUrl1,tuteID,refTuteRep,tuteName,attempt,uid,uName);

    if (response.statusCode == 200){
      print("All Done");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (c) => ProductPage(
                itemModel: widget.itemModel,
                bought: true,
              )));
      Fluttertoast.showToast(
      msg: 'Report added to your profile\nPlease visit your profile section',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.deepPurple,
      textColor: Colors.white
  );
    }else{
      print(response.body);
    }
  }

  Future<http.Response> createReport(String video,String tuteID,String refTuteRep,String tuteName, String attempt, String uid, String uName) {
    return http.post(
      Uri.parse('http://34.126.164.58/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'video': video,
        'tuteID': tuteID,
        'refTuteRep':refTuteRep,
        'tuteName':tuteName,
        'attempt':attempt,
        'uid':uid,
        'uName':uName
      }),
    );
  }
}
