import 'package:data_tables/data_tables.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leeway/models/ROI.dart';
import 'package:leeway/models/report.dart';
import 'package:leeway/models/truck.dart';
import 'package:leeway/screens/truckJobsView.dart';
import 'package:leeway/screens/trucksReport.dart';
import 'package:leeway/services/reportController.dart';
import 'package:provider/provider.dart';

class TrucksTotal extends StatefulWidget {
  @override
  _TrucksTotalState createState() => _TrucksTotalState();
}

class _TrucksTotalState extends State<TrucksTotal> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;
  final currency = new  NumberFormat('#,##0.00','en_NG');
  final formatDate = new DateFormat.yMMMMd("en_US");
  DateTime begin;
  DateTime end;

  @override
  void initState() {
    _items = Provider.of<ReportController>(context,listen: false).getTotalTrucksReport();
    super.initState();
  }

  void _sort<T>(Comparable<T> getField(Report d), int columnIndex,
      bool ascending) {
    _items.sort((Report a, Report b) {
      if (!ascending) {
        final Report c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  List<Report> _items = [];
  int _rowsOffset = 0;

  @override
  Widget build(BuildContext context) {
    var truck = Provider.of<ReportController>(context);
    return NativeDataTable.builder(
      rowsPerPage: _rowsPerPage,
      itemCount: _items?.length ?? 0,
      firstRowIndex: _rowsOffset,
      handleNext: () async {
        setState(() {
          _rowsOffset += _rowsPerPage;
        });

     /*   await new Future.delayed(new Duration(seconds: 3));
        print(_rowsOffset);

        setState(() {
          _items += trucks.getAll(
              _rowsOffset, end: (_rowsOffset + _rowsPerPage));
        });*/

      },
      handlePrevious: () {
        setState(() {
          _rowsOffset -= _rowsPerPage;
        });
      },
      mobileSlivers: <Widget>[
        SliverAppBar(
          title: Text("Mobile App Bar"),
        ),
      ],
      itemBuilder: (int index) {
        final Report report = _items[index];
        return DataRow.byIndex(
            index: index,
            selected: report.selected,
            onSelectChanged: (bool value) {
              if (report.selected != value) {
                setState(() {
                  report.selected = value;
                });
              }
            },
            cells: <DataCell>[
              DataCell(Text('${report.variable}')),
              DataCell(Text('${report.ton}')),
              DataCell(Text('₦ ${currency.format(report.profit)}')),
              DataCell(ButtonBar(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.forward),
                    onPressed: () {
                      setState(() {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context)=>TruckJobsView(number: report.variable)
                    ));
                      });
                    },
                  ),
                ],
              )),
            ]);
      },
      header:Text(' Trucks Report',style: TextStyle(color: Colors.black87,fontSize: 20.0,fontWeight: FontWeight.bold)),
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      onRefresh: () async {
        await new Future.delayed(new Duration(seconds: 3));
        setState(() {
          _items=truck.getTotalTrucksReport();
        });
        return null;
      },
      onRowsPerPageChanged: (int value) {
        setState(() {
          _rowsPerPage = value;
        });
        print("New Rows: $value");
      },
      onSelectAll: (bool value) {
        for (var row in _items) {
          setState(() {
            row.selected = value;
          });
        }
      },
      rowCountApproximate: false,
      actions: <Widget>[
   /*     SizedBox(
    child: Column(children: <Widget>[
      Row(children:[ Icon(Icons.date_range,size: 18.0,),SizedBox(width: 15.0),Text("Start",style:TextStyle(color:Colors.grey,fontSize: 18.0)),]),
     DateTimeField(
        format: formatDate,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
        onChanged: (start)=>begin = start )

    ],crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start,),width: 100.0,
        ),
    SizedBox(
    child:Column(children: <Widget>[
      Row(children:[ Icon(Icons.date_range,size: 20.0,),SizedBox(width: 18.0),Text("Finish",style:TextStyle(color:Colors.grey,fontSize: 18.0)),]),
     DateTimeField(
          format: formatDate,
          onShowPicker: (context, currentValue) {
            return showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2100));
          },
          onChanged: (finish)=>end = finish )

    ],crossAxisAlignment: CrossAxisAlignment.start,),width: 100.0,
    )*/
      ],
      selectedActions: <Widget>[
        SizedBox(
          child:DateTimeField(
                format: formatDate,
                onShowPicker: (context, currentValue) {
                  return showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime(DateTime.now().year,1,1),
                      lastDate: DateTime(2100));
                },
                onChanged: (start)=>begin = start ),width: 200.0,
        ),
        SizedBox(
          child: DateTimeField(
                format: formatDate,
                onShowPicker: (context, currentValue) {
                  return showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                },
                onChanged: (finish)=>end = finish ),width: 200.0,
        ),
        IconButton(
          icon: Icon(Icons.insert_chart),
          onPressed: () {
           List<Truck> selectedTrucks=[];
              for (var item in _items
                  ?.where((d) => d?.selected ?? false)
                  ?.toSet()
                  ?.toList()) {
    selectedTrucks.add(Truck(no:item.variable));
    }
              print(selectedTrucks.length);
               truck.charts(selectedTrucks, begin, end);
                Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>TrucksReport()
                ));
            }
        ),
      ],
      mobileIsLoading: CircularProgressIndicator(),
      noItems: Text("No Items Found"),
      columns: <DataColumn>[
        DataColumn(
            label: const Text('Truck Number'),
            numeric: true,
            onSort: (int columnIndex, bool ascending) =>
                _sort<num>(
                        (Report d) => d.variable, columnIndex, ascending)),
        DataColumn(
            label: const Text('Tons'),
            numeric: true,
            onSort: (int columnIndex, bool ascending) =>
                _sort<num>(
                        (Report d) => d.ton, columnIndex, ascending)),
        DataColumn(
            label: const Text('Revenue'),
            numeric: false,
            onSort: (int columnIndex, bool ascending) =>
                _sort<num>(
                        (Report d) => d.profit, columnIndex, ascending)),
        DataColumn(
          label: const Text('Actions'),
        ),
      ],
    );
  }



}
