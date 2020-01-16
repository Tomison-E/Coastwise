import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leeway/models/loadingPoint.dart';
import 'package:leeway/services/loadingController.dart';
import 'package:provider/provider.dart';

class LoadingView extends StatefulWidget {
  @override
  _LoadingViewState createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;
  final formatDate = new DateFormat.yMMMMd("en_US");
  final formatTime = new DateFormat.jm();

  @override
  void initState() {
    _items = Provider.of<LoadingController>(context,listen: false).getAll(0,end: 10);
    super.initState();
  }

  void _sort<T>(Comparable<T> getField(LoadingPoint d), int columnIndex,
      bool ascending) {
    _items.sort((LoadingPoint a, LoadingPoint b) {
      if (!ascending) {
        final LoadingPoint c = a;
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

  List<LoadingPoint> _items = [];
  int _rowsOffset = 0;

  @override
  Widget build(BuildContext context) {
    var loading = Provider.of<LoadingController>(context);
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
          _items += loading.getAll(
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
        final LoadingPoint loading = _items[index];
        return DataRow.byIndex(
            index: index,
            selected: loading .selected,
            onSelectChanged: (bool value) {
              if (loading .selected != value) {
                setState(() {
                  loading .selected = value;
                });
              }
            },
            cells: <DataCell>[
              DataCell(Text('${loading.id}')),
              DataCell(Text('${loading.wayBill}')),
              DataCell(Text('${loading.officer}')),
              DataCell(Text('${loading.product}')),
              DataCell(Text('${loading.businessType}')),
              DataCell(Text('${loading.driver}')),
              DataCell(Text('${loading.truckNo}')),
              DataCell(Text('${loading.terminal}')),
              DataCell(Text('${loading.destination}')),
              DataCell(Text('${loading.ton}')),
              DataCell(Text('${formatDate.format(loading.date)}')),
              DataCell(Text('${formatTime.format(loading.timeIn)}')),
              DataCell(Text('${formatTime.format(loading.timeOut)}')),
              DataCell(ButtonBar(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _items.remove(loading);
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        _items.remove(loading);
                      });
                    },
                  ),
                ],
              )),
            ]);
      },
      header:Text(' Loading Records Management',style: TextStyle(color: Colors.black87,fontSize: 20.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      onRefresh: () async {
        await new Future.delayed(new Duration(seconds: 3));
        setState(() {
          _items=loading.getAll(_rowsOffset, end: (10));
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
                        (LoadingPoint d) => d.id, columnIndex, ascending)),
        DataColumn(
            label: const Text('WayBill'),
            numeric: false,
            onSort: (int columnIndex, bool ascending) =>
                _sort<String>(
                        (LoadingPoint d) => d.wayBill, columnIndex, ascending)),
        DataColumn(
            label: const Text('Officer'),
            numeric: true,
            onSort: (int columnIndex, bool ascending) =>
                _sort<String>(
                        (LoadingPoint d) => d.officer, columnIndex, ascending)),
        DataColumn(
            label: const Text('Product'),
            numeric: false,
            onSort: (int columnIndex, bool ascending) =>
                _sort<String>(
                        (LoadingPoint d) => d.product, columnIndex, ascending)),
        DataColumn(
            label: const Text('Business Type'),
            numeric: false,
            onSort: (int columnIndex, bool ascending) =>
                _sort<String>(
                        (LoadingPoint d) => d.businessType, columnIndex, ascending)),
        DataColumn(
            label: const Text('Driver'),
            numeric: true,
            onSort: (int columnIndex, bool ascending) =>
                _sort<String>(
                        (LoadingPoint d) => d.driver, columnIndex, ascending)),
        DataColumn(
            label: const Text('Truck Number'),
            numeric: true,
            onSort: (int columnIndex, bool ascending) =>
                _sort<num>((LoadingPoint d) => d.truckNo, columnIndex, ascending)),
        DataColumn(
            label: const Text('Terminal'),
            numeric: false,
            onSort: (int columnIndex, bool ascending) =>
                _sort<String>(
                        (LoadingPoint d) => d.terminal, columnIndex, ascending)),
        DataColumn(
            label: const Text('Destination'),
            numeric: false,
            onSort: (int columnIndex, bool ascending) =>
                _sort<String>(
                        (LoadingPoint d) => d.destination, columnIndex, ascending)),
        DataColumn(
            label: const Text('Ton'),
            numeric: true,
            onSort: (int columnIndex, bool ascending) =>
                _sort<num>((LoadingPoint d) => d.ton, columnIndex, ascending)),
        DataColumn(
            label: const Text('Date'),
            numeric: false,
            onSort: (int columnIndex, bool ascending) =>
                _sort<DateTime>(
                        (LoadingPoint d) => d.date, columnIndex, ascending)),
        DataColumn(
            label: const Text('Time In'),
            numeric: false,
            onSort: (int columnIndex, bool ascending) =>
                _sort<DateTime>(
                        (LoadingPoint d) => d.timeIn, columnIndex, ascending)),
        DataColumn(
            label: const Text('Time Out'),
            numeric: false,
            onSort: (int columnIndex, bool ascending) =>
                _sort<DateTime>(
                        (LoadingPoint d) => d.timeOut, columnIndex, ascending)),
        DataColumn(
          label: const Text('Actions'),
        ),
      ],
    );
  }

}
