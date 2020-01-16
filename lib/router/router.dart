
import 'package:flutter/material.dart';
import 'package:leeway/screens/ROIView.dart';
import 'package:leeway/screens/destinationView.dart';
import 'package:leeway/screens/dispatchView.dart';
import 'package:leeway/screens/financesView.dart';
import 'package:leeway/screens/loadingView.dart';
import 'package:leeway/screens/notfound/notfound_page.dart';
import 'package:leeway/screens/registeration.dart';
import 'package:leeway/screens/truckCharts.dart';

import 'package:leeway/utils/uiData.dart';

import '../home.dart';
import '../home_screen.dart';


class Router {


    static Route<dynamic> generateRoute(settings) {
      switch (settings.name) {
        case UIData.homeRoute:
          return MaterialPageRoute(builder: (_) => Home(index: settings.arguments));
          break;
        case UIData.dispatchRoute:
          return MaterialPageRoute(builder: (_) => DispatchView());
          break;
        case UIData.addDispatchRoute:
          return MaterialPageRoute(builder: (_) => Register());
          break;
        case UIData.destinationRoute:
          return MaterialPageRoute(builder: (_) => DestinationView());
          break;
        case UIData.addDestinationRoute:
          return MaterialPageRoute(builder: (_) => Register());
          break;
        case UIData.loadingRoute:
          return MaterialPageRoute(builder: (_) => LoadingView());
          break;
        case UIData.addLoadingRoute:
          return MaterialPageRoute(builder: (_) => Register());
          break;
        case UIData.financeRoute:
          return MaterialPageRoute(builder: (_) => FinancesView());
          break;
        case UIData.addFinanceRoute:
          return MaterialPageRoute(builder: (_) => Register());
          break;
        case UIData.ROIRoute:
          return MaterialPageRoute(builder: (_) => ROIView());
          break;
        case UIData.addROIRoute:
          return MaterialPageRoute(builder: (_) => Register());
          break;
        case UIData.truckReportRoute:
          return MaterialPageRoute(builder: (_) => Register());
          break;
        case UIData.truckChartsRoute:
          return MaterialPageRoute(builder: (_) => TrucksChart());
          break;
        case UIData.driverReportRoute:
          return MaterialPageRoute(builder: (_) => Register());
          break;
      }
    }

    static Route<dynamic>  unknownRoute (settings) {
      return  MaterialPageRoute(
        builder: (context) =>  NotFoundPage(
        ));
    }

}



