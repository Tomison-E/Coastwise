import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:leeway/screens/barChart.dart';
import 'package:leeway/screens/pieChart.dart';
import 'package:leeway/services/reportController.dart';
import 'package:leeway/utils/uiData.dart';
import 'package:leeway/widgets/calendar.dart';
import 'package:provider/provider.dart';

import 'models/chart.dart';


class Dashboard extends StatelessWidget {
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
    chart.charts(chart.getTrucks(), DateTime(2019,1), DateTime.now());
    barChart = chart.bar;
    pieChart = chart.chart;
    List<charts.Series>  seriesList = _createSampleTableData();
    List<charts.Series> seriesPieList = _createSampleData();
    return Scaffold(
        body: SingleChildScrollView(
        child:Column(
          children:[Row(
            children:[
              Flexible(child: SizedBox(child:Card(child:
                  Padding(child:Column(
            children: <Widget>[
            Text("Revenue", style: TextStyle(color:Colors.black87,fontSize: 20.0,fontWeight: FontWeight.bold)),
                    Expanded(child:charts.OrdinalComboChart(seriesList,
                        animate: false,
                        // Configure the default renderer as a bar renderer.
                        defaultRenderer: new charts.BarRendererConfig(
                            groupingType: charts.BarGroupingType.grouped),
                        // Custom renderer configuration for the line series. This will be used for
                        // any series that does not define a rendererIdKey.
                        customSeriesRenderers: [
                          new charts.LineRendererConfig(
                            // ID used to link series to this renderer.
                              customRendererId: 'customLine')
                        ]))
          ],crossAxisAlignment: CrossAxisAlignment.start,
        ),padding: EdgeInsets.only(left:10.0),)),height: 300.0,),flex: 6),
              Flexible(child: SizedBox(child:Card(child:
              Padding(child:Column(
    children:[
      Text("Tons", style: TextStyle(color:Colors.black87,fontSize: 20.0,fontWeight: FontWeight.bold)),
              Expanded(child:PieCharts(seriesList: seriesPieList,animate: false))
                ],crossAxisAlignment: CrossAxisAlignment.start),padding: EdgeInsets.only(left:10.0),)),height: 300.0,),flex: 4),
            ]
          ),
            SizedBox(height: 35.0),
            Row(children: <Widget>[
              SizedBox(child:GestureDetector(child:Card(child:  Padding(child:Row(children: <Widget>[
                Flexible(child: Column(children: <Widget>[
                  Text("1,100",style: TextStyle(color: Colors.black87,fontSize: 20.0,fontWeight: FontWeight.bold)),
                  Text("Trucks",style: TextStyle(color: Colors.black54,fontSize: 15.0,fontWeight: FontWeight.normal))
                ],mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,),flex: 6,),
                Flexible(child: Image.network("assets/icons/icons8-truck-50.png",width: 70.0,),flex: 4)
              ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),padding: EdgeInsets.only(left: 35.0,right: 35.0))),
                onTap: ()=>Navigator.of(context).pushNamed(UIData.truckChartsRoute)),height: 150.0,width: 300.0),
              SizedBox(child:Card(child:
              Padding(child:Row(children: <Widget>[
                Flexible(child: Column(children: <Widget>[
                  Text("200",style: TextStyle(color: Colors.black87,fontSize: 20.0,fontWeight: FontWeight.bold)),
                  Text("Drivers",style: TextStyle(color: Colors.black54,fontSize: 15.0,fontWeight: FontWeight.normal))
                ],mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,),flex: 6,),
                Flexible(child: Image.network("assets/icons/icons8-driver-50-3.png",width: 70.0,),flex: 4)
              ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),padding: EdgeInsets.only(left: 35.0,right: 35.0),)),height: 150.0,width: 300.0),
              SizedBox(child:Card(child:  Padding(child:Row(children: <Widget>[
                Flexible(child: Column(children: <Widget>[
                  Text("5",style: TextStyle(color: Colors.black87,fontSize: 20.0,fontWeight: FontWeight.bold)),
                  Text("Stakeholders",style: TextStyle(color: Colors.black54,fontSize: 15.0,fontWeight: FontWeight.normal))
                ],mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,),flex: 6,),
                Flexible(child: Image.network("assets/icons/icons8-meeting-50.png",width: 70.0,),flex: 4)
              ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),padding: EdgeInsets.only(left: 35.0,right: 35.0),)),height: 150.0,width: 300.0),
              SizedBox(child:Card(child:  Padding(child:Row(children: <Widget>[
                Flexible(child: Column(children: <Widget>[
                  Text("2,700",style: TextStyle(color: Colors.black87,fontSize: 20.0,fontWeight: FontWeight.bold)),
                  Text("Clients",style: TextStyle(color: Colors.black54,fontSize: 15.0,fontWeight: FontWeight.normal))
                ],mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,),flex: 6,),
                Flexible(child: Image.network("assets/icons/icons8-business-building-50-2.png",width: 70.0,),flex: 4)
              ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),padding: EdgeInsets.only(left: 35.0,right: 35.0),)),height: 150.0,width: 300.0),
            ],mainAxisAlignment: MainAxisAlignment.spaceEvenly),
            SizedBox(height: 35.0),
            Row(children: <Widget>[
              SizedBox(child:Card(child:
              ListView(
                children: <Widget>[
                  ListTile(
                    title:Text("Recent Activity", style: TextStyle(color:Colors.black87,fontSize: 20.0,fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    leading: Icon(Icons.radio_button_checked,size: 20),
                    title:Text("Delivery Information", style: TextStyle(color:Colors.black87,fontSize: 15.0,fontWeight: FontWeight.bold)),
                    subtitle: Text("09:25 March 04, 2019",style: TextStyle(color:Colors.black87,fontSize: 12.0,fontWeight: FontWeight.normal)),
                  ),
                  ListTile(
                    leading:Icon(Icons.radio_button_checked,size: 20),
                    title:Text("Tomi Logs In", style: TextStyle(color:Colors.black87,fontSize: 15.0,fontWeight: FontWeight.bold)),
                    subtitle: Text("09:25 March 04, 2019",style: TextStyle(color:Colors.black87,fontSize: 12.0,fontWeight: FontWeight.normal)),
                  ),
                  ListTile(
                    leading:Icon(Icons.radio_button_checked,size: 20),
                    title:Text("Tomi registers Truck 115 for dispatch ", style: TextStyle(color:Colors.black87,fontSize: 15.0,fontWeight: FontWeight.bold)),
                    subtitle: Text("09:25 March 04, 2019",style: TextStyle(color:Colors.black87,fontSize: 12.0,fontWeight: FontWeight.normal)),
                  ),
                  ListTile(
                    leading:Icon(Icons.radio_button_checked,size: 20),
                    title:Text("Tomi Logs Out", style: TextStyle(color:Colors.black87,fontSize: 15.0,fontWeight: FontWeight.bold)),
                    subtitle: Text("09:25 March 04, 2019",style: TextStyle(color:Colors.black87,fontSize: 12.0,fontWeight: FontWeight.normal)),
                  ),
                  ListTile(
                    leading:Icon(Icons.radio_button_checked,size: 20),
                    title:Text("Lanre confirms Truck 115 completed Job ", style: TextStyle(color:Colors.black87,fontSize: 15.0,fontWeight: FontWeight.bold)),
                    subtitle: Text("09:25 March 04, 2019",style: TextStyle(color:Colors.black87,fontSize: 12.0,fontWeight: FontWeight.normal)),
                  )
                ],
              )
              ),width: 400.0,height: 600.0,),
              SizedBox(child:Card(child: Column(
    children:[

      ListTile(
        title:Text("Active Trucks In Nigeria", style: TextStyle(color:Colors.black87,fontSize: 20.0,fontWeight: FontWeight.bold)),
        subtitle: Text("200 Active now",style: TextStyle(color:Colors.black87,fontSize: 15.0,fontWeight: FontWeight.normal)),
      ),
      Expanded(child:
      Image.network("assets/map.png",fit: BoxFit.cover,width: 400.0,height: 600.0,
      ))])),width: 400.0,height: 600.0,),
              SizedBox(child:Card(child:Calendar()),width: 400.0,height: 600.0,),
            ],mainAxisAlignment: MainAxisAlignment.spaceEvenly),
            ]
        ),scrollDirection: Axis.vertical,
        ),backgroundColor:Colors.white//Color.fromRGBO(245, 246, 247, 1.0),
        );
  }

  static List<charts.Series<OrdinalSales, String>> _createSampleTableData() {
    final desktopSalesData = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    final tableSalesData = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    final mobileSalesData = [
      new OrdinalSales('2014', 10),
      new OrdinalSales('2015', 50),
      new OrdinalSales('2016', 200),
      new OrdinalSales('2017', 150),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
          id: 'Desktop',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.sales,
          data: desktopSalesData),
      new charts.Series<OrdinalSales, String>(
          id: 'Tablet',
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.sales,
          data: tableSalesData),
      new charts.Series<OrdinalSales, String>(
          id: 'Mobile ',
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.sales,
          data: mobileSalesData)
      // Configure our custom line renderer for this series.
        ..setAttribute(charts.rendererIdKey, 'customLine'),
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}



//https://www.google.com/maps/search/coastwise+limited/@6.4446108,3.367033,17z