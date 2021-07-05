import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminLogin.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}





class _LoginState extends State<Login>
{
  final TextEditingController _passtextcontroller = TextEditingController();
  final TextEditingController _emailextcontroller = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    double _screenwidth = MediaQuery.of(context).size.width, _screenheight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 10.0,),
            Container(
              child: Image.asset("images/login.png",height: 240.0,width: 240.0,),
            ),
            Padding(padding: EdgeInsets.all(8.0),
            child: Text("Login to your Account",style: TextStyle(color: Colors.white),
            ),
            ),
            Form(
              key: _formkey,
              child: Column(
                children: [
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
                 ],
              ),
            ),
            SizedBox(height: 16.0,),
            ElevatedButton(
              onPressed: () { _emailextcontroller.text.isNotEmpty && _passtextcontroller.text.isNotEmpty
              ? loginUser()
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
            SizedBox(height: 20.0,),
            Container(
              height: 4.0,
              width: _screenwidth* 0.8,
              color: Colors.white,
            ),
            SizedBox(height: 1.0,),
            Container(
                child: Column(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AdminSignInPage())),
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        ),
                        child: Text("Admin Login",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      ),
                    ],
                )
            )
          ],
        ),
      ),
    );
  }
  FirebaseAuth _auth = FirebaseAuth.instance;
  void loginUser() async{
    showDialog(
        context: context,
        builder: (c){
          return LoadingAlertDialog(message: "Logging in...",);
        }
        );
    FirebaseUser firebaseUser;
    await _auth.signInWithEmailAndPassword(
        email: _emailextcontroller.text.trim(),
        password: _passtextcontroller.text.trim(),
    ).then((authUser){
      firebaseUser = authUser.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c){
            return ErrorAlertDialog(message: error.message.toString(),);
          }
      );
    });

    if(firebaseUser != null){
      readData(firebaseUser).then((s){
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future readData(FirebaseUser fUser) async{
    Firestore.instance.collection("users").document(fUser.uid).get().then((dataSnapShot) async {
      await EcommerceApp.sharedPreferences.setString("uid", dataSnapShot.data[EcommerceApp.userUID]);
      await EcommerceApp.sharedPreferences.setString("email", dataSnapShot.data[EcommerceApp.userEmail]);
      await EcommerceApp.sharedPreferences.setString("name", dataSnapShot.data[EcommerceApp.userName]);
      await EcommerceApp.sharedPreferences.setString("url", dataSnapShot.data[EcommerceApp.userAvatarUrl]);
      await EcommerceApp.sharedPreferences.setString("jdate", dataSnapShot.data[EcommerceApp.jdate]);
      List<String> itemlist = dataSnapShot.data[EcommerceApp.items].cast<String>();
      await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.items, itemlist);
      List<String> cartList = dataSnapShot.data[EcommerceApp.userCartList].cast<String>();
      await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, cartList);
    });
  }
}
