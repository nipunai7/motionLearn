import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/User/userPref.dart';
import 'package:e_shop/User/widget.dart';
import 'package:flutter/material.dart';

class ReportView extends StatefulWidget {
  const ReportView({Key key}) : super(key: key);

  @override
  _ReportViewState createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  int mnk = 0;
  int orders = 0;
  String total = '0';

  int age = 0;
  String job = "";
  String pref = "";

  String categoryPop = "Salsa";

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(body: uProfile());
  }

  Widget uProfile() {
    final user = UserPref.myUser;
    String img = 'https://www.iconspng.com/uploads/simple-user-icon.png';
    if (EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl) !=
        null) {
      img =
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl);
    }
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        SizedBox(
          height: 20.0,
        ),
        Profile_Widget(
          imagePath: img,
          onclick: () async {},
        ),
        SizedBox(
          height: 24.0,
        ),
        buildName(user),
        SizedBox(
          height: 24.0,
        ),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildButton(mnk.toString(), 'Reports'),
              divider(),
              buildButton(orders.toString(), 'Purchases'),
              divider(),
              buildButton(total, 'Total Spent')
            ],
          ),
        ),
        SizedBox(
          height: 40.0,
        ),
        Container(
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
                              child: Text(age.toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      height: 1.4,
                                      fontWeight: FontWeight.bold))),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(job,
                                  style: TextStyle(
                                      fontSize: 16,
                                      height: 1.4,
                                      fontWeight: FontWeight.bold))),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(pref,
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 6.0,
                      ),
                      Text(
                        categoryPop,
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
        ),
      ],
    );
  }

  Future<int> getData() async {
    int count = 0;
    await Firestore.instance
        .collection("users")
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection("Reports")
        .getDocuments()
        .then((value) => {
              value.documents.forEach((element) {
                count += int.parse(element.data['attempts']);
              })
            });
    int count2 = 0;
    await Firestore.instance
        .collection("users")
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection("orders")
        .getDocuments()
        .then((value) => {count2 = value.documents.length});

    String count3;
    await Firestore.instance
        .collection("users")
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .get()
        .then(
            (value) => {print(value.data), count3 = value.data['totalSpent']});

    String job1;
    await Firestore.instance.collection("users").document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).get().then((value) => {
      job1 = value.data['job']
    });

    int age1;
    await Firestore.instance.collection("users").document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).get().then((value) => {
      age1 = value.data['age']
    });

    String pref1;
    await Firestore.instance.collection("users").document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).get().then((value) => {
      pref1 = value.data['preference']
    });

    // List cat1 = [];
    // List cats = ["Salsa","Break Dance","Hiphop","Other"];
    // await Firestore.instance.collection("users").document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).get().then((value) => {
    //   cat1.add(value.data['salsa']),
    //   cat1.add(value.data['breakdance']) ,
    //   cat1.add(value.data['hiphop']) ,
    //   cat1.add(value.data['other']) ,
    // });
    // int cat = 0;
    // int na = 0;
    // for (int i=0;i<=4;i++) {
    //   if (cat < cat1[i]) {
    //     na = i;
    //   }
    // }
    setState(() {
      if (count == null) {
        count = 0;
      }

      if (count == null) {
        count2 = 0;
      }

      if (count == null) {
        count3 = '0';
      }

      mnk = count;
      orders = count2;
      total = count3;

      job = job1;
      age = age1;
      pref = pref1;

      // categoryPop = cats[na];
    });
    return count;
  }
}

Widget buildButton(String value, String text) => MaterialButton(
      onPressed: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );

Widget divider() => Container(
    height: 24,
    child: VerticalDivider(
      color: Colors.deepPurple,
      thickness: 1.4,
    ));
