import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Admin/product_admin_edit.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Widgets/myDrawer2.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:video_player/video_player.dart';
import '../Widgets/chewiePlayer.dart';


class ProductAdmin extends StatefulWidget {
  final ItemModel itemModel;
  ProductAdmin({this.itemModel});

  @override
  _ProductAdminState createState() => _ProductAdminState();
}


class _ProductAdminState extends State<ProductAdmin> {
  int numOfItems = 1;

  @override
  Widget build(BuildContext context)
  {
    Size screenSize = MediaQuery.of(context).size;
    return WillPopScope(onWillPop: (){
      Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
      Navigator.pushReplacement(context, route);
    },

      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Colors.white
          ),
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
          title: Text("Manage Tutorial",style: TextStyle(color: Colors.white,fontSize: 18.0),),
          leading: IconButton(
              onPressed: (){
                Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
                Navigator.pushReplacement(context, route);
              },
              icon: Icon(Icons.arrow_back,color: Colors.white,)
          ),
          actions: [
            TextButton(
              child: Icon(Icons.delete_forever,color: Colors.white,),
              onPressed: () {
               deleteTuto();
              },
            ),
          ],
        ),
        drawer: MyDrawer2(),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                  padding: EdgeInsets.only(top: 8.0,bottom: 16.0),
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        Route route = MaterialPageRoute(builder: (c) => ProductEdit(itemModel: widget.itemModel,));
                                        Navigator.pushReplacement(context, route);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurple,
                                        ),
                                        width: 150,
                                        height: 50.0,
                                        child: Center(
                                          child: Text("Edit Tutorial",style: TextStyle(color: Colors.white,),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                              )
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                  padding: EdgeInsets.only(top: 8.0,bottom: 16.0),
                                  child: Center(
                                    child: InkWell(
                                      onTap: ()=> deleteTuto(),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurple,
                                        ),
                                        width: 150,
                                        height: 50.0,
                                        child: Center(
                                          child: Text("Delete Tutorial",style: TextStyle(color: Colors.white,),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                              )
                          ),
                        ],
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

  deleteTuto(){
    Firestore.instance.collection("Items").where("tutorial", isEqualTo: widget.itemModel.videoUrl).getDocuments().then((value) => {
      value.documents.forEach((element) {
        Firestore.instance.collection("Items").document(element.documentID).delete();
      })
    });

    Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
    Navigator.pushReplacement(context, route);
  }

}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
