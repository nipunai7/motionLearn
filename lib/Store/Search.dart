import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Widgets/customAppBar.dart';

class SearchService {
}

class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => new _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {

  Future<QuerySnapshot> itemList;

    @override
    Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // ignore: missing_return
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      },
      child: Scaffold(
        appBar: MyAppBar(bottom: PreferredSize(child: searchWidget(),preferredSize: Size(56.0,56.0)),),
        drawer: MyDrawer(),
        body: FutureBuilder<QuerySnapshot>(
          future: itemList,
          builder: (context, snap){
            return snap.hasData
                ? ListView.builder(
                itemBuilder: (context, index){
                  ItemModel model = ItemModel.fromJson(snap.data.documents[index].data);
                  return sourceInfo(model, context);
                },
                itemCount: snap.data.documents.length,
            )
                : Text("No product available");
          },
        ),

      ),

    );
  }
   Widget searchWidget(){
      return Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: 80.0,
        color: Colors.deepPurple,
        child: Container(
          width: MediaQuery.of(context).size.width-40.0,
          height: 50.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Row(
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 8.0),
                child: Icon(Icons.search,color: Colors.deepPurple,),
              ),
              Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: TextField(
                      onChanged: (value){
                        startSearch(value);
                      },
                      decoration: InputDecoration.collapsed(hintText: "Search"),
                    ),
                  )
              )
              
            ],
          ),

        ),
      );
    }
   Future startSearch(String query) async{
      //itemList = Firestore.instance.collection("Items").where("shortInfo", isGreaterThanOrEqualTo: query).getDocuments();
     itemList = Firestore.instance.collection("Items").orderBy("shortInfo").startAt([query]).getDocuments();
   }

  }
