import 'package:flutter/cupertino.dart';

class TotalAmount extends ChangeNotifier {
  double _totAmount = 0;

  double get total => _totAmount;

  displayResult(double v) async {
    _totAmount = v;

    await Future.delayed(const Duration(microseconds: 100), () {
      notifyListeners();
    });
  }
}
