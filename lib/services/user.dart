import 'package:flutter/material.dart';
import 'package:leeway/db/database.dart';
import 'package:leeway/models/user.dart';

class UserController with ChangeNotifier {
  User user;


  //static Database db = new Database();

  void add(User user) {
    this.user = user;
    notifyListeners();
  }

  void remove(int d) {
    user=null;
    notifyListeners();
  }

  User get(int d){
    return user;
  }

  bool validateUser(String username, String password){
  user=  Database.users.firstWhere((user)=>user.password==password&&user.username.toLowerCase()==username.toLowerCase(),orElse: ()=>User(username: "tomisin"));
  return user!=null? true:false;
  }
}
