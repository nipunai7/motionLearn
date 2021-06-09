import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:e_shop/Models/item.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:video_player/video_player.dart';
import '../Widgets/chewiePlayer.dart';


class ProductPage extends StatefulWidget {
  final ItemModel itemModel;
  ProductPage({this.itemModel});

  @override
  _ProductPageState createState() => _ProductPageState();
}


class _ProductPageState extends State<ProductPage> {
  int numOfItems = 1;



  @override
  Widget build(BuildContext context)
  {
    Firestore.instance.collection("users").where("items", arrayContainsAny: [widget.itemModel.shortInfo]).getDocuments().then((value) => {
      print (value.documents.length),
      if (value.documents.length == 0){
        EcommerceApp.sharedPreferences.setString(EcommerceApp.bought, "false")
      },

      value.documents.forEach((element) {
        if (EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) == element.documentID) {
          print (element.documentID);
          print (EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID));
          EcommerceApp.sharedPreferences.setString(EcommerceApp.bought, "true");
        }
      })
    });

    Size screenSize = MediaQuery.of(context).size;
    return WillPopScope(onWillPop: (){
      Route route = MaterialPageRoute(builder: (c) => StoreHome());
      Navigator.pushReplacement(context, route);
    },

      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Colors.white
          ),
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
          title: Text(widget.itemModel.title,style: TextStyle(color: Colors.white,fontSize: 18.0),),
          leading: IconButton(
              onPressed: (){
                Route route = MaterialPageRoute(builder: (c) => StoreHome());
                Navigator.pushReplacement(context, route);
              },
              icon: Icon(Icons.arrow_back,color: Colors.white,)
          ),
        ),
        drawer: MyDrawer(),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(14.0),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.network(widget.itemModel.thumbnailUrl),
                      ),
                      Container(
                        color: Colors.deepPurpleAccent,
                        child: SizedBox(height: 1.0,width: double.infinity,),
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.itemModel.title,style: boldTextStyle,),
                          SizedBox(height: 10.0,),
                          Text(widget.itemModel.longDescription,),
                          SizedBox(height: 10.0,),
                          Text("Rs."+ widget.itemModel.price.toString(),style: boldTextStyle,),
                          SizedBox(height: 10.0,),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 8.0,bottom: 16.0),
                    child: Center(

                      child:addToCart()
                    ),
                  ),

                  Container(
                    height: 200.0,
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                      children: <Widget>[
                        ChewiListItem(
                          videoPlayerController: VideoPlayerController.network(widget.itemModel.videoUrl,),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }

 Widget addToCart() {

    print (EcommerceApp.sharedPreferences.getString(EcommerceApp.bought));
    return EcommerceApp.sharedPreferences.getString(EcommerceApp.bought) == "true"
        ? Container()
        : InkWell(
      onTap: ()=> checkItemInCart(widget.itemModel.shortInfo, context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple,
        ),
        width: MediaQuery.of(context).size.width - 40.0,
        height: 50.0,
        child: Center(
          child: Text("Add to Cart",style: TextStyle(color: Colors.white,),
          ),
        ),
      ),
    );

  }

}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
