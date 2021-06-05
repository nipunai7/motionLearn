import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Address/PaypalPayment.dart';
import 'package:e_shop/Address/PurchasePage.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Address/address.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Counters/totalMoney.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  double totalAmount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    totalAmount = 0;
    Provider.of<TotalAmount>(context,listen: false).displayResult(0);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: (){
      Route route = MaterialPageRoute(builder: (c) => StoreHome());
      Navigator.pushReplacement(context, route);
        },
      child: Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          if(EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).length == 1){
            Fluttertoast.showToast(msg: "Cart is empty.");
          }else{
            Route route = MaterialPageRoute(builder: (c) => PurchasePage());
            Navigator.pushReplacement(context, route);
          }
        },
        backgroundColor: Colors.deepPurple,
        icon: Icon(Icons.navigate_next),
        label: Text("Check out"),
      ),
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(builder: (context, amountProvider, cartProvider,c){
              return Padding(padding: EdgeInsets.all(8.0),
                child: Center(
                  child: cartProvider.count == 0
                  ? Container()
                      : Text("Total Price: Rs ${amountProvider.total.toString()}",style: TextStyle(color: Colors.black54,fontSize: 20.0,fontWeight: FontWeight.w500),
                  ),
                ),
              );
            },),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: EcommerceApp.firestore.collection("Items").where("shortInfo", whereIn: EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList)).snapshots(),
            builder: (context,snapshot){
                return !snapshot.hasData
                    ? SliverToBoxAdapter(
                  child: Center(
                    child: circularProgress(),
                  ),
                )
                    :snapshot.data.documents.length == 0
                ?beginCart()
              : SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (context, index){
                          ItemModel model = ItemModel.fromJson(snapshot.data.documents[index].data);
                          if (index==0){
                            totalAmount = 0;
                            totalAmount = model.price + totalAmount;
                          }else{
                            totalAmount = model.price+totalAmount;
                          }

                          if(snapshot.data.documents.length-1 == index){
                            WidgetsBinding.instance.addPostFrameCallback((t) {
                              Provider.of<TotalAmount>(context, listen: false).displayResult(totalAmount);
                            });
                          }
                          return sourceInfo(model,context,removeCartFunction: () => removeItem(model.shortInfo));
                        },
                      childCount: snapshot.hasData ? snapshot.data.documents.length : 0,
                    )
                );
            },
          )
        ],
      ),
      )
    );
  }
  beginCart(){
    return SliverToBoxAdapter(
      child: Card(
        color: Colors.deepPurple,
        child: Container(
          height: 100.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.insert_emoticon,color: Colors.white,),
              Text("Cart is empty.",style: TextStyle(color: Colors.white),),
              Text("Start adding items to your Cart",style: TextStyle(color: Colors.white),),
            ],
          ),
        ),
      ),
    );
  }

  removeItem(String shortId){
    List tempList = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
    tempList.remove(shortId);

    EcommerceApp.firestore.collection(EcommerceApp.collectionUser).document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .updateData({
      EcommerceApp.userCartList: tempList,
    }).then((v){
      Fluttertoast.showToast(msg: "Item removed from the cart");
      EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, tempList);
      Provider.of<CartItemCounter>(context,listen: false).displayResult();
    totalAmount = 0;
    });
  }
}
