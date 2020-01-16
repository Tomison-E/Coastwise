import 'package:flutter/material.dart';
import 'package:leeway/db/database.dart';
import 'package:leeway/models/chart.dart';
import 'package:leeway/models/destination.dart';
import 'package:leeway/models/financials.dart';
import 'package:leeway/models/loadingPoint.dart';
import 'package:leeway/models/report.dart';
import 'package:leeway/models/truck.dart';


class ReportController with ChangeNotifier {


  List<Destination> _allDestination;
  List<Bar> bar = [];
  List<Chart> chart = [];
  List<Report> truckReport =[];
  List<LoadingPoint> _allLoading;
  List<String> _driver = [];
  List<String> _product = [];
  List<String> _business = [];
  List<String> _terminal = [];
  List<String> _destination = [];


  List<Destination> getAllDestinations(int begin, {int end}) {
    _allDestination = Database.destination.sublist(begin, end);
    return _allDestination;
  }


  List<LoadingPoint> getAllLoading(int begin, {int end}) {
    _allLoading = Database.loading.sublist(begin, end);
    return _allLoading;
  }

  List<LoadingPoint> getTruckJobs(int truckNo) {
    List<LoadingPoint> _selectedTruckJobs = [];

    LoadingPoint job;
    getAllDestinations(0);
    getAllLoading(0);
    _allDestination.forEach((f) {
      if (f.truckNo == truckNo) {
        job =
            _allLoading.firstWhere((loading) => loading.wayBill.toLowerCase() ==
                f.wayBill.toLowerCase(), orElse: () => null);
        if (job != null) {
          _selectedTruckJobs.add(job);
          _driver.add(job.driver);
          _product.add(job.product);
          _business.add(job.businessType);
          _terminal.add(job.terminal);
          _destination.add(job.destination);
        }
      }
    });
    _driver = _driver.toSet().toList();
    _product = _product.toSet().toList();
    _business = _business.toSet().toList();
    _terminal = _terminal.toSet().toList();
    _destination = _destination.toSet().toList();
    return _selectedTruckJobs;
  }

  List<String> getDrivers() {
    return _driver;
  }

  List<String> getProducts() {
    return _product;
  }

  List<String> getBusinesses() {
    return _business;
  }

  List<String> getTerminals() {
    return _terminal;
  }

  List<String> getDestinations() {
    return _destination;
  }

  List<Truck> getTrucks() {
    return Database.trucks;
  }

  List<Chart> pieChart() {
    List<Truck> trucks = getTrucks();
    List<Chart> chart = [];
    getAllDestinations(0);
    List<Financial> finances = getAllFinances(0);
    trucks.forEach((t) {
      int ton = 0;
      int profit = 0;
      Financial job;
      _allDestination.forEach((d) {
        if (d.truckNo == t.no) {
          ton += d.ton;
          job = finances.firstWhere((finance) => finance.wayBill.toLowerCase() == d.wayBill.toLowerCase(), orElse: () => null);
        }
        job != null ? profit += job.profit : profit = profit;
      });
      chart.add(Chart(t.no, ton));
      bar.add(Bar(t.no.toString(), profit));
    });
    return chart;
  }

  // ignore: non_constant_identifier_names
   void charts(List<Truck> totalTrucks, DateTime begin, DateTime end) {
    chart=[];
    bar=[];
    int ton;
    int profit;
    Financial job;
    var trucks;
    totalTrucks==[]?trucks= getTrucks():trucks=totalTrucks;
    getAllDestinations(0);
    List<Financial> finances = getAllFinances(0);
    trucks.forEach((t) {
       ton = 0;
       profit = 0;
      _allDestination.forEach((d) {
       job = null;
        if (d.truckNo == t.no && (begin== null || d.date.isAfter(begin) ) && (end==null || d.date.isBefore(end))) {
          ton += d.ton;
          job = finances.firstWhere((finance) => finance.wayBill.toLowerCase() == d.wayBill.toLowerCase(), orElse: () => null);
        }
        job != null ? profit += job.profit : profit = profit;
      });
      chart.add(Chart(t.no, ton));
      bar.add(Bar(t.no.toString(), profit));
    });

  }

  List<Report> getTotalTrucksReport() {
    List<Truck> trucks = getTrucks();
    int ton;
    int profit;
    Financial job;
    getAllDestinations(0);
    List<Financial> finances = getAllFinances(0);
    trucks.forEach((t) {
       ton = 0;
       profit = 0;
      _allDestination.forEach((d) {
         job = null;
        if (d.truckNo == t.no) {
          ton += d.ton;
          job = finances.firstWhere((finance) => finance.wayBill.toLowerCase() == d.wayBill.toLowerCase(), orElse: () => null);
        }
        job != null ? profit += job.profit : profit = profit;
      });
      chart.add(Chart(t.no, ton));
      bar.add(Bar(t.no.toString(), profit));
      truckReport.add(Report(t.no,ton,profit));
    });
    return truckReport;
  }

  List<Financial> getAllFinances(int begin, {int end}) {
    return Database.finances.sublist(begin, end);
  }


  List<List<Chart>> getTruckProfits() {

    List<Truck> trucks = getTrucks();
    List<List<Chart>> totalProfit=[];
    List<int> profits;
    getAllDestinations(0);
    List<Financial> finances = getAllFinances(0);
    trucks.forEach((t) {
     profits = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
      _allDestination.forEach((d) {
        Financial job;
        if (d.truckNo == t.no) {
          job = finances.firstWhere((finance) => finance.wayBill.toLowerCase() == d.wayBill.toLowerCase(), orElse: () => null);
        }
        job != null ? profits[getMonth(d.date)] += job.profit :print("");
      });
      totalProfit.add([
        Chart(1,profits[0]),
        Chart(2,profits[1]),
        Chart(3,profits[2]),
        Chart(4,profits[3]),
        Chart(5,profits[4]),
        Chart(6,profits[5]),
        Chart(7,profits[6]),
        Chart(8,profits[7]),
        Chart(9,profits[8]),
        Chart(10,profits[9]),
        Chart(11,profits[10]),
        Chart(12,profits[11])
      ]);
    });
    return totalProfit;
  }


  int getMonth(DateTime date) {
    var thisDate = DateTime(2019);
    if (date.year == thisDate.year && date.month == 1) return 0;
    if (date.year == thisDate.year && date.month == 2) return 1;
    if (date.year == thisDate.year && date.month == 3) return 2;
    if (date.year == thisDate.year && date.month == 4) return 3;
    if (date.year == thisDate.year && date.month == 5) return 4;
    if (date.year == thisDate.year && date.month == 6) return 5;
    if (date.year == thisDate.year && date.month == 7) return 6;
    if (date.year == thisDate.year && date.month == 8) return 7;
    if (date.year == thisDate.year && date.month == 9) return 8;
    if (date.year == thisDate.year && date.month == 10) return 9;
    if (date.year == thisDate.year && date.month == 11) return 10;
    if (date.year == thisDate.year && date.month == 12) return 11;
    return null;
  }


}

//end of sublist
// ensure waybill is unique