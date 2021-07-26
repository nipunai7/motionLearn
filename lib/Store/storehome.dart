import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Store/report.dart';
import 'package:e_shop/User/numbers.dart';
import 'package:e_shop/User/profile.dart';
import 'package:e_shop/User/user.dart';
import 'package:e_shop/User/userPref.dart';
import 'package:e_shop/User/widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/orderCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/Config/config.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';

double width;

class StoreHome extends StatefulWidget {
  // int currentIndex;
  // StoreHome(this.currentIndex);
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  int _currentIndex = 0;

  final tabs = [
    CustomScrollView(
      slivers: [
        SliverPersistentHeader(pinned: true, delegate: SearchBoxDelegate()),
        StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection("Items")
              .limit(15)
              .orderBy("publishedDate", descending: true)
              .snapshots(),
          builder: (context, dataSnapshot) {
            return !dataSnapshot.hasData
                ? SliverToBoxAdapter(
                    child: Center(
                      child: circularProgress(),
                    ),
                  )
                : SliverStaggeredGrid.countBuilder(
                    crossAxisCount: 1,
                    staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                    itemBuilder: (context, index) {
                      ItemModel model = ItemModel.fromJson(
                          dataSnapshot.data.documents[index].data);
                      return sourceInfo(model, context);
                    },
                    itemCount: dataSnapshot.data.documents.length,
                  );
          },
        )
      ],
    ),
    Center(
        child: WebView(
      initialUrl:
          'https://www.google.com/search?q=latest+news+augmented+reality&sxsrf=ALeKk00lT-VbKfPDBDWNlHdTa3H2xVnBLA:1625480430223&source=lnms&tbm=nws&sa=X&ved=2ahUKEwivwYe92svxAhVhqksFHUcFBmoQ_AUoAXoECAEQAw&cshid=1625480435898687&biw=1550&bih=770',
      javascriptMode: JavascriptMode.unrestricted,
    )),
    Center(
        child: MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 48.0,
            bottom: TabBar(
              indicatorColor: Colors.purpleAccent,
              tabs: [
                Tab(icon: Icon(Icons.person_pin)),
                Tab(icon: Icon(Icons.document_scanner_rounded)),
                Tab(icon: Icon(Icons.favorite_outlined)),
                Tab(icon: Icon(Icons.attach_money_rounded)),
              ],
            ),
            backgroundColor: Colors.deepPurple,
          ),
          body: TabBarView(
            children: [
              Container(child: uProfile()),
              Container(
                child: Column(
                  children: [
                    Container(
                      height: 500.0,
                      child: StreamBuilder(
                        stream: Firestore.instance
                            .collection("users")
                            .document(EcommerceApp.sharedPreferences
                                .getString(EcommerceApp.userUID))
                            .collection("Reports")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container(
                              child: Center(child: Text("No Reports")),
                            );
                          }
                          return ListView(
                            children:
                                snapshot.data.documents.map<Widget>((document) {
                              return Container(
                                height: 70.0,
                                child: InkWell(
                                  onTap: () {
                                    try {
                                      // launch(document['fullurl']);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (c) => ReportPage(
                                                    url: document['fullurl'],
                                                  )));
                                      print(document['fullurl']);
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  child: Card(
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            document['tutorial Name'] +
                                                ' attempt: ' +
                                                document['attempt'],
                                            style: TextStyle(fontSize: 18.0),
                                          ),
                                        )),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: EcommerceApp.firestore
                      .collection(EcommerceApp.collectionUser)
                      .document(EcommerceApp.sharedPreferences
                          .getString(EcommerceApp.userUID))
                      .collection(EcommerceApp.collectionOrders)
                      .snapshots(),
                  builder: (c, snapshots) {
                    return snapshots.hasData
                        ? ListView.builder(
                            itemCount: snapshots.data.documents.length,
                            itemBuilder: (c, index) {
                              return FutureBuilder<QuerySnapshot>(
                                future: Firestore.instance
                                    .collection("Items")
                                    .where("shortInfo",
                                        whereIn: snapshots.data.documents[index]
                                            .data[EcommerceApp.productID])
                                    .getDocuments(),
                                builder: (c, snap) {
                                  return snap.hasData
                                      ?
                                      //Center(child: Text("We do have data"))
                                      OrderCard(
                                          itemCount: snap.data.documents.length,
                                          data: snap.data.documents,
                                          orderID: snapshots
                                              .data.documents[index].documentID,
                                        )
                                      : Center(
                                          child: circularProgress(),
                                        );
                                },
                              );
                            },
                          )
                        : Center(
                            child: circularProgress(),
                          );
                  },
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      height: 500.0,
                      child: StreamBuilder(
                        stream: Firestore.instance
                            .collection("users")
                            .document(EcommerceApp.sharedPreferences
                                .getString(EcommerceApp.userUID))
                            .collection("orders")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container(
                              child: Center(child: Text("No Invoices")),
                            );
                          }
                          return ListView(
                            children:
                                snapshot.data.documents.map<Widget>((document) {
                              return Container(
                                height: 70.0,
                                child: InkWell(
                                  onTap: () {
                                    try {
                                      launch(document['invoice']);
                                      print(document['invoice']);
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  child: Card(
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            document['id'],
                                            style: TextStyle(fontSize: 18.0),
                                          ),
                                        )),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )),
    ListView(
      children: [
        InkWell(
          onTap: () {},
          child: Card(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 8.0),
              child: Text(
                "Break Dance 2",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          child: Card(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 8.0),
              child: Text(
                "Salsa 1",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          child: Card(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 8.0),
              child: Text(
                "Hiphop 1",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ),
        ),
      ],
    ),
    Center(
      child: Text("Settings"),
    )
  ];

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        selectedLabelStyle: TextStyle(color: Colors.red),
        unselectedLabelStyle: TextStyle(color: Colors.white38),
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: "Store",
            backgroundColor: Colors.deepPurple,
            //activeIcon: Icon(Icons.store,color: Colors.white)
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.news_solid),
            label: "News",
            backgroundColor: Colors.deepPurpleAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Profile",
            backgroundColor: Colors.deepPurple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Categories",
            backgroundColor: Colors.deepPurpleAccent,
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.settings),
          //   label: "Settings",
          //   backgroundColor: Colors.deepPurple,
          // )
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: () async {
      bool bought = false;
      await Firestore.instance
          .collection("users")
          .where("items", arrayContainsAny: [model.shortInfo.trim()])
          .getDocuments()
          .then((value) async => {
                print(value.documents.toString()),
                if (value.documents.length == 0)
                  {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (c) => ProductPage(
                                  itemModel: model,
                                  bought: false,
                                ))),
                  }
                else
                  {
                    value.documents.forEach((element) async {
                      if (EcommerceApp.sharedPreferences
                              .getString(EcommerceApp.userUID) ==
                          element.documentID) {
                        print("Must be UID" + element.documentID);
                        bought = true;
                        Route route = MaterialPageRoute(
                            builder: (c) => ProductPage(
                                  itemModel: model,
                                  bought: true,
                                ));
                        Navigator.pushReplacement(context, route);
                      }
                      print(bought);
                    }),
                  }
              });
    },
    splashColor: Colors.purple,
    child: Padding(
      padding: EdgeInsets.all(6.0),
      child: Container(
        height: 160.0,
        width: width,
        child: Row(
          children: [
            Image.network(
              model.thumbnailUrl,
              width: 140.0,
              height: 140.0,
            ),
            SizedBox(
              width: 4.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 8.0,
                  ),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            model.title,
                            style: TextStyle(
                                color: Colors.deepPurpleAccent, fontSize: 14.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0.0,
                  ),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            model.shortInfo,
                            style: TextStyle(
                                color: Colors.black54, fontSize: 12.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.purple,
                        ),
                        alignment: Alignment.topLeft,
                        width: 40.0,
                        height: 43.0,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "50%",
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                "OFF",
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 0.0),
                            child: Row(
                              children: [
                                Text(
                                  "Original Price: Rs." +
                                      (model.price * 2).toString(),
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Row(
                              children: [
                                Text(
                                  "New Price: Rs." + model.price.toString(),
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.grey),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Flexible(
                    child: Container(),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: removeCartFunction == null
                        ? IconButton(
                            icon: Icon(
                              Icons.add_shopping_cart,
                              color: Colors.deepPurple,
                            ),
                            onPressed: () {
                              checkItemInCart(model.shortInfo, context);
                            },
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.deepPurple,
                            ),
                            onPressed: () {
                              removeCartFunction();
                              Route route = MaterialPageRoute(
                                  builder: (c) => StoreHome());
                              Navigator.pushReplacement(context, route);
                            },
                          ),
                  ),
                  Divider(
                    height: 6.0,
                    color: Colors.deepPurple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildName(User user) {
  String name = 'loading';
  String email = 'loading';
  if (EcommerceApp.sharedPreferences.getString(EcommerceApp.userName) != null){
    name = EcommerceApp.sharedPreferences.getString(EcommerceApp.userName);
  }

  if (EcommerceApp.sharedPreferences.getString(EcommerceApp.userEmail) != null){
    email = EcommerceApp.sharedPreferences.getString(EcommerceApp.userEmail);
  }
  return Column(
    children: [
      Text(
        name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      const SizedBox(
        height: 4,
      ),
      Text(
        email,
        style: TextStyle(
            color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 15.0),
      )
    ],
  );
}

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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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

Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container();
}

void checkItemInCart(String productID, BuildContext context) {
  print(EcommerceApp.sharedPreferences.getStringList(EcommerceApp.items));
  print(EcommerceApp.sharedPreferences.getString(EcommerceApp.totalSpent));
  //EcommerceApp.sharedPreferences.setStringList(EcommerceApp.items, []);

  EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.items)
          .contains(productID)
      ? Fluttertoast.showToast(msg: "You already own this tutorial.")
      : EcommerceApp.sharedPreferences
              .getStringList(EcommerceApp.userCartList)
              .contains(productID)
          ? Fluttertoast.showToast(msg: "Item is already in Cart.")
          : addItemtoCart(productID, context);
}

addItemtoCart(String tutoID, BuildContext context) {
  List tempList =
      EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
  tempList.add(tutoID);

  EcommerceApp.firestore
      .collection(EcommerceApp.collectionUser)
      .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .updateData({
    EcommerceApp.userCartList: tempList,
  }).then((v) {
    Fluttertoast.showToast(msg: "Item Added to the Cart");
    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, tempList);
    Provider.of<CartItemCounter>(context, listen: false).displayResult();
  });
}

Widget uProfile() {
  final user = UserPref.myUser;
  String img = 'https://www.iconspng.com/uploads/simple-user-icon.png';
  if (EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl) != null){
    img = EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl);
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
      NumbersWidget(
        user: user,
      ),
      SizedBox(
        height: 40.0,
      ),
      about(user),
    ],
  );
}
