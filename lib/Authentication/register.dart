import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nametextcontroller = TextEditingController();
  final TextEditingController _passtextcontroller = TextEditingController();
  final TextEditingController _emailextcontroller = TextEditingController();
  final TextEditingController _cpasstextcontroller = TextEditingController();
  final TextEditingController _userpackagetextcontroller = TextEditingController();
  final TextEditingController _userJob = TextEditingController();
  final TextEditingController _userAge = TextEditingController();
  final TextEditingController _preference = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String userImgUrl = "";
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    double _screenwidth = MediaQuery.of(context).size.width,
        _screenheight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 20.0,
            ),
            InkWell(
              onTap: _selectImage,
              child: CircleAvatar(
                radius: _screenwidth * 0.15,
                backgroundColor: Colors.white,
                backgroundImage:
                    _imageFile == null ? null : FileImage(_imageFile),
                child: _imageFile == null
                    ? Icon(
                        Icons.add_photo_alternate,
                        size: _screenwidth * 0.15,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nametextcontroller,
                    data: Icons.person_add,
                    hintText: "Name",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _emailextcontroller,
                    data: Icons.email,
                    hintText: "E-Mail",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passtextcontroller,
                    data: Icons.lock,
                    hintText: "Password",
                    isObsecure: true,
                  ),
                  CustomTextField(
                    controller: _cpasstextcontroller,
                    data: Icons.lock,
                    hintText: "Password",
                    isObsecure: true,
                  ),
                  CustomTextField(
                    controller: _userAge,
                    data: Icons.cake_rounded,
                    hintText: "Your age",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _userJob,
                    data: Icons.work_rounded,
                    hintText: "Your occupation",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _preference,
                    data: Icons.live_tv_rounded,
                    hintText: "Your preferred categories",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _userpackagetextcontroller,
                    data: Icons.monetization_on_sharp,
                    hintText: "Package No:",
                    isObsecure: false,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            ElevatedButton(
              onPressed: () {
                uploadAndSaveImage();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              child: Text(
                "Register",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: 22.0,
            ),
            Container(
              height: 4.0,
              width: _screenwidth * 0.8,
              color: Colors.white,
            ),
            SizedBox(
              height: 10.0,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _selectImage() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<void> uploadAndSaveImage() async {
    if (_imageFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: "Please Select an Image",
            );
          });
    } else {
      _passtextcontroller.text == _cpasstextcontroller.text
          ? _emailextcontroller.text.isNotEmpty &&
                  _passtextcontroller.text.isNotEmpty &&
                  _cpasstextcontroller.text.isNotEmpty &&
                  _nametextcontroller.text.isNotEmpty &&
                  _userpackagetextcontroller.text.isNotEmpty
              ? uploadtoStorage()
              : displayDialog("Please fill the required info")
          : displayDialog("Passwords do not match");
    }
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }

  uploadtoStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "Registering, Please wait.....",
          );
        });

    String imageName = DateTime.now().microsecondsSinceEpoch.toString();

    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(imageName);

    StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);

    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;

    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      userImgUrl = urlImage;

      _regUser();
    });
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  void _regUser() async {
    FirebaseUser firebaseUser;

    await _auth
        .createUserWithEmailAndPassword(
      email: _emailextcontroller.text.trim(),
      password: _passtextcontroller.text.trim(),
    )
        .then((auth) {
      firebaseUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });

    if (firebaseUser != null) {
      saveUsertoFirebase(firebaseUser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future saveUsertoFirebase(FirebaseUser fUser) async {
    Firestore.instance.collection("users").document(fUser.uid).setData({
      "uid": fUser.uid,
      "jdate": DateTime.now().toString(),
      "email": fUser.email,
      "name": _nametextcontroller.text.trim(),
      "url": userImgUrl,
      "userpkg": _userpackagetextcontroller.text.trim(),
      EcommerceApp.userCartList: ["garbageValue"],
      EcommerceApp.items: ["garbageValue"],
      "totalSpent":"0",
      "job":_userJob.text.trim(),
      "age":_userAge.text.trim(),
      "preference": _preference.text.trim(),
      "hiphop":0,
      "breakdance":0,
      "salsa":0,
      "other":0

    });

    await EcommerceApp.sharedPreferences.setString("uid", fUser.uid);
    await EcommerceApp.sharedPreferences.setString("email", fUser.email);
    await EcommerceApp.sharedPreferences
        .setString("name", _nametextcontroller.text.trim());
    await EcommerceApp.sharedPreferences.setString("url", userImgUrl);
    await EcommerceApp.sharedPreferences
        .setString("userpkg", _userpackagetextcontroller.text.trim());
    await EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ["garbageValue"]);
    await EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.items, ["garbageValue"]);
    await EcommerceApp.sharedPreferences
        .setString("jdate", DateTime.now().toString());
    await EcommerceApp.sharedPreferences.setString("totalSpent", '0');
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.pref, _preference.text.trim());
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.job, _userJob.text.trim());
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.age, _userAge.text.trim());
  }
}
