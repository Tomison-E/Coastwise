import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:leeway/models/ROI.dart';
import 'package:leeway/services/roiController.dart';
import 'package:provider/provider.dart';

class ROIView extends StatefulWidget {
  @override
  _ROIViewState createState() => _ROIViewState();
}

class _ROIViewState extends State<ROIView> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;

  @override
  void initState() {
    _items = Provider.of<ROIController>(context,listen: false).getAll(0,end: 10);
    super.initState();
  }

  void _sort<T>(Comparable<T> getField(ROI d), int columnIndex,
      bool ascending) {
    _items.sort((ROI a, ROI b) {
      if (!ascending) {
        final ROI c = a;
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

  List<ROI> _items = [];
  int _rowsOffset = 0;

  @override
  Widget build(BuildContext context) {
    var finance = Provider.of<ROIController>(context);
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
        final ROI roi = _items[index];
        return DataRow.byIndex(
            index: index,
            selected: roi.selected,
            onSelectChanged: (bool value) {
              if (roi.selected != value) {
                setState(() {
                  roi.selected = value;
                });
              }
            },
            cells: <DataCell>[
              DataCell(Text('${roi.wayBill}')),
              DataCell(Text('${roi.stakeholder}')),
              DataCell(Text('${roi.percentage}%')),
              DataCell(Text('${roi.id}')),
              DataCell(ButtonBar(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _items.remove(roi);
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        _items.remove(roi);
                      });
                    },
                  ),
                ],
              )),
            ]);
      },
      header: Text(' ROI Data Management',style: TextStyle(color: Colors.black87,fontSize: 20.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
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
            label: const Text('WayBill'),
            numeric: false,
            onSort: (int columnIndex, bool ascending) =>
                _sort<String>(
                        (ROI d) => d.wayBill, columnIndex, ascending)),
        DataColumn(
            label: const Text('Stakeholder'),
            onSort: (int columnIndex, bool ascending) =>
                _sort<String>(
                        (ROI d) => d.stakeholder, columnIndex, ascending)),
        DataColumn(
            label: const Text('Percentage'),
            numeric: true,
            onSort: (int columnIndex, bool ascending) =>
                _sort<num>(
                        (ROI d) => d.percentage, columnIndex, ascending)),
        DataColumn(
            label: const Text('ID'),
            numeric: true,
            onSort: (int columnIndex, bool ascending) =>
                _sort<num>(
                        (ROI d) => d.id, columnIndex, ascending)),
        DataColumn(
          label: const Text('Actions'),
        ),
      ],
    );
  }

}
