import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/product_admin.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AdminUploads extends StatefulWidget {
  @override
  _AdminUploads createState() => _AdminUploads();
}

class _AdminUploads extends State<AdminUploads> {
  bool get wantKeepAlive => true;
  File file, file2;
  final picker = ImagePicker();
  TextEditingController descriptionText = TextEditingController();
  TextEditingController priceText = TextEditingController();
  TextEditingController titleText = TextEditingController();
  TextEditingController shortText = TextEditingController();
  TextEditingController category = TextEditingController();

  String tuteID = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  Widget build(BuildContext context) {
    return file == null ? displayitems() : adminUploadForm();
  }

  displayitems() {
    return WillPopScope(
      onWillPop: () {
        Route route = MaterialPageRoute(builder: (c) => UploadPage());
        Navigator.pushReplacement(context, route);
      },
      child: Scaffold(
          appBar: AppBar(
            actions: [
              Container(
                margin: EdgeInsets.all(10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0),
                    ),
                  ),
                  child: Text(
                    "Add New Tutorial",
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => takeImage(context),
                ),
              ),
            ],
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.deepPurple,
            centerTitle: true,
            title: Text(
              "Manage Tutorials",
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            leading: IconButton(
                onPressed: () {
                  Route route = MaterialPageRoute(builder: (c) => UploadPage());
                  Navigator.pushReplacement(context, route);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
          ),
          body: viewRev()),
    );
  }

  viewRev() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: StreamBuilder(
        stream: Firestore.instance.collection("Items").snapshots(),
        builder: (context, snapshot12) {
          if (!snapshot12.hasData) {
            print("No data");
            return CircularProgressIndicator();
          }
          int count = 0;
          return ListView(
            children: snapshot12.data.documents.map<Widget>((document) {
              print("Name: " + document['title']);
              ItemModel itemModel =
                  ItemModel.fromJson(snapshot12.data.documents[count].data);
              ++count;
              return InkWell(
                onTap: () {
                  Route route = MaterialPageRoute(
                      builder: (c) => ProductAdmin(
                            itemModel: itemModel,
                          ));
                  Navigator.pushReplacement(context, route);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 6.0),
                  height: 190.0,
                  child: Card(
                    elevation: 10.0,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Center(
                            child: Container(
                                width: (MediaQuery.of(context).size.width / 3) -
                                    10,
                                child: Image.network(document['thumbnailUrl'])),
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(left: 10.0),
                              width:
                                  (MediaQuery.of(context).size.width * 2 / 3) -
                                      32,
                              child: Column(
                                children: [
                                  Align(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        document['title'],
                                        style: TextStyle(fontSize: 20.0),
                                      )),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Container(
                                    height: 68.0,
                                    child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(document['longDescription'],
                                            style: TextStyle(fontSize: 16.0))),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        child: Center(
                                            child: Text(
                                          "50%\nOFF",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                        height: 40.0,
                                        width: 40.0,
                                        decoration: BoxDecoration(
                                            color: Colors.deepPurple),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 80.0),
                                          child: Text("Price: Rs." +
                                              document['price'].toString() +
                                              ".00"),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: Text(
              "Select Tutorial Image",
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              SimpleDialogOption(
                // child: ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     primary: Colors.deepPurple
                //   ),
                child: Text(
                  "Select from Gallery",
                  style: TextStyle(color: Colors.deepPurple),
                ),
                onPressed: galleryCapture,
                // )
              ),
              SimpleDialogOption(
                // child: ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //       primary: Colors.deepPurple
                //   ),
                child: Text(
                  "Capture with Camera",
                  style: TextStyle(color: Colors.deepPurple),
                ),
                onPressed: cameraCapture,
                //),
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.deepPurple),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  cameraCapture() async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      maxWidth: 970.0,
      maxHeight: 680.0,
      preferredCameraDevice: CameraDevice.rear,
    );

    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  galleryCapture() async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  cameraCapture2() async {
    Navigator.pop(context);
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

  galleryCapture2() async {
    Navigator.pop(context);
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        file2 = File(pickedFile.path);
      } else {
        print('No Video selected.');
      }
    });
  }

  String selCategory;

  adminUploadForm() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          color: Colors.deepPurple,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: clearForm,
        ),
        title: Text(
          "Add New Tutorial",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0),
        ),
        actions: [
          TextButton(
              onPressed: uploading ? null : () => uploadDataToFirebase(),
              child: Text(
                "Add",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ))
        ],
      ),
      body: ListView(
        children: [
          uploading ? circularProgress() : Text(""),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: new BoxDecoration(
                  image: DecorationImage(
                      image: FileImage(file), fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 12.0)),
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: Colors.deepPurple,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurple),
                controller: shortText,
                decoration: InputDecoration(
                  hintText: "Short Info",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.deepPurpleAccent,
          ),
          ListTile(
            leading: Icon(
              Icons.title,
              color: Colors.deepPurple,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurple),
                controller: titleText,
                decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.deepPurpleAccent,
          ),
          ListTile(
            leading: Icon(
              Icons.monetization_on_outlined,
              color: Colors.deepPurple,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.deepPurple),
                controller: priceText,
                decoration: InputDecoration(
                  hintText: "Price",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.deepPurpleAccent,
          ),
          ListTile(
            leading: Icon(
              Icons.videocam,
              color: Colors.deepPurple,
            ),
            title: Container(
              alignment: Alignment.centerLeft,
              child: TextButton(
                child: Text(
                  "Select the tutorial",
                  style: TextStyle(color: Colors.deepPurpleAccent),
                  textAlign: TextAlign.left,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (con) {
                        return SimpleDialog(
                          title: Text(
                            "Select Tutorial Image",
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          children: [
                            SimpleDialogOption(
                              // child: ElevatedButton(
                              //   style: ElevatedButton.styleFrom(
                              //     primary: Colors.deepPurple
                              //   ),
                              child: Text(
                                "Select from Gallery",
                                style: TextStyle(color: Colors.deepPurple),
                              ),
                              onPressed: galleryCapture2,
                              // )
                            ),
                            SimpleDialogOption(
                              // child: ElevatedButton(
                              //   style: ElevatedButton.styleFrom(
                              //       primary: Colors.deepPurple
                              //   ),
                              child: Text(
                                "Capture with Camera",
                                style: TextStyle(color: Colors.deepPurple),
                              ),
                              onPressed: cameraCapture2,
                              //),
                            ),
                            SimpleDialogOption(
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.deepPurple),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        );
                      });
                },
              ),
            ),
          ),
          Divider(
            color: Colors.deepPurpleAccent,
          ),
          ListTile(
            leading: Icon(
              Icons.text_snippet_rounded,
              color: Colors.deepPurple,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurple),
                controller: descriptionText,
                decoration: InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.deepPurpleAccent,
          ),
          Container(
            child: ExpansionTile(
              maintainState: true,
              title: Text("Select a Category"),
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      selCategory = 'Break Dance';
                    });
                    print(selCategory);
                    Fluttertoast.showToast(msg: selCategory + " selected");
                  },
                  child: ListTile(
                    title: Text("Break Dance"),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      selCategory = 'Hip Hop';
                    });
                    print(selCategory);
                    Fluttertoast.showToast(msg: selCategory + " selected");
                  },
                  child: ListTile(
                    title: Text("Hip Hop"),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      selCategory = 'Salsa';
                    });
                    print(selCategory);
                    Fluttertoast.showToast(msg: selCategory + " selected");
                  },
                  child: ListTile(
                    title: Text("Salsa"),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      selCategory = 'Other';
                    });
                    print(selCategory);
                    Fluttertoast.showToast(msg: selCategory + " selected");
                  },
                  child: ListTile(
                    title: Text("Other"),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  clearForm() {
    setState(() {
      file = null;
      descriptionText.clear();
      shortText.clear();
      priceText.clear();
      titleText.clear();
    });
  }

  uploadDataToFirebase() async {
    setState(() {
      uploading = true;
    });

    String imgdownUrl1 = await uploadImage1(file);
    String imgdownUrl2 = await uploadImage2(file2);

    saveItemInfo(imgdownUrl1, imgdownUrl2);
  }

  Future<String> uploadImage1(image1) async {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child("Items");
    StorageUploadTask uploadTask1 =
        storageReference.child("frontpic_$tuteID.jpg").putFile(image1);
    StorageTaskSnapshot taskSnapshot1 = await uploadTask1.onComplete;
    String downloadUrl1 = await taskSnapshot1.ref.getDownloadURL();

    return downloadUrl1;
  }

  Future<String> uploadImage2(image2) async {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child("Items");
    StorageUploadTask uploadTask2 =
        storageReference.child("tutorial_$tuteID.mp4").putFile(image2);
    StorageTaskSnapshot taskSnapshot2 = await uploadTask2.onComplete;
    String downloadUrl2 = await taskSnapshot2.ref.getDownloadURL();
    return downloadUrl2;
  }

  saveItemInfo(String downUrl1, String downUrl2) async {
    final itemsRef = Firestore.instance.collection("Items");
    itemsRef.document(tuteID).setData({
      "id": tuteID,
      "purchaseCount": 0,
      "reviews": [],
      "shortInfo": shortText.text.trim(),
      "price": int.parse(priceText.text),
      "title": titleText.text.trim(),
      "longDescription": descriptionText.text.trim(),
      "thumbnailUrl": downUrl1,
      "tutorial": downUrl2,
      "status": "available",
      "publishedDate": DateTime.now(),
      "category": selCategory,
    });

    print("video: " + downUrl2);
    print("tuteID: " + tuteID);

    final response = await createReport(downUrl2, tuteID);

    if (response.statusCode == 200) {
      print("All Done");
    } else {
      print(response.body);
    }

    setState(() {
      file = null;
      uploading = false;
      tuteID = DateTime.now().millisecondsSinceEpoch.toString();
      titleText.clear();
      priceText.clear();
      shortText.clear();
      descriptionText.clear();
    });
  }

  Future<http.Response> createReport(String video, String tuteID) {
    return http.post(
      Uri.parse('http://34.126.164.58/admin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'video': video, 'tuteID': tuteID}),
    );
  }
}
