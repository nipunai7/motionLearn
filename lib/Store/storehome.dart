import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
      appBar: MyAppBar(),
        drawer: MyDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
                pinned: true,delegate: SearchBoxDelegate()
            ),
            StreamBuilder<QuerySnapshot>(
                stream :Firestore.instance.collection("Items").limit(15).orderBy("publishedDate", descending: true).snapshots(),
                builder: (context, dataSnapshot){
                  return !dataSnapshot.hasData
                      ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                      : SliverStaggeredGrid.countBuilder(
                    crossAxisCount: 1,
                    staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                    itemBuilder: (context,index){
                            ItemModel model = ItemModel.fromJson(dataSnapshot.data.documents[index].data);
                            return sourceInfo(model, context);
                    },
                    itemCount: dataSnapshot.data.documents.length,
                  );
                },
            )
          ],
        )
      ),
    );
  }
}



Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: (){
      Route route = MaterialPageRoute(builder: (c) => ProductPage(itemModel:model));
      Navigator.pushReplacement(context, route);
    },
    splashColor: Colors.purple,
    child: Padding(
      padding: EdgeInsets.all(6.0),
      child: Container(
        height: 160.0,
        width: width,
        child: Row(
          children: [
            Image.network(model.thumbnailUrl,width: 140.0,height: 140.0,),
            SizedBox(width: 4.0,),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.0,),
                  Container(
                    child: Row(
                      mainAxisSize:MainAxisSize.max,
                      children: [
                        Expanded(child: Text(model.title,style: TextStyle(color: Colors.deepPurpleAccent,fontSize: 14.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 0.0,),
                  Container(
                    child: Row(
                      mainAxisSize:MainAxisSize.max,
                      children: [
                        Expanded(child: Text(model.shortInfo,style: TextStyle(color: Colors.black54,fontSize: 12.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.0,),
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
                              Text("50%",style: TextStyle(fontSize: 15.0,color: Colors.white,fontWeight: FontWeight.normal),
                              ),
                              Text("OFF",style: TextStyle(fontSize: 15.0,color: Colors.white,fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: EdgeInsets.only(top: 0.0),
                          child: Row(
                            children: [
                              Text("Original Price: Rs."+ (model.price*2).toString(),style: TextStyle(fontSize: 14.0,color: Colors.grey,decoration: TextDecoration.lineThrough),)
                            ],
                          ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 5.0),
                            child: Row(
                              children: [
                                Text("New Price: Rs."+ model.price.toString(),style: TextStyle(fontSize: 14.0,color: Colors.grey),)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Flexible(child: Container(

                  ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: removeCartFunction == null
                        ? IconButton(
                        icon: Icon(Icons.add_shopping_cart,color: Colors.deepPurple,),
                      onPressed: (){
                          checkItemInCart(model.shortInfo, context);
                      },
                    )
                        : IconButton(
                          icon: Icon(Icons.delete,color: Colors.deepPurple,),
                          onPressed: () {
                            removeCartFunction();
                            Route route = MaterialPageRoute(builder: (c) => StoreHome());
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



void checkItemInCart(String productID, BuildContext context)
{
  EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).contains(productID)
      ? Fluttertoast.showToast(msg: "Item is already in Cart.")
      : addItemtoCart(productID,context);
}

addItemtoCart(String tutoID, BuildContext context){
  List tempList = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
  tempList.add(tutoID);
  
  EcommerceApp.firestore.collection(EcommerceApp.collectionUser).document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
  .updateData({
    EcommerceApp.userCartList: tempList,
  }).then((v){
    Fluttertoast.showToast(msg: "Item Added to the Cart");
    EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, tempList);
    Provider.of<CartItemCounter>(context,listen: false).displayResult();
  });
}
