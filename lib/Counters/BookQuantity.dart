import 'package:flutter/foundation.dart';

class BookQuantity with ChangeNotifier {
  int _numberofItems = 0;

  int get numberofItems => _numberofItems;

  display(int numb) {
    _numberofItems = numb;
    notifyListeners();
  }
}
