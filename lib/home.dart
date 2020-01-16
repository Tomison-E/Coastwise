import 'package:flutter/material.dart';
import 'package:leeway/dashboard.dart';
import 'package:leeway/screens/destinationView.dart';
import 'package:leeway/screens/driverTotal.dart';
import 'package:leeway/screens/financesView.dart';
import 'package:leeway/screens/loadingView.dart';
import 'package:leeway/screens/login.dart';
import 'package:leeway/screens/registeration.dart';
import 'package:leeway/screens/trucksTotal.dart';
import 'package:leeway/services/user.dart';
import 'package:leeway/utils/uiData.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';
import 'screens/dispatchView.dart';
import 'package:leeway/screens/ROIView.dart';
//import 'dart:html' as html;

class Home extends StatefulWidget {
  final int index;
  Home({this.index=0});
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<Home> with SingleTickerProviderStateMixin {
  TabController tabController;
  int active = 0;
  String page;
  User user;
  @override
  void initState() {
    super.initState();
    tabController = new TabController(vsync: this, length: 13, initialIndex: widget.index)
      ..addListener(() {
        setState(() {
          active = tabController.index;
        });
      });
    user = Provider.of<UserController>(context, listen: false).user;
    page = "Dashboard";
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.menu, color: Colors.black87),
          title: Text("Coastwise LTD",
              style: TextStyle(fontSize: 22.0, color: Colors.black87)),
          centerTitle: false,
          backgroundColor: Colors.white,
          elevation: 0.5,
          actions: <Widget>[
            SizedBox(
              child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      filled: true,fillColor: Color.fromRGBO(245, 246, 247, 1.0))),
              width: 500.0,
            ),
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
                : SingleChildScrollView(child:Card(
                    child: Container(
                        margin: EdgeInsets.all(0),
                        height: MediaQuery.of(context).size.height+20.0,
                        width: 200,
                        color: Colors.white,
                        child: listDrawerItem(false)))),
            Container(
              width: MediaQuery.of(context).size.width > 1300
                  ? MediaQuery.of(context).size.width - 210
                  : MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(height: 20.0),
                  Text(page,
                      style: TextStyle(color: Colors.black87, fontSize: 20.0,fontWeight: FontWeight.bold)),
                  SizedBox(height: 20.0),
                  SizedBox(
                      height: MediaQuery.of(context).size.height - 125.0,
                      child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: tabController,
                          children: [
                            Dashboard(),
                            DispatchView(),
                            Register(),
                            LoadingView(),
                            Register(),
                            DestinationView(),
                            Register(),
                            FinancesView(),
                            Register(),
                            ROIView(),
                            Register(),
                            DriverTotal(),
                            TrucksTotal()
                          ]))
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              padding: EdgeInsets.only(left: 5.0),
            )
          ],
        ),
        backgroundColor: Colors.white);
  }

  Widget listDrawerItem(bool drawerStatus) {
    return ListView(
      padding: EdgeInsets.all(0),
      children: [
        SizedBox(height: 20.0),
        Image.network(
          "assets/icons/logo.png",
          width: 50.0,
          height: 50.0,
        ),
        SizedBox(height: 10.0),
        ListTile(
          leading: ImageIcon(
            NetworkImage("assets/icons/analysis.png"),
            size: 40.0,
          ),
          title: Text("Dashboard"),
          selected: tabController.index == 0 ? true : false,onTap: ()=>body(UIData.dashboard),
        ),
        SizedBox(height: 10.0),
        PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            onSelected: (route) {
              body(route);
              setState(() {
                page = "TRUCK DISPATCH POINT";
              });
            },
            child: ListTile(
              leading: ImageIcon(
                NetworkImage("assets/icons/icons8-truck-50 copy.png"),
                size: 40.0,
              ),
              title: Text("Dispatch"),
              selected: tabController.index == 1 || tabController.index == 2
                  ? true
                  : false,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                  new PopupMenuItem<String>(
                      value: UIData.dispatchRoute,
                      child: new Text("Dispatch Records")),
                  new PopupMenuItem<String>(
                      value: UIData.addDispatchRoute,
                      child: new Text("Add Dispatch Job")),
                ]),
        SizedBox(height: 10.0),
        PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            onSelected: (route) {
              body(route);
              setState(() {
                page = "TRUCK LOADING POINT";
              });
            },
            child: ListTile(
              leading: ImageIcon(
                NetworkImage("assets/icons/logistics.png"),
                size: 40.0,
              ),
              title: Text("Loading"),
              selected: tabController.index == 3 || tabController.index == 4
                  ? true
                  : false,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                  new PopupMenuItem<String>(
                      value: UIData.loadingRoute,
                      child: new Text("Loading Records")),
                  new PopupMenuItem<String>(
                      value: UIData.addLoadingRoute,
                      child: new Text("Add Loading Job")),
                ]),
        SizedBox(height: 10.0),
        PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            onSelected: (route) {
              body(route);
              setState(() {
                page = "TRUCK DESTINATION POINT";
              });
            },
            child: ListTile(
              leading: ImageIcon(
                NetworkImage("assets/icons/warehouse.png"),
                size: 40.0,
              ),
              title: Text("Destination"),
              selected: tabController.index == 5 || tabController.index == 6
                  ? true
                  : false,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                  new PopupMenuItem<String>(
                      value: UIData.destinationRoute,
                      child: new Text("Destination Records")),
                  new PopupMenuItem<String>(
                      value: UIData.addDestinationRoute,
                      child: new Text("Add Destination Job")),
                ]),
        SizedBox(height: 10.0),
        PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            onSelected: (route) {
              body(route);
              setState(() {
                page = "FINANCES";
              });
            },
            child: ListTile(
              leading: ImageIcon(
                NetworkImage("assets/icons/bank.png"),
                size: 40.0,
              ),
              title: Text("Finances"),
              selected: tabController.index == 7 || tabController.index == 8
                  ? true
                  : false,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                  new PopupMenuItem<String>(
                      value: UIData.financeRoute,
                      child: new Text("Finances Records")),
                  new PopupMenuItem<String>(
                      value: UIData.addFinanceRoute,
                      child: new Text("Add Financial Record")),
                ]),
        SizedBox(height: 10.0),
        PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            onSelected: (route) {
              body(route);
              setState(() {
                page = "ROI";
              });
            },
            child: ListTile(
              leading: ImageIcon(
                NetworkImage("assets/icons/meeting.png"),
                size: 40.0,
              ),
              title: Text("ROI"),
              selected: tabController.index == 9 || tabController.index == 10
                  ? true
                  : false,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                  new PopupMenuItem<String>(
                      value: UIData.ROIRoute, child: new Text("ROI Records")),
                  new PopupMenuItem<String>(
                      value: UIData.addROIRoute,
                      child: new Text("Add ROI Record")),
                ]),
        SizedBox(height: 10.0),
        PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            onSelected: (route) {
              body(route);
              setState(() {
                page = "GENERAL REPORT";
              });
            },
            child: ListTile(
              leading: ImageIcon(
                NetworkImage("assets/icons/dashboard.png"),
                size: 40.0,
              ),
              title: Text("Report"),
              selected: tabController.index == 11 || tabController.index == 12
                  ? true
                  : false,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                  new PopupMenuItem<String>(
                      value: UIData.truckReportRoute,
                      child: new Text("Drivers Report")),
                  new PopupMenuItem<String>(
                      value: UIData.driverReportRoute,
                      child: new Text("Trucks Report")),
                ]),
        SizedBox(height: 10.0),
      ],
    );
  }

  void body(String page) {
    switch (page) {
      case UIData.dashboard:
        tabController.animateTo(0);
        break;
      case UIData.dispatchRoute:
        tabController.animateTo(1);
        break;
      case UIData.addDispatchRoute:
        tabController.animateTo(2);
        break;
      case UIData.loadingRoute:
        tabController.animateTo(3);
        break;
      case UIData.addLoadingRoute:
        tabController.animateTo(4);
        break;
      case UIData.destinationRoute:
        tabController.animateTo(5);
        break;
      case UIData.addDestinationRoute:
        tabController.animateTo(6);
        break;
      case UIData.financeRoute:
        tabController.animateTo(7);
        break;
      case UIData.addFinanceRoute:
        tabController.animateTo(8);
        break;
      case UIData.ROIRoute:
        tabController.animateTo(9);
        break;
      case UIData.addROIRoute:
        tabController.animateTo(10);
        break;
      case UIData.truckReportRoute:
        tabController.animateTo(11);
        break;
      case UIData.driverReportRoute:
        tabController.animateTo(12);
        break;
    }
  }
}
