import 'package:flutter/material.dart';
import 'package:leeway/db/database.dart';
import 'package:leeway/models/destination.dart';


class DestinationController with ChangeNotifier {
  Destination destination;
  List<Destination> allDestination;


  void add(Destination d) {
    Database.destination.add(d);
    notifyListeners();
  }

  void remove(int d) {
    Database.destination.removeAt(d);
    notifyListeners();
  }

  Destination get(int d){
    destination= Database.destination[d];
    return destination;
  }

  List<Destination> getAll(int begin, {int end}){
    allDestination = Database.destination.sublist(begin,end);
    return allDestination;
  }

}
