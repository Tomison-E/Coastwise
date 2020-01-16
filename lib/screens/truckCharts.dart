import 'package:flutter/material.dart';
import 'package:leeway/models/chart.dart';
import 'package:leeway/screens/lineChart.dart';
import 'package:leeway/services/reportController.dart';
import 'package:leeway/utils/uiData.dart';
import 'package:provider/provider.dart';

class TrucksChart extends StatelessWidget{
  static List<List<Chart>> profits;


  @override
  Widget build(BuildContext context) {
    profits =   Provider.of<ReportController>(context,listen: false).getTruckProfits();
    return Scaffold(
      appBar: AppBar(
        leading:
        Icon(Icons.menu,color: Colors.black87),
        title: Text("Coastwise LTD",style: TextStyle(fontSize: 22.0,color: Colors.black87)),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: <Widget>[
          SizedBox(child:TextField(decoration: InputDecoration(prefixIcon: Icon(Icons.search),suffixIcon: Icon(Icons.arrow_drop_down),filled: true,fillColor: Color.fromRGBO(245, 246, 247, 1.0))),width: 500.0,),
          SizedBox(width: 150.0),
          Image.network("assets/icons/icons8-notification-50 copy.png",width: 30.0),
          SizedBox(width: 10.0),
          Image.network("assets/icons/icons8-ask-question-50.png",width: 30.0),
          SizedBox(width: 10.0),
          Image.network("assets/icons/icons8-settings-50-2 copy.png",width: 30.0),
          SizedBox(width: 40.0)
        ],
      ),
        body: Row(
        children: <Widget>[
    MediaQuery.of(context).size.width < 1300
    ? Container()
        :Container(
    margin: EdgeInsets.all(0),
    height: MediaQuery.of(context).size.height+20.0,
    width: 50,
    color: Colors.white,
    child: listDrawerItem(false,context)),
    Container(
    width:  MediaQuery.of(context).size.width > 1300
    ? MediaQuery.of(context).size.width-60:MediaQuery.of(context).size.width,
    child:Column(
            children:[
            SizedBox(height: 20.0),
        Padding(child:Text("Trucks Revenue Chart",style: TextStyle(color: Colors.black87,fontSize: 20.0)),padding: EdgeInsets.only(left:20.0),),
        SizedBox(height: 20.0),
       Expanded(child: GridView.count(crossAxisCount: 2,childAspectRatio: 0.9,
          children: profits.map((f)=>
           Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child:Column(
                children:  [
                  SizedBox(height: 10.0),
                Text("Total Revenue for Truck A ",style: TextStyle(color: Colors.black,fontSize: 30.0),),
              SizedBox(height: 20.0),
              SizedBox(
              child:PointsLineChart(f),height: 500.0)]),margin: EdgeInsets.all(20.0),)).toList(),shrinkWrap: true,
        ))],crossAxisAlignment: CrossAxisAlignment.start))
      ]),
      backgroundColor: Colors.white,
    );
  }


  Widget listDrawerItem(bool drawerStatus,BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(0),
      children: [
        SizedBox(height: 20.0),
        GestureDetector(child:ImageIcon(NetworkImage("assets/icons/analysis.png"),size: 40.0,),onTap: ()=> Navigator.of(context)
            .pushNamedAndRemoveUntil(UIData.homeRoute, (Route<dynamic> route) => false,arguments: 0),),
        SizedBox(height: 20.0),
        ImageIcon(NetworkImage("assets/icons/icons8-truck-50 copy.png"),size: 40.0,),
        SizedBox(height: 30.0),
        ImageIcon(NetworkImage("assets/icons/logistics.png"),size: 40.0,),
        SizedBox(height: 30.0),
        ImageIcon(NetworkImage("assets/icons/warehouse.png"),size: 40.0,),
        SizedBox(height: 30.0),
        ImageIcon(NetworkImage("assets/icons/bank.png"),size: 40.0,),
        SizedBox(height: 30.0),
        ImageIcon(NetworkImage("assets/icons/meeting.png"),size: 40.0,),
        SizedBox(height: 30.0),
        ImageIcon(NetworkImage("assets/icons/dashboard.png"),size: 40.0,),
        SizedBox(height: 10.0),
      ],
    );

  }


}