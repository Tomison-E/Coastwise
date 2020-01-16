import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leeway/models/financials.dart';
import 'package:leeway/services/financeController.dart';
import 'package:provider/provider.dart';

class FinancesView extends StatefulWidget {
  @override
  _FinancesViewState createState() => _FinancesViewState();
}

class _FinancesViewState extends State<FinancesView> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;
  final currency = new  NumberFormat('#,##0.00','en_NG');

  @override
  void initState() {
    _items = Provider.of<FinanceController>(context,listen: false).getAll(0,end: 10);
    super.initState();
  }

  void _sort<T>(Comparable<T> getField(Financial d), int columnIndex,
      bool ascending) {
    _items.sort((Financial a, Financial b) {
      if (!ascending) {
        final Financial c = a;
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

  List<Financial> _items = [];
  int _rowsOffset = 0;

  @override
  Widget build(BuildContext context) {
    var finance = Provider.of<FinanceController>(context);
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
          _items += finance.getAll(
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
        final Financial finance = _items[index];
        return DataRow.byIndex(
            index: index,
            selected: finance.selected,
            onSelectChanged: (bool value) {
              if (finance .selected != value) {
                setState(() {
                  finance .selected = value;
                });
              }
            },
            cells: <DataCell>[
              DataCell(Text('${finance.id}')),
              DataCell(Text('${finance.wayBill}')),
              DataCell(Text('₦ ${currency.format(finance.costPerTon)}')),
              DataCell(Text('₦ ${currency.format(finance.totalCost)}')),
              DataCell(Text('₦ ${currency.format(finance.profit)}')),
              DataCell(ButtonBar(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _items.remove(finance);
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        _items.remove(finance);
                      });
                    },
                  ),
                ],
              )),
            ]);
      },
      header:Text(' Finances Data Management',style: TextStyle(color: Colors.black87,fontSize: 20.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      onRefresh: () async {
        await new Future.delayed(new Duration(seconds: 3));
        setState(() {
          _items=finance.getAll(_rowsOffset, end: (10));
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
                        (Financial d) => d.id, columnIndex, ascending)),
        DataColumn(
            label: const Text('WayBill'),
            numeric: false,
            onSort: (int columnIndex, bool ascending) =>
                _sort<String>(
                        (Financial d) => d.wayBill, columnIndex, ascending)),
        DataColumn(
            label: const Text('Cost/Ton'),
            numeric: true,
            onSort: (int columnIndex, bool ascending) =>
                _sort<num>(
                        (Financial d) => d.costPerTon, columnIndex, ascending)),
        DataColumn(
            label: const Text('Total Cost'),
            numeric: true,
            onSort: (int columnIndex, bool ascending) =>
                _sort<num>(
                        (Financial d) => d.totalCost, columnIndex, ascending)),
        DataColumn(
            label: const Text('Profit'),
            numeric: true,
            onSort: (int columnIndex, bool ascending) =>
                _sort<num>(
                        (Financial d) => d.profit, columnIndex, ascending)),
        DataColumn(
          label: const Text('Actions'),
        ),
      ],
    );
  }

}
