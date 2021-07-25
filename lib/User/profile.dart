import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/User/user.dart';
import 'package:e_shop/User/userPref.dart';
import 'package:e_shop/User/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'numbers.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static final String title = "User Profile";

  @override
  Widget build(BuildContext context) {
    final user = UserPref.myUser;
    return WillPopScope(
        onWillPop: () {},
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              color: Colors.deepPurple,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (c) => StoreHome()));
                  },
                  icon: Icon(
                    CupertinoIcons.moon_stars,
                    color: Colors.deepPurple,
                  ))
            ],
          ),
          body: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Profile_Widget(
                imagePath: user.imagePath,
                onclick: () async {},
              ),
              SizedBox(
                height: 24.0,
              ),
              buildName(user),
              SizedBox(
                height: 24.0,
              ),
              NumbersWidget(
                user: user,
              ),
              SizedBox(
                height: 40.0,
              ),
              about(user),
              Card(
                child: Container(
                    alignment: Alignment.centerLeft,
                    height: 50.0,
                    child: Center(child: Text("Break Dance"))),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0,bottom: 12.0,left: 8.0),
                  child: Text("Salsa",style: TextStyle(fontSize: 20.0),),
                ),
              ),
              Card(
                child: Text("Hiphop"),
              )
            ],
          ),
        ));
  }

  Widget buildName(User user) => Column(
        children: [
          Text(
            user.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            user.email,
            style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
                fontSize: 15.0),
          )
        ],
      );

  Widget about(User user) => Container(
        //padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'About',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 1),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 120.0,
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text("Age: ",
                                style: TextStyle(
                                    fontSize: 16,
                                    height: 1.4,
                                    fontWeight: FontWeight.bold))),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text("Occupation: ",
                                style: TextStyle(
                                    fontSize: 16,
                                    height: 1.4,
                                    fontWeight: FontWeight.bold))),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text("Interests: ",
                                style: TextStyle(
                                    fontSize: 16,
                                    height: 1.4,
                                    fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                  Container(
                    width: 250.0,
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(user.age,
                                style: TextStyle(
                                    fontSize: 16,
                                    height: 1.4,
                                    fontWeight: FontWeight.bold))),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(user.occupation,
                                style: TextStyle(
                                    fontSize: 16,
                                    height: 1.4,
                                    fontWeight: FontWeight.bold))),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(user.interests,
                                style: TextStyle(
                                    fontSize: 16,
                                    height: 1.4,
                                    fontWeight: FontWeight.bold)))
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Center(
              child: Container(
                child: Column(
                  children: [
                    Text(
                      "Most Viewed Category",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 6.0,
                    ),
                    Text(
                      user.mostPlayed,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
}
