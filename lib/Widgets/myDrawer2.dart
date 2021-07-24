import 'package:e_shop/Admin/adminuploads.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'package:flutter/material.dart';

class MyDrawer2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.deepPurple,
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
            decoration: new BoxDecoration(
              color: Colors.deepPurple,
            ),
              child: Column(
                children: [
                  
                  SizedBox(height: 10.0,),
                  Text(
                    EcommerceApp.sharedPreferences.getString(EcommerceApp.adminName),style: TextStyle(fontFamily: "Signatra",fontSize: 30.0,color: Colors.white),
                  )
                ],
              ),
          ),
          SizedBox(height: 6.0,),
          Container(
            padding: EdgeInsets.only(top: 1.0),
            decoration: new BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Column(
              children: [
                Divider(height: 10.0,color: Colors.white,thickness: 6.0,),
                ListTile(
                  leading: Icon(Icons.person,color: Colors.white,),
                  title: Text("Customer Area",style: TextStyle(color: Colors.white),),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(height: 10.0,color: Colors.white,thickness: 6.0,),
                ListTile(
                  leading: Icon(Icons.videocam,color: Colors.white,),
                  title: Text("Manage Tutorials",style: TextStyle(color: Colors.white),),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c) => AdminUploads());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                // Divider(height: 10.0,color: Colors.white,thickness: 6.0,),
                // ListTile(
                //   leading: Icon(Icons.shopping_cart,color: Colors.white,),
                //   title: Text("My Cart",style: TextStyle(color: Colors.white),),
                //   onTap: (){
                //     Route route = MaterialPageRoute(builder: (c) => CartPage());
                //     Navigator.pushReplacement(context, route);
                //   },
                // ),
                // Divider(height: 10.0,color: Colors.white,thickness: 6.0,),
                // ListTile(
                //   leading: Icon(Icons.search,color: Colors.white,),
                //   title: Text("Search",style: TextStyle(color: Colors.white),),
                //   onTap: (){
                //     Route route = MaterialPageRoute(builder: (c) => SearchProduct());
                //     Navigator.pushReplacement(context, route);
                //   },
                // ),
                Divider(height: 10.0,color: Colors.white,thickness: 6.0,),
                ListTile(
                  leading: Icon(Icons.logout,color: Colors.white,),
                  title: Text("Logout",style: TextStyle(color: Colors.white),),
                  onTap: (){
                    EcommerceApp.auth.signOut().then((c){
                      Route route = MaterialPageRoute(builder: (c) => AuthenticScreen());
                      Navigator.pushReplacement(context, route);
                    });
                  },
                ),
                Divider(height: 10.0,color: Colors.white,thickness: 6.0,),
              ],
            ),
          ),

        ],
      ),
      ),
    );
  }
}
