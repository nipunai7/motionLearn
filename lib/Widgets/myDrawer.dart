import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/Search.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Orders/myOrders.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Store/userProfile.dart';
import 'package:e_shop/User/profile.dart';
import 'package:e_shop/User/reports.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
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
                  Material(
                    borderRadius: BorderRadius.all(
                      Radius.circular(80.0),
                    ),
                    elevation: 8.0,
                    child: Container(
                      height: 160.0,
                      width: 160.0,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(EcommerceApp
                            .sharedPreferences
                            .getString(EcommerceApp.userAvatarUrl)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  InkWell(
                    onTap: () {
                      Route route =
                          MaterialPageRoute(builder: (c) => Profile());
                      Navigator.pushReplacement(context, route);
                    },
                    child: Text(
                      EcommerceApp.sharedPreferences
                          .getString(EcommerceApp.userName),
                      style: TextStyle(
                          fontFamily: "Signatra",
                          fontSize: 30.0,
                          color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 6.0,
            ),
            Container(
              padding: EdgeInsets.only(top: 1.0),
              decoration: new BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Column(
                children: [
                  Divider(
                    height: 10.0,
                    color: Colors.white,
                    thickness: 6.0,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Home",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Route route =
                          MaterialPageRoute(builder: (c) => StoreHome());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  Divider(
                    height: 10.0,
                    color: Colors.white,
                    thickness: 6.0,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.videocam,
                      color: Colors.white,
                    ),
                    title: Text(
                      "My Tutorials",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Route route =
                          MaterialPageRoute(builder: (c) => MyOrders());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  Divider(
                    height: 10.0,
                    color: Colors.white,
                    thickness: 6.0,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                    title: Text(
                      "My Cart",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Route route =
                          MaterialPageRoute(builder: (c) => CartPage());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  Divider(
                    height: 10.0,
                    color: Colors.white,
                    thickness: 6.0,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Search",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Route route =
                          MaterialPageRoute(builder: (c) => SearchProduct());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  Divider(
                    height: 10.0,
                    color: Colors.white,
                    thickness: 6.0,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Logout",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      EcommerceApp.auth.signOut().then((c) {
                        Route route = MaterialPageRoute(
                            builder: (c) => AuthenticScreen());
                        Navigator.pushReplacement(context, route);
                      });
                    },
                  ),
                  Divider(
                    height: 10.0,
                    color: Colors.white,
                    thickness: 6.0,
                  ),
                  // ListTile(
                  //   leading: Icon(Icons.logout,color: Colors.white,),
                  //   title: Text("Logout",style: TextStyle(color: Colors.white),),
                  //   onTap: (){
                  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=> ReportView()));
                  //   },
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
