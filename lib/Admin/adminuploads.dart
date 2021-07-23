import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/product_admin.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Models/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminUploads extends StatefulWidget {
  @override
  _AdminUploads createState() => _AdminUploads();
}

class _AdminUploads extends State<AdminUploads> {
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Route route = MaterialPageRoute(builder: (c) => UploadPage());
        Navigator.pushReplacement(context, route);
      },
      child: Scaffold(
          appBar: AppBar(
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
}
