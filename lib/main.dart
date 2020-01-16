import 'package:flutter/material.dart';
import 'package:leeway/router/router.dart';
import 'package:leeway/services/destinationController.dart';
import 'package:leeway/services/financeController.dart';
import 'package:leeway/services/loadingController.dart';
import 'package:leeway/services/reportController.dart';
import 'package:leeway/services/roiController.dart';
import 'services/dispatchController.dart';
import 'services/user.dart';
import 'package:leeway/screens/login.dart';
import 'package:provider/provider.dart';



void main() => runApp(
MultiProvider(
providers: [
  ChangeNotifierProvider(builder: (_) => DispatchController()),
  ChangeNotifierProvider(builder: (_)=> UserController()),
  ChangeNotifierProvider(builder: (_)=> DestinationController()),
  ChangeNotifierProvider(builder: (_)=> LoadingController()),
  ChangeNotifierProvider(builder: (_)=> FinanceController()),
  ChangeNotifierProvider(builder: (_)=> ROIController()),
  ChangeNotifierProvider(builder: (_)=> ReportController()),
],
child:MyApps())
);

class MyApps extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coastwise LTD',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryTextTheme: TextTheme(display3: TextStyle(color: Colors.orange)),
          fontFamily: 'OpenSans'
      ),
      home: LoginPage(),
      onGenerateRoute: Router.generateRoute,
      onUnknownRoute: Router.unknownRoute,debugShowCheckedModeBanner: false,
    );
  }
}


