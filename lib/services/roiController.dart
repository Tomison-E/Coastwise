import 'package:flutter/material.dart';
import 'package:leeway/db/database.dart';
import 'package:leeway/models/ROI.dart';
import 'package:leeway/models/loadingPoint.dart';


class ROIController with ChangeNotifier {
  ROI roi;
  List<ROI> allReturns;


  void add(ROI d) {
    Database.returns.add(d);
    notifyListeners();
  }

  void remove(int d) {
    Database.returns.removeAt(d);
    notifyListeners();
  }

  ROI get(int d){
    roi = Database.returns[d];
    return roi;
  }

  List<ROI> getAll(int begin, {int end}){
    allReturns = Database.returns.sublist(begin,end);
    return allReturns;
  }

}
