import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/myDrawer2.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class UploadPage extends StatefulWidget
{
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
{
  bool get wantKeepAlive => true;
  File file,file2;
  final picker = ImagePicker();
  TextEditingController descriptionText = TextEditingController();
  TextEditingController priceText = TextEditingController();
  TextEditingController titleText = TextEditingController();
  TextEditingController shortText = TextEditingController();
  String tuteID = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;




  @override
  Widget build(BuildContext context) {
    return file == null ? displayAdminHome() : adminUploadForm();
  }

  displayAdminHome(){
    return WillPopScope(
        onWillPop: (){
          AlertDialog(
            title: Text('Alert Dialog Title Text.'),
            content: Text("Are You Sure Want To Proceed ?"),
            actions: <Widget>[
              TextButton(
                child: Text("YES"),
                onPressed: () {
                  Route route = MaterialPageRoute(builder: (c) => SplashScreen());
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
          decoration: new BoxDecoration(
            color: Colors.deepPurple
          ),
        ),
        // leading: IconButton(
        //   icon: Icon(Icons.border_color,color: Colors.white,),
        //   onPressed: (){
        //     Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
        //     Navigator.pushReplacement(context, route);
        //   },
        // ),
        actions: [
          TextButton(
              child: Text("Logout",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => SplashScreen());
                Navigator.pushReplacement(context, route);
              },
          ),
        ],
      ),
      body: getAdminHomeBody(),
      )
    );
  }
  getAdminHomeBody(){
    return Container(
      decoration: new BoxDecoration(
        color: Colors.deepPurple
      ),
      child:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shop_two,color: Colors.white,size: 200.0,),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0),
                  ),
                ),
                child: Text("Add New Tutorial",style: TextStyle(fontSize: 20.0,color: Colors.deepPurple),),
                onPressed: () => takeImage(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
  takeImage(mContext){
    return showDialog(
        context: mContext,
        builder: (con){
          return SimpleDialog(
            title: Text("Select Tutorial Image",style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold,),),
            children: [
              SimpleDialogOption(
                // child: ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     primary: Colors.deepPurple
                //   ),
                  child: Text("Select from Gallery",style: TextStyle(color: Colors.deepPurple),),
                  onPressed: galleryCapture,
               // )
              ),
              SimpleDialogOption(
                // child: ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //       primary: Colors.deepPurple
                //   ),
                  child: Text("Capture with Camera",style: TextStyle(color: Colors.deepPurple),),
                  onPressed: cameraCapture,
                //),
              ),
              SimpleDialogOption(
                child: Text("Cancel",style: TextStyle(color: Colors.deepPurple),),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }

  cameraCapture() async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(source: ImageSource.camera,maxWidth: 970.0,maxHeight: 680.0,preferredCameraDevice: CameraDevice.rear,);

    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  galleryCapture() async{
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
    final pickedFile = await picker.getVideo(source: ImageSource.camera,preferredCameraDevice: CameraDevice.rear,);

    setState(() {
      if (pickedFile != null) {
        file2 = File(pickedFile.path);
      } else {
        print('No Video selected.');
      }
    });
  }

  galleryCapture2() async{
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


  adminUploadForm(){
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          color: Colors.deepPurple,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: clearForm,
        ),
        title: Text("Add New Tutorial",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 24.0),),
        actions: [
          TextButton(
              onPressed: uploading ? null : () => uploadDataToFirebase(),
              child: Text("Add",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16.0),))
        ],
      ),
      body: ListView(
        children: [
          uploading ? circularProgress() : Text(""),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child:AspectRatio(aspectRatio: 16/9,
            child: Container(
              decoration: new BoxDecoration(
                image: DecorationImage(image: FileImage(file), fit: BoxFit.cover),
              ),
            ),),
          ),
          Padding(padding: EdgeInsets.only(top: 12.0)),
          ListTile(
            leading: Icon(Icons.info_outline,color: Colors.deepPurple,),
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
          Divider(color: Colors.deepPurpleAccent,),
          ListTile(
            leading: Icon(Icons.title,color: Colors.deepPurple,),
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
          Divider(color: Colors.deepPurpleAccent,),
          ListTile(
            leading: Icon(Icons.monetization_on_outlined,color: Colors.deepPurple,),
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
          Divider(color: Colors.deepPurpleAccent,),
          ListTile(
            leading: Icon(Icons.videocam,color: Colors.deepPurple,),
            title: Container(
              alignment: Alignment.centerLeft,
              child: TextButton(
                child: Text("Select the tutorial",style: TextStyle(color: Colors.deepPurpleAccent),textAlign: TextAlign.left,),
                onPressed: () {
                            showDialog(
                            context: context,
                            builder: (con){
                            return SimpleDialog(
                            title: Text("Select Tutorial Image",style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold,),),
                            children: [
                            SimpleDialogOption(
                            // child: ElevatedButton(
                            //   style: ElevatedButton.styleFrom(
                            //     primary: Colors.deepPurple
                            //   ),
                            child: Text("Select from Gallery",style: TextStyle(color: Colors.deepPurple),),
                            onPressed: galleryCapture2,
                            // )
                            ),
                            SimpleDialogOption(
                            // child: ElevatedButton(
                            //   style: ElevatedButton.styleFrom(
                            //       primary: Colors.deepPurple
                            //   ),
                            child: Text("Capture with Camera",style: TextStyle(color: Colors.deepPurple),),
                            onPressed: cameraCapture2,
                            //),
                            ),
                            SimpleDialogOption(
                            child: Text("Cancel",style: TextStyle(color: Colors.deepPurple),),
                            onPressed: (){
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
          Divider(color: Colors.deepPurpleAccent,),
          ListTile(
            leading: Icon(Icons.text_snippet_rounded,color: Colors.deepPurple,),
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
          Divider(color: Colors.deepPurpleAccent,),
        ],
      ),
    );
  }

  clearForm(){
    setState(() {
      file = null;
      descriptionText.clear();
      shortText.clear();
      priceText.clear();
      titleText.clear();
    });
  }

  uploadDataToFirebase() async{
    setState(() {
      uploading = true;
    });

   String imgdownUrl1 = await uploadImage1(file);
   String imgdownUrl2 = await uploadImage2(file2);
   
   saveItemInfo(imgdownUrl1,imgdownUrl2);
  }

  Future<String> uploadImage1(image1) async{
    final StorageReference storageReference = FirebaseStorage.instance.ref().child("Items");
    StorageUploadTask uploadTask1 = storageReference.child("frontpic_$tuteID.jpg").putFile(image1);
    StorageTaskSnapshot taskSnapshot1 = await uploadTask1.onComplete;
    String downloadUrl1 = await taskSnapshot1.ref.getDownloadURL();

    return downloadUrl1;
  }

  Future<String> uploadImage2(image2) async{
    final StorageReference storageReference = FirebaseStorage.instance.ref().child("Items");
    StorageUploadTask uploadTask2 = storageReference.child("tutorial_$tuteID.mp4").putFile(image2);
    StorageTaskSnapshot taskSnapshot2 = await uploadTask2.onComplete;
    String downloadUrl2 = await taskSnapshot2.ref.getDownloadURL();
    return downloadUrl2;
  }

  saveItemInfo(String downUrl1,String downUrl2){
    final itemsRef = Firestore.instance.collection("Items");
    itemsRef.document(tuteID).setData({
      "id": tuteID,
      "reviews": "garbageValue",
      "shortInfo": shortText.text.trim(),
      "price": int.parse(priceText.text),
      "title": titleText.text.trim(),
      "longDescription": descriptionText.text.trim(),
      "thumbnailUrl": downUrl1,
      "tutorial": downUrl2,
      "status":"available",
      "publishedDate":DateTime.now(),
    });

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
}
