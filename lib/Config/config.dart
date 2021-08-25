import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:shared_preferences/shared_preferences.dart';

class EcommerceApp {
  static const String appName = 'Motion Learn';

  static SharedPreferences sharedPreferences;
  static FirebaseUser user;
  static FirebaseAuth auth;
  static Firestore firestore;

  static String collectionUser = "users";
  static String collectionOrders = "orders";
  static String userCartList = 'userCart';
  static String subCollectionAddress = 'userAddress';
  static String totalSpent = 'totalSpent';

  static final String userName = 'name';
  static final String jdate = 'jdate';
  static final String userEmail = 'email';
  static final String userPhotoUrl = 'photoUrl';
  static final String userUID = 'uid';
  static final String userAvatarUrl = 'url';
  static final String userPackage = 'userpkg';
  static final String items = 'items';
  static final String reviews = 'reviews';
  static final String job = 'job';
  static final String age = 'age';
  static final String pref = 'preference';

  static final String addressID = 'addressID';
  static final String totalAmount = 'totalAmount';
  static final String productID = 'productIDs';
  static final String paymentDetails = 'paymentDetails';
  static final String orderTime = 'orderTime';
  static final String isSuccess = 'isSuccess';
  static final String itemUserin = '';

  static final List tempPurchase = [];
  static final String latestOrder = "";
  static final String adminName = 'adminName';
  static final String bought = 'false';
}
