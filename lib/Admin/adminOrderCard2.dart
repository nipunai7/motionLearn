import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/product_admin.dart';
import 'package:e_shop/Models/item.dart';
import 'package:flutter/material.dart';

import '../Store/storehome.dart';

int counter = 0;

class AdminOrderCard2 extends StatelessWidget {
  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;
  final String orderBy;

  AdminOrderCard2(
      {Key key, this.itemCount, this.data, this.orderBy, this.orderID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
          itemBuilder: (c, index) {
            ItemModel model = ItemModel.fromJson(data[index].data);
            return sourceInfo7(model, context);
          },
        ),
      ),
    );
  }

  Widget sourceInfo7(ItemModel model, BuildContext context,
      {Color background}) {
    width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Route route = MaterialPageRoute(
            builder: (c) => ProductAdmin(
                  itemModel: model,
                ));
        Navigator.pushReplacement(context, route);
      },
      child: Container(
        color: Colors.white,
        height: 170.0,
        width: width,
        child: Row(
          children: [
            Image.network(
              model.thumbnailUrl,
              width: 150.0,
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 8.0,
                  ),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            model.title,
                            style: TextStyle(
                                color: Colors.deepPurple, fontSize: 20.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Row(
                              children: [
                                Text(
                                  "Price: Rs." + model.price.toString(),
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.deepPurple),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Flexible(
                    child: Container(),
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
    );
  }
}
