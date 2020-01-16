import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leeway/models/destination.dart';
import 'package:leeway/services/destinationController.dart';
import 'package:provider/provider.dart';

class DestinationView extends StatefulWidget {
  @override
  _DestinationViewState createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;
  final formatDate = new DateFormat.yMMMMd("en_US");
  final formatTime = new DateFormat.jm();

  @override
  void initState() {
    _items = Provider.of<DestinationController>(context,listen: false).getAll(0,end: 20);
    super.initState();
  }

  void _sort<T>(Comparable<T> getField(Destination d), int columnIndex,
      bool ascending) {
    _items.sort((Destination a, Destination b) {
      if (!ascending) {
        final Destination c = a;
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

  List<Destination> _items = [];
  int _rowsOffset = 0;

  @override
  Widget build(BuildContext context) {
    var destination = Provider.of<DestinationController>(context);
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
          _items += destination.getAll(
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
        final Destination destination = _items[index];
        return DataRow.byIndex(
            index: index,
            selected: destination.selected,
            onSelectChanged: (bool value) {
              if (destination.selected != value) {
                setState(() {
                  destination.selected = value;
                });
              }
            },
            cells: <DataCell>[
              DataCell(Text('${destination.id}')),
              DataCell(Text('${destination.wayBill}')),
              DataCell(Text('${destination.officer}')),
              DataCell(Text('${destination.truckNo}')),
              DataCell(Text('${destination.ton}')),
              DataCell(Text('${formatTime.format(destination.timeIn)}')),
              DataCell(Text('${formatTime.format(destination.timeOut)}')),
              DataCell(ButtonBar(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _items.remove(destination);
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        _items.remove(destination);
                      });
                    },
                  ),
                ],
              )),
            ]);
      },
      header: Text(' Destination Records Management',style: TextStyle(color: Colors.black87,fontSize: 20.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      onRefresh: () async {
        await new Future.delayed(new Duration(seconds: 3));
        setState(() {
          _items=destination.getAll(_rowsOffset, end: (10));
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
          icon: Icon(Icons.info_outline),
          onPressed: () {},
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
                        (Destination d) => d.id, columnIndex, ascending)),
        DataColumn(
            label: const Text('Waybill'),
            onSort: (int columnIndex, bool ascending) =>
                _sort<String>(
                        (Destination d) => d.wayBill, columnIndex, ascending)),
        DataColumn(
            label: const Text('Officer'),
            onSort: (int columnIndex, bool ascending) =>
                _sort<String>(
                        (Destination d) => d.officer, columnIndex, ascending)),
        DataColumn(
            label: const Text('Truck Number'),
            numeric: true,
            onSort: (int columnIndex, bool ascending) =>
                _sort<num>((Destination d) => d.truckNo, columnIndex, ascending)),
        DataColumn(
            label: const Text('Ton'),
            numeric: true,
            onSort: (int columnIndex, bool ascending) =>
                _sort<num>((Destination d) => d.ton, columnIndex, ascending)),
        DataColumn(
            label: const Text('Time In'),
            numeric: false,
            onSort: (int columnIndex, bool ascending) =>
                _sort<DateTime>(
                        (Destination d) => d.timeIn, columnIndex, ascending)),
        DataColumn(
            label: const Text('Time Out'),
            onSort: (int columnIndex, bool ascending) =>
                _sort<DateTime>(
                        (Destination d) => d.timeOut, columnIndex, ascending)),
        DataColumn(
          label: const Text('Actions'),
        ),
      ],
    );
  }

}
