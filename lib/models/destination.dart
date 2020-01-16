import 'package:flutter/material.dart';

class Destination{

  final String officer;
  final DateTime timeIn;
  final String wayBill;
  final DateTime timeOut;
  final DateTime date;
  final int ton;
  final int truckNo;
  final int id;
  bool selected = false;

  Destination({this.truckNo,this.officer,this.id,this.timeIn,this.timeOut,this.ton,this.wayBill,this.date});


}