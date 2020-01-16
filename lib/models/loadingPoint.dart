

class LoadingPoint{

  final DateTime date;
  final DateTime timeIn;
  final DateTime timeOut;
  final String officer;
  final String terminal;
  final String businessType;
  final String driver;
  final int truckNo;
  final String product;
  final int ton;
  final String destination;
  final String wayBill;
  final int id;
  bool selected = false;


  LoadingPoint({this.wayBill,this.id,this.timeOut,this.timeIn,this.officer,this.truckNo,this.driver,this.date,this.businessType,this.destination,this.product,this.terminal,this.ton});



}