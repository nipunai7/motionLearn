import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';

class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.deepPurple,Colors.deepPurple],
              begin: const FractionalOffset(0.0,0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0,1.0],
                tileMode: TileMode.clamp,
              )
            ),
          ),
          title: Text("Motion Learn",style: TextStyle(fontFamily: "Signatra",fontSize: 40,color: Colors.white),
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.lock,color: Colors.white,),
                text: "Login",
              ),
              Tab(
                icon: Icon(Icons.person_add,color: Colors.white,),
                text: "Register",
              )
            ],
            indicatorColor: Colors.white38,
            indicatorWeight: 6.0,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.deepPurple,Colors.deepPurple],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              )
          ),
          child: TabBarView(
            children: [
              Login(),
              Register(),
            ],
          ),
        ),
      ),
    );
  }
}
