import 'package:flutter/material.dart';
import 'package:leeway/screens/destinationView.dart';
import 'package:leeway/screens/financesView.dart';
import 'package:leeway/screens/loadingView.dart';
import 'package:leeway/screens/login.dart';
import 'package:leeway/screens/registeration.dart';
import 'package:leeway/screens/truckCharts.dart';
import 'package:leeway/screens/trucksTotal.dart';
import 'package:leeway/services/user.dart';
import 'package:leeway/utils/uiData.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';
import 'screens/dispatchView.dart';
import 'package:leeway/screens/ROIView.dart';
import 'dart:html' as html;

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  int active = 0;
  String page;
  User user;
  @override
  void initState() {
    super.initState();
    tabController = new TabController(vsync: this, length: 12, initialIndex: 0)
      ..addListener(() {
        setState(() {
          active = tabController.index;
        });
      });
    user= Provider.of<UserController>(context,listen:false).user;
    page = "TRUCKS DISPATCH POINT";
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return user!=null? Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:true,
           // MediaQuery.of(context).size.width < 1300 ? true : false,
        title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 32),
                child: Text(
                  " $page",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'HelveticaNeue',
                  ),
                ),
              ),
            ]),
        actions: <Widget>[
          InkWell(
            onTap: () {
              print("download");
            },
            child: Container(
              margin: EdgeInsets.all(12),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    Icons.cloud_download,
                    color: Colors.black,
                    size: 22,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    "Download Now",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontFamily: 'HelveticaNeue',
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 32),
          Container(child: IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(Icons.mail),
            onPressed: () {
              html.window.open("google.com", "mail");
            },
          ),),
          SizedBox(width: 32),
          Container(child: Icon(Icons.account_circle)),
          SizedBox(width: 32),
          Container(
            child: IconButton(
              padding: EdgeInsets.all(0),
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                Provider.of<UserController>(context,listen:false).user=null;
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(width: 32),
        ],
        //backgroundColor: Colors.teal,
        // automaticallyImplyLeading: false,
      ),
      body: Row(
        children: <Widget>[
          MediaQuery.of(context).size.width < 1300
              ? Container()
              : Card(
                  elevation: 2.0,
                  child: Container(
                      margin: EdgeInsets.all(0),
                      height: MediaQuery.of(context).size.height,
                      width: 300,
                      color: Colors.white,
                      child: listDrawerItem(false)),
                ),
          Container(
           width:  MediaQuery.of(context).size.width > 1300
               ? MediaQuery.of(context).size.width-310:MediaQuery.of(context).size.width,
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: tabController,
              children: [
                Card(
                    child:DispatchView(),margin: EdgeInsets.all(15.0)),
                Card(child:Register(),margin: EdgeInsets.all(15.0)),
                Card(child:LoadingView(),margin: EdgeInsets.all(15.0)),
                Card(child:Register(),margin: EdgeInsets.all(15.0)),
                Card(child:DestinationView(),margin: EdgeInsets.all(15.0)),
                Card(child:Register(),margin: EdgeInsets.all(15.0)),
                Card(child:FinancesView(),margin: EdgeInsets.all(15.0)),
                Card(child:Register(),margin: EdgeInsets.all(15.0)),
                Card(child:ROIView(),margin: EdgeInsets.all(15.0)),
                Card(child:Register(),margin: EdgeInsets.all(15.0)),
                Card(
                    child:TrucksChart(),margin: EdgeInsets.all(15.0)),
                Card(child:TrucksTotal(),margin: EdgeInsets.all(15.0)),
              ],
            ),
          )
        ],
      ),
      drawer: Padding(
          padding: EdgeInsets.only(top: 56),
          child: Drawer(child: listDrawerItem(true)))):Navigator.of(context).push(
        MaterialPageRoute(builder: (context)=>LoginPage()));
  }

  Widget listDrawerItems(bool drawerStatus) {
    return ListView(
      children: <Widget>[
        FlatButton(
          color: tabController.index == 0 ? Colors.grey[100] : Colors.white,
          //color: Colors.grey[100],
          onPressed: () {
            tabController.animateTo(0);
            drawerStatus ? Navigator.pop(context) : print("");
          },

          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(top: 22, bottom: 22, right: 22),
              child: Row(children: [
                Icon(Icons.dashboard),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Dashboard",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'HelveticaNeue',
                  ),
                ),
              ]),
            ),
          ),
        ),
        FlatButton(
          color: tabController.index == 1 ? Colors.grey[100] : Colors.white,
          onPressed: () {
            print(tabController.index);
            tabController.animateTo(1);
            drawerStatus ? Navigator.pop(context) : print("");
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(top: 22, bottom: 22, right: 22),
              child: Row(children: [
                Icon(Icons.exit_to_app),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Forms",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'HelveticaNeue',
                  ),
                ),
              ]),
            ),
          ),
        ),
        FlatButton(
          color: tabController.index == 2 ? Colors.grey[100] : Colors.white,
          onPressed: () {
            tabController.animateTo(2);
            drawerStatus ? Navigator.pop(context) : print("");
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(top: 22, bottom: 22, right: 22),
              child: Row(children: [
                Icon(Icons.category),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Hero",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'HelveticaNeue',
                  ),
                ),
              ]),
            ),
          ),
        ),
      ],
    );
  }
  Widget listDrawerItem(bool drawerStatus) {
   return ListView(
      padding: EdgeInsets.all(0),
      children: [
        UserAccountsDrawerHeader(
          accountEmail: Text(user.email),
          accountName: Text(user.username),
          currentAccountPicture: CircleAvatar(
            child: Image.network(
              "assets/${user.username.toLowerCase()}.png",
              fit: BoxFit.cover,
            )
          ),
        ),
         PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            onSelected: (route){
             body(route);
             setState(() {
               page = "TRUCKS DISPATCH POINT";
             });
            },
            child:  ListTile(
              leading: Icon(Icons.home),
              title: Text("Dispatch"),
              selected: tabController.index == 0 || tabController.index == 1 ? true : false,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              new PopupMenuItem<String>(
                  value: UIData.dispatchRoute,
                  child: new Text("Dispatch Records")
              ),
              new PopupMenuItem<String>(
                  value: UIData.addDispatchRoute,
                  child: new Text("Add Dispatch Job")
              ),
            ]
        ),
        PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            onSelected: (route){
              body(route);
              setState(() {
                page = "TRUCKS LOADING POINT";
              });
            },
            child:   ListTile(
              leading: Icon(Icons.dashboard),
              title: Text("Loading"),
              selected: tabController.index == 2 || tabController.index == 3 ? true : false,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              new PopupMenuItem<String>(
                  value: UIData.loadingRoute,
                  child: new Text("Loading Records")
              ),
              new PopupMenuItem<String>(
                  value: UIData.addLoadingRoute,
                  child: new Text("Add Loading Job")
              ),
            ]
        ),
        PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            onSelected: (route){
              body(route);
              setState(() {
                page = "TRUCKS DESTINATION POINT";
              });
            },
            child:   ListTile(
              leading: Icon(Icons.add_to_photos),
              title: Text("Destination"),
              selected: tabController.index == 4 || tabController.index == 5 ? true : false,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              new PopupMenuItem<String>(
                  value: UIData.destinationRoute,
                  child: new Text("Destination Records")
              ),
              new PopupMenuItem<String>(
                  value: UIData.addDestinationRoute,
                  child: new Text("Add Destination Job")
              ),
            ]
        ),
        PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            onSelected: (route){
              body(route);
              setState(() {
                page = "FINANCES";
              });
            },
            child:
            ListTile(
              leading: Icon(Icons.account_balance),
              title: Text("Finances"),
              selected: tabController.index == 6 || tabController.index == 7 ? true : false,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              new PopupMenuItem<String>(
                  value: UIData.financeRoute,
                  child: new Text("Finances Records")
              ),
              new PopupMenuItem<String>(
                  value: UIData.addFinanceRoute,
                  child: new Text("Add Financial Record")
              ),
            ]
        ),
        PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            onSelected: (route){
              body(route);
              setState(() {
                page = "ROI";
              });
            },
            child: ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text("ROI"),
              selected: tabController.index == 8 || tabController.index == 9 ? true : false,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              new PopupMenuItem<String>(
                  value: UIData.ROIRoute,
                  child: new Text("ROI Records")
              ),
              new PopupMenuItem<String>(
                  value: UIData.addROIRoute,
                  child: new Text("Add ROI Record")
              ),
            ]
        ),

        PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            onSelected: (route){
              body(route);
              setState(() {
                page = "GENERAL REPORT";
              });
            },
            child:ListTile(
              leading: Icon(Icons.show_chart),
              title: Text("Report"),
              selected: tabController.index == 10 || tabController.index == 11? true : false,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              new PopupMenuItem<String>(
                  value: UIData.truckReportRoute,
                  child: new Text("Trucks Report")
              ),
              new PopupMenuItem<String>(
                  value: UIData.driverReportRoute,
                  child: new Text("Drivers Report")
              ),
            ]
        ),
      ],
    );

  }

  void body(String page){
    switch(page){
      case UIData.dispatchRoute: tabController.animateTo(0); break;
      case UIData.addDispatchRoute : tabController.animateTo(1); break;
      case UIData.loadingRoute : tabController.animateTo(2); break;
      case UIData.addLoadingRoute : tabController.animateTo(3); break;
      case UIData.destinationRoute : tabController.animateTo(4); break;
      case UIData.addDestinationRoute : tabController.animateTo(5); break;
      case UIData.financeRoute: tabController.animateTo(6); break;
      case UIData.addFinanceRoute : tabController.animateTo(7); break;
      case UIData.ROIRoute : tabController.animateTo(8); break;
      case UIData.addROIRoute : tabController.animateTo(9); break;
      case UIData.truckReportRoute : tabController.animateTo(10); break;
      case UIData.driverReportRoute : tabController.animateTo(11); break;
    }
  }

}

