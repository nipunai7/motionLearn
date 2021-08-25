import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Admin/product_admin.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Widgets/myDrawer2.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../Widgets/chewiePlayer.dart';

class ProductEdit extends StatefulWidget {
  final ItemModel itemModel;

  ProductEdit({this.itemModel});

  @override
  _ProductEditState createState() => _ProductEditState();
}

class _ProductEditState extends State<ProductEdit> {
  int numOfItems = 1;

  final TextEditingController _titletextcontroller = TextEditingController();
  final TextEditingController _shorttextcontroller = TextEditingController();
  final TextEditingController _longtexttcontroller = TextEditingController();
  final TextEditingController _pricetexttcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        Route route = MaterialPageRoute(
            builder: (c) => ProductAdmin(itemModel: widget.itemModel));
        Navigator.pushReplacement(context, route);
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
          title: Text(
            "Edit Tutorial",
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
          leading: IconButton(
              onPressed: () {
                Route route = MaterialPageRoute(
                    builder: (c) => ProductAdmin(itemModel: widget.itemModel));
                Navigator.pushReplacement(context, route);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          actions: [
            TextButton(
              child: Text(
                "Done",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                addUpdatedDetails();
              },
            ),
          ],
        ),
        drawer: MyDrawer2(),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(14.0),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.network(widget.itemModel.thumbnailUrl),
                      ),
                      Container(
                        color: Colors.deepPurpleAccent,
                        child: SizedBox(
                          height: 1.0,
                          width: double.infinity,
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            isObsecure: false,
                            data: Icons.text_fields,
                            controller: _titletextcontroller
                              ..text = widget.itemModel.title,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                              controller: _shorttextcontroller
                                ..text = widget.itemModel.shortInfo),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                              controller: _longtexttcontroller
                                ..text = widget.itemModel.longDescription),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Rs.",
                            style: boldTextStyle,
                          ),
                          TextField(
                            controller: _pricetexttcontroller
                              ..text = widget.itemModel.price.toString(),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     Align(
                  //         alignment: Alignment.centerLeft,
                  //         child: Padding(
                  //             padding: EdgeInsets.only(top: 8.0,bottom: 16.0),
                  //             child: Center(
                  //               child: InkWell(
                  //                 onTap: () {
                  //
                  //                 },
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                     color: Colors.deepPurple,
                  //                   ),
                  //                   width: 150,
                  //                   height: 50.0,
                  //                   child: Center(
                  //                     child: Text("Edit Tutorial",style: TextStyle(color: Colors.white,),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             )
                  //         )
                  //     ),
                  //     Align(
                  //         alignment: Alignment.centerRight,
                  //         child: Padding(
                  //             padding: EdgeInsets.only(top: 8.0,bottom: 16.0),
                  //             child: Center(
                  //               child: InkWell(
                  //                 onTap: ()=> deleteTuto(),
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                     color: Colors.deepPurple,
                  //                   ),
                  //                   width: 150,
                  //                   height: 50.0,
                  //                   child: Center(
                  //                     child: Text("Delete Tutorial",style: TextStyle(color: Colors.white,),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             )
                  //         )
                  //     ),
                  //   ],
                  // ),
                  Container(
                    height: 200.0,
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                      children: <Widget>[
                        ChewiListItem(
                          videoPlayerController: VideoPlayerController.network(
                            widget.itemModel.videoUrl,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  deleteTuto() {
    Firestore.instance
        .collection("Items")
        .where("tutorial", isEqualTo: widget.itemModel.videoUrl)
        .getDocuments()
        .then((value) => {
              value.documents.forEach((element) {
                Firestore.instance
                    .collection("Items")
                    .document(element.documentID)
                    .delete();
              })
            });

    Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
    Navigator.pushReplacement(context, route);
  }

  addUpdatedDetails() {
    writeTutoInfo({
      "longDescription": _longtexttcontroller.text.trim(),
      "price": int.parse(_pricetexttcontroller.text.trim()),
      "shortInfo": _shorttextcontroller.text.trim(),
      "title": _titletextcontroller.text.trim(),
      "publishedDate": widget.itemModel.publishedDate,
      "status": widget.itemModel.status,
      "thumbnailUrl": widget.itemModel.thumbnailUrl,
      "tutorial": widget.itemModel.videoUrl,
    });
    print(_titletextcontroller.text);
    Route route = MaterialPageRoute(
        builder: (c) => ProductAdmin(itemModel: widget.itemModel));
    Navigator.pushReplacement(context, route);
  }

  Future writeTutoInfo(Map<String, dynamic> data) async {
    await EcommerceApp.firestore
        .collection("Items")
        .where("tutorial", isEqualTo: widget.itemModel.videoUrl)
        .getDocuments()
        .then((value) => {
              value.documents.forEach((element) {
                Firestore.instance
                    .collection("Items")
                    .document(element.documentID)
                    .setData(data);
              })
            });
  }
}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
