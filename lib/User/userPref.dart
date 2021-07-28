import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/User/user.dart';

class UserPref{
  static final myUser = User (
    age: '24',
    interests: 'Ballet, Hiphop, Break Dance',
    occupation: 'Undergraduate',
    totpurtutes: '12',
    totReports: getData().toString(),
    totSpent: '1800.00',
    mostPlayed: 'Break Dance',
    isDarkMode: false
  );
}
Future<int> getData() async{
  int count = 0;
  await Firestore.instance.collection("users").document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).collection("Reports").getDocuments().then((value) => {
    value.documents.forEach((element) {
      count += int.parse(element.data['attempts']);
    })
  });
  print(count);
  return count;
}