import 'package:e_shop/Config/config.dart';
import 'package:e_shop/User/user.dart';

class UserPref{
  static final myUser = User(
    imagePath: EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl),
    name: EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
    email: EcommerceApp.sharedPreferences.getString(EcommerceApp.userEmail),
    about: EcommerceApp.sharedPreferences.getString(EcommerceApp.jdate),
    age: '24',
    interests: 'Ballet, Hiphop, Break Dance',
    occupation: 'Undergraduate',
    totpurtutes: '12',
    totReports: '4',
    totSpent: '1800.00',
    mostPlayed: 'Break Dance',
    isDarkMode: false
  );
}