import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Orders/myOrders.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/orderCard.dart';
import 'package:e_shop/Models/address.dart';
import 'package:e_shop/Widgets/orderCard2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

String getOrderId="";
class OrderDetails extends StatelessWidget {

  final String orderID;

  OrderDetails({Key key, this.orderID}) : super (key:key);



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Route route = MaterialPageRoute(builder: (c) => MyOrders());
        Navigator.pushReplacement(context, route);
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Colors.white
          ),
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
          title: Text("Order Details",style: TextStyle(color: Colors.white,fontSize: 18.0),),
          leading: IconButton(
              onPressed: (){
                Route route = MaterialPageRoute(builder: (c) => MyOrders());
                Navigator.pushReplacement(context, route);
              },
              icon: Icon(Icons.arrow_back,color: Colors.white,)
          ),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: EcommerceApp.firestore.collection(EcommerceApp.collectionUser).document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).collection(EcommerceApp.collectionOrders).document(orderID).get(),
            builder: (c, snap){
              Map dataMap;
              if (snap.hasData){
                dataMap = snap.data.data;
              }
              return snap.hasData
                  ? Container(
                      child: Column(
                        children: [
                          SizedBox(height: 10.0,),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Totoal Amount Rs."+dataMap[EcommerceApp.totalAmount].toString(),
                              style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Column(
                              children: [
                                Align( alignment: Alignment.centerLeft,
                                  child: Text("Order ID: "+ orderID,style: TextStyle(fontSize: 16.0,color: Colors.deepPurple,)),
                                ),
                                SizedBox(height: 10.0,),
                                Align(alignment: Alignment.centerLeft,
                                  child: Text("Order Date: "+ dataMap["orderTime"],style: TextStyle(fontSize: 16.0,color: Colors.deepPurple,)),
                                ),
                                SizedBox(height: 10.0,),
                                Align(alignment: Alignment.centerLeft,

                                  child: Text("Payment Details: "+ dataMap["paymentDetails"],style: TextStyle(fontSize: 16.0,color: Colors.deepPurple,)),
                                ),
                                SizedBox(height: 10.0,),
                              ],
                            ),
                          ),
                          Divider(height: 4.0,),
                          FutureBuilder<QuerySnapshot>(
                            future: EcommerceApp.firestore.collection("Items").where("shortInfo",whereIn: dataMap[EcommerceApp.productID]).getDocuments(),
                              builder: (c, datasnap){
                              return datasnap.hasData
                                  ?OrderCard2(
                                itemCount: datasnap.data.documents.length,
                                data: datasnap.data.documents,
                              )
                                  :Center(child: circularProgress(),);
                              }
                          ),
                          Divider(height: 4.0,),
                        ],
                      ),
              )
                  :Center(child: circularProgress(),);
            },
          ),
        ),
      ),
    );
  }
}



// class StatusBanner extends StatelessWidget {
//
//   final bool status;
//
//   StatusBanner({Key key, this.status}): super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//
//
//     );
//   }
// }




class PaymentDetailsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
    );
  }
}



class ShippingDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
    );
  }
}



class KeyText extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Text("");
  }
}
