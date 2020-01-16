import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:leeway/models/chart.dart';
import 'package:leeway/screens/barChart.dart';
import 'package:leeway/screens/pieChart.dart';
import 'package:leeway/services/reportController.dart';
import 'package:leeway/utils/uiData.dart';
import 'package:provider/provider.dart';

class TrucksReport extends StatelessWidget{
    static  final currency = new  NumberFormat('#,##0.00','en_NG');
    static  List<Bar> barChart;
    static List<Chart> pieChart;



   static List<charts.Series<Bar, String>> _createSampleBarData() {
     final data = barChart;

     return [
       new charts.Series<Bar, String>(
           id: 'Sales',
           domainFn: (Bar sales, _) => sales.variable,
           measureFn: (Bar sales, _) => sales.value,
           data: data,
           // Set a label accessor to control the text of the bar label.
           labelAccessorFn: (Bar sales, _) =>
           '₦ ${currency.format(sales.value)}')
     ];
   }

    static List<charts.Series<Chart, int>> _createSampleData() {
      final data = pieChart;

      return [
        new charts.Series<Chart, int>(
          id: 'Sales',
          domainFn: (Chart sales, _) => sales.variable,
          measureFn: (Chart sales, _) => sales.value,
          data: data,
          // Set a label accessor to control the text of the arc label.
          labelAccessorFn: (Chart row, _) => '${row.variable}: ${row.value}',
        )
      ];
    }


   @override
   Widget build(BuildContext context) {
    var chart = Provider.of<ReportController>(context, listen: false);
     barChart = chart.bar;
     pieChart = chart.chart;
      List<charts.Series>  seriesList = _createSampleBarData();
      List<charts.Series> seriesPieList = _createSampleData();

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
     child:ListView(
        children:  [
          SizedBox(
            child:Card(
                child: Column(
                  children: <Widget>[
                    Text("Total Revenue Per Truck",style: TextStyle(color: Colors.black,fontSize: 30.0),),
                    SizedBox(height: 30.0),
                    Expanded(child:(PieCharts(seriesList: seriesPieList,animate: false))),
                  ],mainAxisSize: MainAxisSize.min,
                ) ,  margin: EdgeInsets.all(20.0)
            ),
            height: 500.0,
          ),
          SizedBox(height: 50.0),
          SizedBox(
              child:Card(
                child: Column(
                  children: <Widget>[
                    Text("Total Revenue Per Truck",style: TextStyle(color: Colors.black,fontSize: 30.0),),
                    SizedBox(height: 30.0),
     Expanded(child:( VerticalBarLabelChart(seriesList: seriesList,animate: false)))
                  ]
                ) , margin: EdgeInsets.all(20.0)
            ), height: 500.0)
            ]
        ),
        )]),backgroundColor: Colors.white,
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