import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leeway/models/dispatch.dart';
import 'package:leeway/screens/registeration.dart';
import 'package:provider/provider.dart';
import 'package:leeway/services/dispatchController.dart';

class DispatchView extends StatefulWidget {
  @override
  _DispatchViewState createState() => _DispatchViewState();
}

class _DispatchViewState extends State<DispatchView> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;
  final formatDate = new DateFormat.yMMMMd("en_US");
  final formatTime = new DateFormat.jm();

  @override
  void initState() {
     _items = Provider.of<DispatchController>(context,listen: false).getAll(0,end: 20);
    super.initState();
  }

  void _sort<T>(Comparable<T> getField(Dispatch d), int columnIndex,
      bool ascending) {
    _items.sort((Dispatch a, Dispatch b) {
      if (!ascending) {
        final Dispatch c = a;
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

  List<Dispatch> _items = [];
  int _rowsOffset = 0;

  @override
  Widget build(BuildContext context) {
    var dispatch = Provider.of<DispatchController>(context);
   // _items=dispatch.getAll(_rowsOffset, end: (30));
    return NativeDataTable.builder(
      rowsPerPage: _rowsPerPage,
      itemCount: _items?.length ?? 0,
      firstRowIndex: _rowsOffset,
      handleNext: _rowsOffset>30? null:() async {
        setState(() {
          _rowsOffset += _rowsPerPage;
        });

        await new Future.delayed(new Duration(seconds: 3));
        print(_rowsOffset);

        setState(() {
          _items += dispatch.getAll(
              _rowsOffset, end: (_rowsOffset + _rowsPerPage));
        });

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
        final Dispatch dispatch = _items[index];
        return DataRow.byIndex(
            index: index,
            selected: dispatch.selected,
            onSelectChanged: (bool value) {
              if (dispatch.selected != value) {
                setState(() {
                  dispatch.selected = value;
                });
              }
            },
            cells: <DataCell>[
              DataCell(Text('${dispatch.id}')),
              DataCell(Text('${dispatch.officer}')),
              DataCell(Text('${dispatch.driver}')),
              DataCell(Text('${dispatch.truckNo}')),
              DataCell(Text('${formatDate.format(dispatch.date)}')),
              DataCell(Text('${formatTime.format(dispatch.time)}')),
              DataCell(ButtonBar(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _items.remove(dispatch);
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        _items.remove(dispatch);
                      });
                    },
                  ),
                ],
              )),
            ]);
      },
      header:  Text(' Dispatch Records Management',style: TextStyle(color: Colors.black87,fontSize: 20.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      onRefresh: () async {
        await new Future.delayed(new Duration(seconds: 3));
        setState(() {
          _items=dispatch.getAll(_rowsOffset, end: (10));
        });
        return null;
      },
      onRowsPerPageChanged: (int value) {
        setState(() {
          _rowsPerPage = value;
        });
        print("New Rows: $value");
      },
      // mobileItemBuilder: (BuildContext context, int index) {
      //   final i = _desserts[index];
      //   return ListTile(
      //     title: Text(i?.name),
      //   );
      // },
      onSelectAll: (bool value) {
        for (var row in _items) {
          setState(() {
            row.selected = value;
          });
        }
      },
      rowCountApproximate: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.cloud_upload),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Register()));
          },
        ),
      ],
      selectedActions: <Widget>[
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            setState(() {
              for (var item in _items
                  ?.where((d) => d?.selected ?? false)
                  ?.toSet()
                  ?.toList()) {
                _items.remove(item);
              }
            });
          },
        ),
      ],
      mobileIsLoading: CircularProgressIndicator(),
      noItems: Text("No Items Found"),
      columns: <DataColumn>[
        DataColumn(
            label: const Text('ID'),
            numeric: true,
            onSort: (int columnIndex, bool ascending) =>
                _sort<num>(
                        (Dispatch d) => d.id, columnIndex, ascending)),
        DataColumn(
            label: const Text('Officer'),
            numeric: true,
            onSort: (int columnIndex, bool ascending) =>
                _sort<String>(
                        (Dispatch d) => d.officer, columnIndex, ascending)),
        DataColumn(
            label: const Text('Driver'),
            numeric: true,
            onSort: (int columnIndex, bool ascending) =>
                _sort<String>((Dispatch d) => d.driver, columnIndex, ascending)),
        DataColumn(
            label: const Text('Truck Number'),
            numeric: true,
            onSort: (int columnIndex, bool ascending) =>
                _sort<num>((Dispatch d) => d.truckNo, columnIndex, ascending)),
        DataColumn(
            label: const Text('Date'),
            numeric: true,
            onSort: (int columnIndex, bool ascending) =>
                _sort<DateTime>(
                        (Dispatch d) => d.date, columnIndex, ascending)),
        DataColumn(
            label: const Text('Time'),
            numeric: true,
            onSort: (int columnIndex, bool ascending) =>
                _sort<DateTime>(
                        (Dispatch d) => d.time, columnIndex, ascending)),
        DataColumn(
          label: const Text('Actions'),
        ),
      ],
    );
  }

}
