import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/ML/home.dart';
import 'package:e_shop/ML/test/home.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:e_shop/Models/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';
import '../Widgets/chewiePlayer.dart';

class ProductPage extends StatefulWidget {
  final ItemModel itemModel;

  ProductPage({this.itemModel});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<CameraDescription> cameras;

  TextEditingController reviewT = TextEditingController();
  int numOfItems = 1;

  @override
  Widget build(BuildContext context) {
    // Firestore.instance.collection("users").where("items", arrayContainsAny: [widget.itemModel.shortInfo]).getDocuments().then((value) => {
    //   print (value.documents.length),
    //   if (value.documents.length == 0){
    //     EcommerceApp.sharedPreferences.setString(EcommerceApp.bought, "false")
    //   },
    //
    //   value.documents.forEach((element) {
    //     if (EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) == element.documentID) {
    //       print (element.documentID);
    //       print (EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID));
    //       EcommerceApp.sharedPreferences.setString(EcommerceApp.bought, "true");
    //     }
    //   })
    // });

    Size screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
          title: Text(
            widget.itemModel.title,
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
          leading: IconButton(
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => StoreHome());
                Navigator.pushReplacement(context, route);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        drawer: MyDrawer(),
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
                          Text(
                            widget.itemModel.title,
                            style: boldTextStyle,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            widget.itemModel.longDescription,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Rs." + widget.itemModel.price.toString(),
                            style: boldTextStyle,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                    child: Center(child: training()),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                    child: Center(
                        child: new Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.deepPurple)),
                            child: Row(
                              children: <Widget>[
                                Flexible(child: review()),
                              ],
                            ))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                    child: Center(child: submitRev()),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                    child: Center(child: viewRev()),
                  ),
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

  Widget bought() {
    EcommerceApp.sharedPreferences
        .getStringList(EcommerceApp.items)
        .forEach((element) {
      return null;
    });
  }

  Widget addToCart() {
    //  print (EcommerceApp.sharedPreferences.getString(EcommerceApp.bought));
    return InkWell(
      onTap: () => checkItemInCart(widget.itemModel.shortInfo, context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple,
        ),
        width: MediaQuery.of(context).size.width - 40.0,
        height: 50.0,
        child: Center(
          child: Text(
            "Add to Cart",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget training() {
    return InkWell(
      onTap: () {
        Route route =
            MaterialPageRoute(builder: (c) => HomePageML(widget.itemModel));
        Navigator.pushReplacement(context, route);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple,
        ),
        width: MediaQuery.of(context).size.width - 40.0,
        height: 50.0,
        child: Center(
          child: Text(
            "Training View",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget submitRev() {
    return InkWell(
      onTap: () {
        print(widget.itemModel.reviews);
        submitRevtoDB();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple,
        ),
        width: MediaQuery.of(context).size.width - 40.0,
        height: 50.0,
        child: Center(
          child: Text(
            "Submit Review",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  submitRevtoDB() async {
    if (widget.itemModel.reviews.isEmpty) {
      widget.itemModel.reviews.add("value");
    }
    List tempRev = widget.itemModel.reviews;
    tempRev.add(reviewT.text.trim());

    DocumentReference df2 =
        Firestore.instance.collection('Items').document(widget.itemModel.id);

    df2.updateData({
      'reviews': FieldValue.arrayUnion([reviewT.text.trim()]),
    }).then(
        (value) => {Fluttertoast.showToast(msg: "Review added successfully")});

    widget.itemModel.reviews.add(reviewT.text.trim());
    print(reviewT.text.trim());

    EcommerceApp.tempPurchase.add(reviewT.text.trim());

    String tempRevID =
        DateTime.now().millisecondsSinceEpoch.toString() + "_review";

    await EcommerceApp.firestore
        .collection("Items")
        .document(widget.itemModel.id)
        .collection("Reviews")
        .document(tempRevID)
        .setData({
      "revID": tempRevID,
      "review": reviewT.text.trim(),
      "user": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      "userIMG":
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl),
      "userName":
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
    }).then((value) =>
            {Fluttertoast.showToast(msg: "Review added successfully")});
  }

  Widget review() {
    return InkWell(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomTextField(
            controller: reviewT,
            data: Icons.insert_emoticon,
            hintText: "Review",
            isObsecure: false,
          )
        ],
      ),
    );
  }

  Widget viewRev() {
    List tempL = widget.itemModel.reviews;
    print(tempL);

    return InkWell(
      child: Container(
          // decoration: BoxDecoration(
          //   border: Border.all(color: Colors.deepPurple)
          // ),
          child: Card(
              child: Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text("Nipuna Munasinghe"),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(EcommerceApp
                              .sharedPreferences
                              .getString(EcommerceApp.userAvatarUrl)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "This is a very good tutorial, Thank you",
                            textAlign: TextAlign.left,
                          ),
                        ),
                      )
                    ],
                  )))),
    );
  }
}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
