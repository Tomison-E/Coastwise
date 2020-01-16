import 'package:flutter/material.dart';
import 'package:leeway/db/database.dart';
import 'package:leeway/models/financials.dart';



class FinanceController with ChangeNotifier {
  Financial finance;
  List<Financial> finances;


  void add(Financial d) {
    Database.finances.add(d);
    notifyListeners();
  }

  void remove(int d) {
    Database.finances.removeAt(d);
    notifyListeners();
  }

  Financial get(int d){
    finance = Database.finances[d];
    return finance;
  }

  List<Financial> getAll(int begin, {int end}){
    finances = Database.finances.sublist(begin,end);
    return finances;
  }

}
