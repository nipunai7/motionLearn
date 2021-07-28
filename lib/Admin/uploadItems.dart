import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/myDrawer2.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  double _total;

  bool get wantKeepAlive => true;
  File file, file2;
  final picker = ImagePicker();
  TextEditingController descriptionText = TextEditingController();
  TextEditingController priceText = TextEditingController();
  TextEditingController titleText = TextEditingController();
  TextEditingController shortText = TextEditingController();
  String tuteID = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    getAll();
    return file == null ? displayAdminHome() : adminUploadForm();
  }

  displayAdminHome() {
    return WillPopScope(
        onWillPop: () {
          AlertDialog(
            title: Text('Alert Dialog Title Text.'),
            content: Text("Are You Sure Want To Proceed ?"),
            actions: <Widget>[
              TextButton(
                child: Text("YES"),
                onPressed: () {
                  Route route =
                      MaterialPageRoute(builder: (c) => SplashScreen());
                  Navigator.pushReplacement(context, route);
                },
              ),
              TextButton(
                child: Text("NO"),
                onPressed: () {
                  //Put your code here which you want to execute on No button click.
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
        child: Scaffold(
          drawer: MyDrawer2(),
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: new BoxDecoration(color: Colors.deepPurple),
            ),
          ),
          body: dashboard(),
        ));
  }

  dashboard() {
    List<_SalesData> data = [
      _SalesData('Jan', 8500),
      _SalesData('Feb', 6800),
      _SalesData('Mar', 7400),
      _SalesData('Apr', 6500),
      _SalesData('May', 8600)
    ];
    return Container(
        child: _total != null
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      elevation: 14.0,
                      child: Center(
                        heightFactor: 1.0,
                        child: Container(
                            height: 60.0,
                            child: Center(
                              child: Text(
                                "Total Earnings: $_total",
                                style: TextStyle(
                                    fontSize: 24.0, color: Colors.deepPurple),
                              ),
                            )),
                      ),
                    ),
                    Card(
                      elevation: 12.0,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 6.0,
                          ),
                          Center(
                            child: Text(
                              "Trending Tutorials",
                              style: TextStyle(
                                  fontSize: 24.0, color: Colors.deepPurple),
                            ),
                            widthFactor: 1.96,
                            heightFactor: 1.2,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 4.0, top: 4.0, right: 4.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.deepPurple),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                topRight: Radius.circular(
                                    5.0), //                 <--- border radius here
                              ),
                            ),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Colors.deepPurple,
                                        border: Border.all(
                                            color: Colors.deepPurple),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(
                                                5.0) //                 <--- border radius here
                                            ),
                                      ),
                                      width: 220.0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Title",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.white),
                                        ),
                                      )),
                                  Container(
                                      decoration: BoxDecoration(
                                          color: Colors.deepPurple,
                                          border: Border.all(
                                              color: Colors.deepPurple)),
                                      width: 80,
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Qty",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.white),
                                        ),
                                      ))),
                                  Container(
                                      width: 74.7,
                                      decoration: BoxDecoration(
                                        color: Colors.deepPurple,
                                        border: Border.all(
                                            color: Colors.deepPurple),
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(
                                                5.0) //                 <--- border radius here
                                            ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, bottom: 8.0),
                                        child: Center(
                                          child: Text(
                                            "Income",
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ))
                                ]),
                          ),
                          trending()
                        ],
                      ),
                    ),
                    Card(
                      elevation: 12.0,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 6.0,
                          ),
                          Center(
                            child: Text(
                              "Top clients",
                              style: TextStyle(
                                  fontSize: 24.0, color: Colors.deepPurple),
                            ),
                            widthFactor: 1.96,
                            heightFactor: 1.2,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 4.0, top: 4.0, right: 4.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.deepPurple),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                topRight: Radius.circular(
                                    5.0), //                 <--- border radius here
                              ),
                            ),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Colors.deepPurple,
                                        border: Border.all(
                                            color: Colors.deepPurple),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(
                                                5.0) //                 <--- border radius here
                                            ),
                                      ),
                                      width: 220.0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Title",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.white),
                                        ),
                                      )),
                                  Container(
                                      decoration: BoxDecoration(
                                          color: Colors.deepPurple,
                                          border: Border.all(
                                              color: Colors.deepPurple)),
                                      width: 80,
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.white),
                                        ),
                                      ))),
                                  Container(
                                      width: 74.7,
                                      decoration: BoxDecoration(
                                        color: Colors.deepPurple,
                                        border: Border.all(
                                            color: Colors.deepPurple),
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(
                                                5.0) //                 <--- border radius here
                                            ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, bottom: 8.0),
                                        child: Center(
                                          child: Text(
                                            "Income",
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ))
                                ]),
                          ),
                          trending2()
                        ],
                      ),
                    ),
                    Card(
                        margin: EdgeInsets.all(10.0),
                        elevation: 16.0,
                        child: Center(
                            heightFactor: 1.1,
                            child: SfCartesianChart(
                                primaryXAxis: CategoryAxis(),
                                // Chart title
                                title: ChartTitle(text: 'Monthly Sales'),
                                // Enable legend
                                legend: Legend(isVisible: true),
                                // Enable tooltip
                                tooltipBehavior: TooltipBehavior(enable: true),
                                series: <ChartSeries<_SalesData, String>>[
                                  LineSeries<_SalesData, String>(
                                      dataSource: data,
                                      xValueMapper: (_SalesData sales, _) =>
                                          sales.year,
                                      yValueMapper: (_SalesData sales, _) =>
                                          sales.sales,
                                      name: '',
                                      // Enable data label
                                      dataLabelSettings:
                                          DataLabelSettings(isVisible: true)),
                                ])))
                  ],
                ),
              )
            : Container(
                child: ElevatedButton(
                  child: Text("Press to Load data"),
                  onPressed: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => UploadPage());
                    Navigator.pushReplacement(context, route);
                  },
                ),
              ));
  }

  trending() {
    return Container(
        margin: EdgeInsets.only(left: 4.0, bottom: 4.0, right: 4.0),
        height: 190.0,
        child: StreamBuilder(
          stream: Firestore.instance
              .collection("Items")
              .orderBy("purchaseCount", descending: true)
              .snapshots(),
          builder: (context, snapshot12) {
            if (!snapshot12.hasData) {
              print("No data");
              return CircularProgressIndicator();
            }
            return ListView(
              children: snapshot12.data.documents.map<Widget>((document) {
                return InkWell(
                  child: Container(
                      height: 47.0,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.deepPurple),
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Padding(
                        padding: EdgeInsets.only(left: 4.0, right: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: 200.0,
                                child: Text(
                                  document['title'],
                                  style: TextStyle(fontSize: 18.0),
                                )),
                            Text(
                              document['purchaseCount'].toString(),
                              style: TextStyle(fontSize: 18.0),
                            ),
                            Text(
                              (document['purchaseCount'] * document['price'])
                                  .toString(),
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ],
                        ),
                      )),
                );
              }).toList(),
            );
          },
        ));
  }

  trending2() {
    return Container(
        margin: EdgeInsets.only(left: 4.0, bottom: 4.0, right: 4.0),
        height: 190.0,
        child: StreamBuilder(
          stream: Firestore.instance
              .collection("users")
              .orderBy("totalSpent", descending: true)
              .snapshots(),
          builder: (context, snapshot12) {
            if (!snapshot12.hasData) {
              print("No data");
              return CircularProgressIndicator();
            }
            return ListView(
              children: snapshot12.data.documents.map<Widget>((document) {
                return InkWell(
                  child: Container(
                      height: 47.0,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.deepPurple),
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Padding(
                        padding: EdgeInsets.only(left: 4.0, right: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: 200.0,
                                child: Text(
                                  document['name'],
                                  style: TextStyle(fontSize: 18.0),
                                )),
                            // Text(
                            //   "4",
                            //   style: TextStyle(fontSize: 18.0),
                            // ),
                            Text(
                              (document['totalSpent']).toString(),
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ],
                        ),
                      )),
                );
              }).toList(),
            );
          },
        ));
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

  getAll() async {
    double total = 0;
    // List tuteTitle = [];
    // List qty = [];
    // List price = [];
    await Firestore.instance
        .collection("users")
        .orderBy("totalSpent")
        .getDocuments()
        .then((value) => {
              value.documents.forEach((element) {
                total += double.parse(element.data['totalSpent']);
              }),
            });

    // await Firestore.instance
    //     .collection("Items")
    //     .orderBy("purchaseCount", descending: true)
    //     .getDocuments()
    //     .then((value) => {
    //           value.documents.forEach((element) {
    //             tuteTitle.add(element.data['title']);
    //             qty.add(element.data['purchaseCount']);
    //             price.add(element.data['price']);
    //           })
    //         });
    setState(() {
      _total = total;
      // _tuteTitle = tuteTitle;
      // _qty = qty;
      // _price = price;
      dashboard();
    });
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
