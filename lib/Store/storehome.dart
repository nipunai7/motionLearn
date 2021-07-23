import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Store/cart.dart';
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
import 'package:cloud_functions/cloud_functions.dart';

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
              Container(
                  child: Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: 230.0,
                    width: 230.0,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(EcommerceApp
                          .sharedPreferences
                          .getString(EcommerceApp.userAvatarUrl)),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      EcommerceApp.sharedPreferences
                          .getString(EcommerceApp.userName),
                      style:
                          TextStyle(fontSize: 24.0, color: Colors.deepPurple),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, top: 20.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Email: " +
                            EcommerceApp.sharedPreferences
                                .getString(EcommerceApp.userEmail),
                        style:
                            TextStyle(fontSize: 18.0, color: Colors.deepPurple),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, top: 10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Joined on: " +
                            EcommerceApp.sharedPreferences
                                .getString(EcommerceApp.jdate.toString()),
                        style:
                            TextStyle(fontSize: 18.0, color: Colors.deepPurple),
                      ),
                    ),
                  ),
                ],
              )),
              Container(
                child: Column(
                  children: [
                    Container(
                      height: 70.0,
                      child: Card(
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(
                                "1624873033163_report",
                                style: TextStyle(fontSize: 18.0),
                              ),
                            )),
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
                            .limit(5)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            print("No orders");
                          }
                          return ListView(
                            children:
                                snapshot.data.documents.map<Widget>((document) {
                              return Container(
                                height: 70.0,
                                child: InkWell(
                                  onTap: () {
                                    try {
                                      OpenFile.open(
                                          "/sdcard/Download/Motion_learn 1625472060264_order[9279].pdf");
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
    Center(
      child: Text("Categories"),
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
            icon: Icon(Icons.document_scanner_sharp),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
            backgroundColor: Colors.deepPurple,
          )
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

Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container();
}

void checkItemInCart(String productID, BuildContext context) {

  print(EcommerceApp.sharedPreferences.getStringList(EcommerceApp.items));
  print(EcommerceApp.sharedPreferences.getString(EcommerceApp.totalSpent));
  // EcommerceApp.sharedPreferences.setStringList(EcommerceApp.items, []);

  EcommerceApp.sharedPreferences.getStringList(EcommerceApp.items).contains(productID)
  ? Fluttertoast.showToast(msg: "You already own this tutorial.")

  :EcommerceApp.sharedPreferences
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
