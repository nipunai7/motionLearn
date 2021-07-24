import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {

  final double totalAmount;

  PaymentPage({Key key,this.totalAmount,}) : super (key: key);
  @override
  _PaymentPageState createState() => _PaymentPageState();
}




class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Route route = MaterialPageRoute(builder: (c) => CartPage());
          Navigator.pushReplacement(context, route);
        },
      child: Material(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.deepPurple,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  //child: Image,
                )
              ],
            ),
          ),
        ),
      ),

    );
  }

  addOrderDetails(){
    writeOrderUser({
      EcommerceApp.totalAmount: widget.totalAmount,
      "OrderBy" : EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: "Payment Confirmed",
      EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess: true,
    });

    writeOrderAdmin({
      EcommerceApp.totalAmount: widget.totalAmount,
      "OrderBy" : EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: "Payment Confirmed",
      EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess: true,
    }).whenComplete(() => {
      emptyCart()
    });
  }

  Future writeOrderUser(Map<String, dynamic> data) async{
    await EcommerceApp.firestore.collection(EcommerceApp.collectionUser).document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).collection(EcommerceApp.collectionOrders).document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)+ data['Order Time:']).setData(data);
  }

  Future writeOrderAdmin(Map<String, dynamic> data) async{
    await EcommerceApp.firestore..collection(EcommerceApp.collectionOrders).document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)+ data['Order Time:']).setData(data);
  }

  emptyCart(){
    EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, ["garbageValue"]);
    List temp = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);

    Firestore.instance.collection("users").document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).updateData({
      EcommerceApp.userCartList: temp,
    }).then((value) {
      EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList,temp);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });
    Fluttertoast.showToast(msg: "Purchase Complete, Happy Learning !!!");

    Route route = MaterialPageRoute(builder: (c) => StoreHome());
    Navigator.pushReplacement(context, route);
  }
}
