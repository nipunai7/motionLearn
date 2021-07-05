import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/orderCard.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print (EcommerceApp.sharedPreferences.getString(EcommerceApp.jdate.toString()));
      },
      child: MaterialApp(
        home: DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              elevation: 10.0,
              centerTitle: true,
              excludeHeaderSemantics: true,
              leadingWidth: 20.0,

              leading: IconButton(
                onPressed: () {
                  Route route = MaterialPageRoute(builder: (c) => StoreHome());
                  Navigator.pushReplacement(context, route);
                },
                icon: Icon(Icons.arrow_back, color: Colors.white,),
              ),
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.person_pin)),
                  Tab(icon: Icon(Icons.document_scanner_rounded)),
                  Tab(icon: Icon(Icons.favorite_outlined)),
                  Tab(icon: Icon(Icons.attach_money_rounded)),
                ],
              ),
              title: Text('User Details: ' +
                  EcommerceApp.sharedPreferences.getString(
                      EcommerceApp.userName)),
              backgroundColor: Colors.deepPurple,
            ),
            body: TabBarView(
              children: [
                Container(
                    child: Column(
                      children: [
                        SizedBox(height: 20.0,),
                        Container(
                          height: 230.0,
                          width: 230.0,
                          child: CircleAvatar(backgroundImage: NetworkImage(EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl)),),
                        ),
                        SizedBox(height: 20.0,),
                        Align(
                          alignment: Alignment.center,
                          child: Text(EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),style: TextStyle(fontSize: 24.0,color: Colors.deepPurple),),
                        ),
                        SizedBox(height: 10.0,),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0,top: 20.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Email: '+EcommerceApp.sharedPreferences.getString(EcommerceApp.userEmail),style: TextStyle(fontSize: 18.0,color: Colors.deepPurple),),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0,top: 10.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Joined on: '+EcommerceApp.sharedPreferences.getString(EcommerceApp.jdate.toString()),style: TextStyle(fontSize: 18.0,color: Colors.deepPurple),),
                          ),
                        ),
                      ],
                    )

                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 70.0,
                        child: Card(
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text("1624873033163_report",style: TextStyle(fontSize: 18.0),
                                ),
                              )
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: EcommerceApp.firestore.collection(EcommerceApp.collectionUser).document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).collection(EcommerceApp.collectionOrders).snapshots(),
                    builder: (c, snapshots){
                      return snapshots.hasData
                          ?ListView.builder(
                        itemCount: snapshots.data.documents.length,
                        itemBuilder: (c, index){
                          return FutureBuilder<QuerySnapshot>(
                            future: Firestore.instance.collection("Items").where("shortInfo",whereIn: snapshots.data.documents[index].data[EcommerceApp.productID]).getDocuments(),
                            builder: (c, snap){
                              return snap.hasData
                                  ?
                              //Center(child: Text("We do have data"))
                              OrderCard(
                                itemCount: snap.data.documents.length,
                                data: snap.data.documents,
                                orderID: snapshots.data.documents[index].documentID,
                              )
                                  :Center(child: circularProgress(),);
                            },
                          );
                        },
                      )
                          :Center(child: circularProgress(),);
                    },
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 70.0,
                        child: Card(
                          child: Align(
                            alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text("1624873033163_order",style: TextStyle(fontSize: 18.0),
                                ),
                              )
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
