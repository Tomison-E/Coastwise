import 'package:flutter/material.dart';
import 'package:leeway/db/database.dart';
import 'package:leeway/models/dispatch.dart';
import 'package:leeway/models/driver.dart';
import 'package:leeway/models/truck.dart';

class DispatchController with ChangeNotifier {
  Dispatch dispatch;
  List<Driver> driver;
  List<Dispatch> allDispatch;


  void add(Dispatch d) {
    Database.dispatch.add(d);
    notifyListeners();
  }

  void remove(int d) {
    Database.dispatch.removeAt(d);
    notifyListeners();
  }

  Dispatch get(int d){
   dispatch= Database.dispatch[d];
   return dispatch;
  }

  List<Dispatch> getAll(int begin, {int end}){
    allDispatch = Database.dispatch.sublist(begin,end);
    return allDispatch;
  }

  List<Driver> getDrivers(){
    return Database.drivers;
  }

  List<Truck> getTrucks(){
    return Database.trucks;
  }
}
