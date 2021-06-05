import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Counters/totalMoney.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'dart:async'
;import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:provider/provider.dart';

class PurchasePage extends StatefulWidget {
  @override
  _PurchasePageState createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {


  double totalAmount;
  List itemInfo = [];


  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: (){
          // ignore: missing_return
          Route route = MaterialPageRoute(builder: (c) => CartPage());
          Navigator.pushReplacement(context, route);
        },
      child:Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Fluttertoast.showToast(msg: "Items purchased");
          removeItems();
        },
        icon: Icon(Icons.confirmation_number),
        label: Text("Confirm Purchase", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,
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
                        : Row(
                      children: [
                        Center(
                          child: Text("Total Price: Rs ${amountProvider.total.toString()}",style: TextStyle(color: Colors.black,fontSize: 25.0,fontWeight: FontWeight.bold),
                          ),
                        ),
                      ]
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
                    :SliverList(
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
                  return sorceInfo2(model, context);
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

 Widget sorceInfo2(ItemModel model, BuildContext context,{Color background}){
   itemInfo.add(model.shortInfo);
   return InkWell(
      splashColor: Colors.purple,
      child: Padding(
        padding: EdgeInsets.all(6.0),
        child: Container(
          height: 160.0,
          width: width,
          child: ListView(children: <Widget>[
            DataTable(
              columns: [
                DataColumn(label:Text("Item")),
                DataColumn(label:Text("Price")),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Container(
                    width: 200.0,
                    child: Text(model.title),
                  )),
                  DataCell(Text(model.price.toString())),
                ]),
              ],
            ),
          ])
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
      //Fluttertoast.showToast(msg: "Item removed from the cart");
      EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, tempList);
      Provider.of<CartItemCounter>(context,listen: false).displayResult();
      totalAmount = 0;
    });
  }

   removeItems(){
     //int count = -1;
      itemInfo.forEach((element) {
       // count++;
       // Firestore.instance.collection('users').document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).updateData({'userCart': FieldValue.arrayRemove([count])}).whenComplete((){
       // print('Field Deleted');
       // });
        DocumentReference df = Firestore.instance.collection('users').document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID));
        List list = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
        list.remove(element);
        df.updateData({
          'userCart':FieldValue.arrayRemove([element]),
          EcommerceApp.userCartList: list,
        });
        EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, list);
        print (element);

        DocumentReference df2 = Firestore.instance.collection('users').document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID));
        List list2 = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.items);

        df.updateData({
          'items':FieldValue.arrayUnion([element]),
        });
        EcommerceApp.sharedPreferences.setStringList(EcommerceApp.items, list2);
        print (element);

      });
      Provider.of<CartItemCounter>(context,listen: false).displayResult();

    Route route = MaterialPageRoute(builder: (c) => StoreHome());
    Navigator.pushReplacement(context, route);


  }
}

