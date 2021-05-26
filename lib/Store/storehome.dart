import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
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
      appBar: AppBar(
        title: Text("Home Page"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                  onPressed: (){
                    Route route = MaterialPageRoute(builder: (c) => CartPage());
                    Navigator.pushReplacement(context, route);
                  },
                  icon: Icon(Icons.shopping_basket,color: Colors.white,),
              ),
              Positioned(
                  child: Stack(
                    children: [
                      Icon(Icons.brightness_1,
                      size: 20.0,
                      color: Colors.grey,
                      ),
                      // Positioned(
                      //   top: 3.0,
                      //   bottom: 4.0,
                      //   child: Consumer<CartItemCounter>(
                      //     builder: (context,counter, _){
                      //       return Text(
                      //         counter.count.toString(),
                      //       );
                      //     },
                      //   ),
                      // )
                    ],
                  ))
            ],
          )
        ],
      ),
        body: Center(
          child: Text("Registration Success",style: TextStyle(fontSize: 30,fontFamily: "Signatra"),),
        ),
      ),
    );
  }
}



Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell();
}



Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container();
}



void checkItemInCart(String productID, BuildContext context)
{
}
