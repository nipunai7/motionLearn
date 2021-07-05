import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/PDF/api/pdf_api.dart';
import 'package:e_shop/PDF/api/pdf_invoice_api.dart';
import 'package:e_shop/PDF/model/customer.dart';
import 'package:e_shop/PDF/model/invoice.dart';
import 'package:e_shop/PDF/model/supplier.dart';
import 'package:e_shop/PDF/page/pdf_page.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Counters/totalMoney.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:e_shop/main.dart';
import 'dart:async'
;import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:provider/provider.dart';

class PurchasePage extends StatefulWidget {

  final double totalAmount;

  PurchasePage({Key key,this.totalAmount,}) : super (key: key);

  @override
  _PurchasePageState createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {

  List tet = [1234,45657667];

  List itemInfo = [];
  double totalAmount2;


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
          addOrderDetails();
          createInvoice();
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
                    totalAmount2 = 0;
                    totalAmount2 = model.price + totalAmount2;
                  }else{
                    totalAmount2 = model.price+totalAmount2;
                  }

                  if(snapshot.data.documents.length-1 == index){
                    WidgetsBinding.instance.addPostFrameCallback((t) {
                      Provider.of<TotalAmount>(context, listen: false).displayResult(totalAmount2);
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

  // removeItem(String shortId){
  //   List tempList = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
  //   tempList.remove(shortId);
  //
  //   EcommerceApp.firestore.collection(EcommerceApp.collectionUser).document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
  //       .updateData({
  //     EcommerceApp.userCartList: tempList,
  //   }).then((v){
  //     //Fluttertoast.showToast(msg: "Item removed from the cart");
  //     EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, tempList);
  //     Provider.of<CartItemCounter>(context,listen: false).displayResult();
  //     totalAmount = 0;
  //   });
  // }

   removeItems(){
      itemInfo.forEach((element) {

        // DocumentReference df = Firestore.instance.collection('users').document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID));
        // List list = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
        // list.remove(element);
        // df.updateData({
        //   'userCart':FieldValue.arrayRemove([element]),
        //   EcommerceApp.userCartList: list,
        // });
        // EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, list);
        // print (element);

        DocumentReference df2 = Firestore.instance.collection('users').document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID));
        List list2 = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.items);

        df2.updateData({
          'items':FieldValue.arrayUnion([element]),
        });
        EcommerceApp.sharedPreferences.setStringList(EcommerceApp.items, list2);
        print (element);

        EcommerceApp.tempPurchase.add(element);

      });
  }

  addOrderDetails(){
    writeOrderUser({
      "id": EcommerceApp.sharedPreferences.getString(EcommerceApp.latestOrder),
      EcommerceApp.totalAmount: totalAmount2,
      "OrderBy" : EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: "Payment Confirmed",
      EcommerceApp.orderTime: DateTime.now().toString(),
      EcommerceApp.isSuccess: true,
    });

    writeOrderAdmin({
      "id": EcommerceApp.sharedPreferences.getString(EcommerceApp.latestOrder),
      EcommerceApp.totalAmount: totalAmount2,
      "OrderBy" : EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: "Payment Confirmed",
      EcommerceApp.orderTime: DateTime.now().toString(),
      EcommerceApp.isSuccess: true,
    }).whenComplete(() => {
      emptyCart(),
      removeItems(),
    });
  }

  Future writeOrderUser(Map<String, dynamic> data) async{
    EcommerceApp.sharedPreferences.setString(EcommerceApp.latestOrder, DateTime.now().millisecondsSinceEpoch.toString()+"_order");
    await EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
        .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.latestOrder)).setData(data);
  }

  Future writeOrderAdmin(Map<String, dynamic> data) async{
    await EcommerceApp.firestore
        .collection(EcommerceApp.collectionOrders)
        .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.latestOrder)).setData(data);
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
  }

  createInvoice() async{
    final date = DateTime.now();
    final dueDate = date.add(Duration(days: 7));

    final invoice = Invoice(
      supplier: Supplier(
        name: 'Motion Learn Admin',
        address: '',
        paymentInfo: '',
      ),
      customer: Customer(
        name: EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
        address: '',
      ),
      info: InvoiceInfo(
        date: date,
        dueDate: dueDate,
        description: "Order ID: "+EcommerceApp.sharedPreferences.getString(EcommerceApp.latestOrder),
        number: '${DateTime.now().millisecond}-9999',
        order: EcommerceApp.sharedPreferences.getString(EcommerceApp.latestOrder),
      ),
      items: [
        InvoiceItem(
          description: 'HOW TO SHUFFLE DANCE',
          date: DateTime.now(),
          quantity: 1,
          vat: 0.19,
          unitPrice: 120,
        ),
        InvoiceItem(
          description: 'BASIC DANCE STEPS|TOUCHE',
          date: DateTime.now(),
          quantity: 1,
          vat: 0.19,
          unitPrice: 100,
        ),
      ],
    );

    final pdfFile = await PdfInvoiceApi.generate(invoice);

    Route route = MaterialPageRoute(builder: (c) => StoreHome());
    Navigator.pushReplacement(context, route);
    Provider.of<CartItemCounter>(context, listen: false).displayResult();
    PdfApi.openFile(pdfFile);
  }

  // mnk(String des, double unitP){
  //     return InvoiceItem(
  //       description: des,
  //       date: DateTime.now(),
  //       quantity: 1,
  //       vat: 0.19,
  //       unitPrice: unitP ,
  //     );
  //
  //
  // }
}

