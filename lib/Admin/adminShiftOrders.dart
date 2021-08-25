import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminOrderCard.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Config/config.dart';
import 'package:flutter/material.dart';
import '../Widgets/loadingWidget.dart';

class AdminShiftOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<AdminShiftOrders> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // ignore: missing_return
        Route route = MaterialPageRoute(builder: (c) => UploadPage());
        Navigator.pushReplacement(context, route);
      },
      child: Scaffold(
        backgroundColor: Colors.deepPurple,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
          title: Text(
            "Customer Purchases",
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
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection("orders").snapshots(),
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
                              ? AdminOrderCard(
                                  itemCount: snap.data.documents.length,
                                  data: snap.data.documents,
                                  orderID: snapshots
                                      .data.documents[index].documentID,
                                  orderBy: snapshots
                                      .data.documents[index].data["OrderBy"],
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
    );
  }
}
