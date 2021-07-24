import 'package:e_shop/Store/storehome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAppBar2 extends StatelessWidget with PreferredSizeWidget
{
  final PreferredSizeWidget bottom;
  final String name;
  MyAppBar2({this.bottom,this.name});
  //String name = "Motion Learn";

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.white
      ),
      backgroundColor: Colors.deepPurple,
      centerTitle: true,
      title: Text(this.name,style: TextStyle(fontSize: 18.0,color: Colors.white),
      ),
      bottom: bottom,
      leading: IconButton(
        onPressed: (){
          Route route = MaterialPageRoute(builder: (c) => StoreHome());
          Navigator.pushReplacement(context, route);
        },
        icon: Icon(Icons.arrow_back,color: Colors.white,),
      )
    );
  }


  Size get preferredSize => bottom==null?Size(56,AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);
}
