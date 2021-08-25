import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Training/training.dart';
import 'package:e_shop/Training/widget/advanced_overlay_widget.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:e_shop/Models/item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class ProductPage extends StatefulWidget {
  final ItemModel itemModel;
  final bool bought;

  ProductPage({this.itemModel, this.bought});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  VideoPlayerController controller;

  TextEditingController reviewT = TextEditingController();
  int numOfItems = 1;

  Orientation target;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.network(widget.itemModel.videoUrl)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize();

    NativeDeviceOrientationCommunicator()
        .onOrientationChanged(useSensor: true)
        .listen((event) {
      final isPortrait = event == NativeDeviceOrientation.portraitUp;
      final isLandscape = event == NativeDeviceOrientation.landscapeLeft ||
          event == NativeDeviceOrientation.landscapeRight;
      final isTargetPortrait = target == Orientation.portrait;
      final isTargetLandscape = target == Orientation.landscape;

      if (isPortrait && isTargetPortrait || isLandscape && isTargetLandscape) {
        target = null;
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    setOrientation(true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            height: 2.0,
                          ),
                          Text(
                            "Break Dance",
                            style: TextStyle(color: Colors.black45),
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
                  Container(
                      height: 200.0,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.topCenter,
                      child: buildVideo()
                      //
                      ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                    child: Center(
                        child: new Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.deepPurple)),
                            child: Row(
                              children: <Widget>[
                                Flexible(child: bought()),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bought() {
    if (widget.bought == true) {
      return review();
    } else {
      return addToCart();
    }
  }

  Widget addToCart() {
    print(widget.bought);
    print("Add to cart");
    if (widget.bought == false) {
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
    } else {
      return Container();
    }
    //  print (EcommerceApp.sharedPreferences.getString(EcommerceApp.bought));
  }

  Widget training() {
    bool bought = widget.bought;
    if (bought == true) {
      return InkWell(
        onTap: () {
          updateCat(widget.itemModel.category);
          Route route =
              MaterialPageRoute(builder: (c) => TrainingPage(widget.itemModel));
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
    } else {
      return Container();
    }
  }

  updateCat(String cat) async {
    int count = 0;
    await Firestore.instance
        .collection("users")
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .get()
        .then((value) => {count = value.data[cat]});
    count++;
    await Firestore.instance
        .collection("users")
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .updateData({cat: count});

    print(cat + " " + count.toString());
  }

  Widget submitRev() {
    if (widget.bought == true) {
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
    } else {
      return Container();
    }
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
    }).then((value) => {
              Fluttertoast.showToast(msg: "Review added successfully"),
              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => ProductPage(itemModel: widget.itemModel,bought: widget.bought,)))
            });
  }

  Widget review() {
    if (widget.bought == true) {
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
    } else {
      return Container();
    }
  }

  viewRev() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3,
      child: StreamBuilder(
        stream: Firestore.instance
            .collection("Items")
            .document(widget.itemModel.id)
            .collection("Reviews")
            .limit(5)
            .snapshots(),
        builder: (context, snapshot12) {
          if (!snapshot12.hasData) {
            print("No data");
            return CircularProgressIndicator();
          }
          return ListView(
            children: snapshot12.data.documents.map<Widget>((document) {
              print("Name: " + document['userName']);
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
                                  title: Text(document['userName']),
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(document['userIMG']),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      document['review'],
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                )
                              ],
                            )))),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget buildVideo() => OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;

          setOrientation(isPortrait);

          return Stack(
            fit: isPortrait ? StackFit.loose : StackFit.expand,
            children: <Widget>[
              buildVideoPlayer(),
              Positioned.fill(
                child: AdvancedOverlayWidget(
                  controller: controller,
                  onClickedFullScreen: () {
                    target = isPortrait
                        ? Orientation.landscape
                        : Orientation.portrait;

                    // if (isPortrait) {
                    //   AutoOrientation.landscapeRightMode();
                    // } else {
                    //   AutoOrientation.portraitUpMode();
                    // }
                  },
                ),
              ),
            ],
          );
        },
      );

  Widget buildVideoPlayer() {
    final video = AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: VideoPlayer(controller),
    );

    return buildFullScreen(child: video);
  }

  Widget buildFullScreen({
    @required Widget child,
  }) {
    final size = controller.value.size;
    final width = size?.width ?? 0;
    final height = size?.height ?? 0;

    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(width: width, height: height, child: child),
    );
  }

  void setOrientation(bool isPortrait) {
    if (isPortrait) {
      Wakelock.disable();
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    } else {
      Wakelock.enable();
      SystemChrome.setEnabledSystemUIOverlays([]);
    }
  }
}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
