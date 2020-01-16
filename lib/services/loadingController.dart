import 'package:flutter/material.dart';
import 'package:leeway/db/database.dart';
import 'package:leeway/models/loadingPoint.dart';


class LoadingController with ChangeNotifier {
  LoadingPoint loading;
  List<LoadingPoint> allLoading;


  void add(LoadingPoint d) {
    Database.loading.add(d);
    notifyListeners();
  }

  void remove(int d) {
    Database.loading.removeAt(d);
    notifyListeners();
  }

  LoadingPoint get(int d){
    loading = Database.loading[d];
    return loading;
  }

  List<LoadingPoint> getAll(int begin, {int end}){
    allLoading = Database.loading.sublist(begin,end);
    return allLoading;
  }

}
