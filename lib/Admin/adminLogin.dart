import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';




class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            color: Colors.deepPurple
          ),
        ),
        title: Text("Motion Learn",style: TextStyle(fontFamily: "Signatra",fontSize: 40,color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: AdminSignInScreen(),
    );
  }
}


class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen>
{


  final TextEditingController _passtextcontroller = TextEditingController();
  final TextEditingController _adminIDtextcontroller = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    double _screenwidth = MediaQuery.of(context).size.width, _screenheight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(

        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height:20.0 ,),
            Container(
              child: Image.asset("images/admin.png",height: 240.0,width: 240.0,),
            ),
            Padding(padding: EdgeInsets.all(8.0),
              child: Text("Login to Admin Account",style: TextStyle(color: Colors.white),
              ),
            ),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _adminIDtextcontroller,
                    data: Icons.psychology_rounded,
                    hintText: "Admin ID",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passtextcontroller,
                    data: Icons.lock,
                    hintText: "Password",
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0,),
            ElevatedButton(
              onPressed: () { _adminIDtextcontroller.text.isNotEmpty && _passtextcontroller.text.isNotEmpty
                  ? loginAdmin()
                  :showDialog(
                  context: context,
                  builder: (c){
                    return ErrorAlertDialog(message: "Please fill Email & Password",);
                  }
              );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              child: Text("Login",style: TextStyle(color: Colors.deepPurple,fontSize:20,),),
            ),
            SizedBox(height: 70.0,),
            Container(
              height: 4.0,
              width: _screenwidth* 0.8,
              color: Colors.white,
            ),
            SizedBox(height: 10.0,),
            Container(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AuthenticScreen())),
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      ),
                      child: Text("Not ad Admin",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
                  ],
                )
            )
          ],
        ),
      ),
    );
  }

  loginAdmin(){
    Firestore.instance.collection("admins").getDocuments().then((snapshot){
      snapshot.documents.forEach((result) {
        if(result.data["id"] != _adminIDtextcontroller.text.trim()){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Your ID is Incorrect")));
        }
        else if(result.data["password"] != _passtextcontroller.text.trim()){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Your Password is Incorrect")));
        }else{
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Welcome, "+ result.data["name"]),));
          EcommerceApp.sharedPreferences.setString(EcommerceApp.adminName, result.data["name"]);

          setState(() {
            _adminIDtextcontroller.text = "";
            _passtextcontroller.text = "";
          });

          Route route = MaterialPageRoute(builder: (c) => UploadPage());
          Navigator.pushReplacement(context, route);

        }
      });
    });
  }
}
