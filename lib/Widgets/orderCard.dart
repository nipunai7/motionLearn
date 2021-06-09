import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Orders/OrderDetailsPage.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';

int counter = 0;
class OrderCard extends StatelessWidget {
  
  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;
  
  OrderCard({Key key,this.itemCount,this.data,this.orderID}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: () {
        Route route;
        if (counter == 0){
          counter = counter + 1;
          route = MaterialPageRoute(builder: (c) => OrderDetails(orderID: orderID));
        }
        Navigator.pushReplacement(context, route);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        height: itemCount * 150.0,
        child: ListView.builder(
            itemCount: itemCount,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (c,index){
              ItemModel model = ItemModel.fromJson(data[index].data);
              return sourceInfo3(model, context);
          },
        ),
      ),
    );
  }
}



Widget sourceInfo3(ItemModel model, BuildContext context,
    {Color background})
{
  width =  MediaQuery.of(context).size.width;

  return Container(
    color: Colors.white,
    height: 170.0,
    width: width,
    child: Row(
      children: [
        Image.network(model.thumbnailUrl,width: 150.0,),
        SizedBox(width: 10.0,),
        Expanded(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0,),
            Container(
              child: Row(
                mainAxisSize:MainAxisSize.max,
                children: [
                  Expanded(child: Text(model.title,style: TextStyle(color: Colors.deepPurple,fontSize: 20.0),
                  ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 0.0,),
            // Container(
            //   child: Row(
            //     mainAxisSize:MainAxisSize.max,
            //     children: [
            //       Expanded(child: Text(model.shortInfo,style: TextStyle(color: Colors.black54,fontSize: 16.0),
            //       ),
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(height: 24.0,),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 5.0),
                      child: Row(
                        children: [
                          Text("Price: Rs."+ model.price.toString(),style: TextStyle(fontSize: 18.0,color: Colors.deepPurple),)
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
            Divider(
              height: 6.0,
              color: Colors.deepPurple,


            ),
          ],
        ),
        ),
      ],
    ),
  );
}
