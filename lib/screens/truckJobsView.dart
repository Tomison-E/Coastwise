import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leeway/models/loadingPoint.dart';
import 'package:leeway/services/reportController.dart';
import 'package:leeway/utils/uiData.dart';
import 'package:provider/provider.dart';

class TruckJobsView extends StatefulWidget {
  final int number;
  
  TruckJobsView({@required this.number});
  
  @override
  _TruckJobsViewState createState() => _TruckJobsViewState();
}

class _TruckJobsViewState extends State<TruckJobsView> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;
  final formatDate = new DateFormat.yMMMMd("en_US");
  final formatTime = new DateFormat.jm();
  String _driver;
  String _product;
  String _terminal;
  String _business;
  String _destination;
  int _ton;
  int _date;

  @override
  void initState() {
    _items = Provider.of<ReportController>(context,listen: false).getTruckJobs(widget.number);
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
    var truckReport = Provider.of<ReportController>(context);
    return Scaffold(
        appBar: AppBar(
        leading:
        Icon(Icons.menu,color: Colors.black87),
    title: Text("Coastwise LTD",style: TextStyle(fontSize: 22.0,color: Colors.black87)),
    centerTitle: false,
    backgroundColor: Colors.white,
    elevation: 0.5,
    actions: <Widget>[
    SizedBox(child:TextField(decoration: InputDecoration(prefixIcon: Icon(Icons.search),suffixIcon: Icon(Icons.arrow_drop_down),filled: true,fillColor: Color.fromRGBO(245, 246, 247, 1.0))),width: 500.0,),
      SizedBox(width: 150.0),
      Image.network("assets/icons/icons8-notification-50 copy.png",width: 30.0),
      SizedBox(width: 10.0),
      Image.network("assets/icons/icons8-ask-question-50.png",width: 30.0),
      SizedBox(width: 10.0),
      Image.network("assets/icons/icons8-settings-50-2 copy.png",width: 30.0),
      SizedBox(width: 40.0)
    ],
    ),
    body: Row(
    children: <Widget>[
    MediaQuery.of(context).size.width < 1300
    ? Container()
        :SingleChildScrollView(child:Card(child:Container(
    margin: EdgeInsets.all(0),
    height: MediaQuery.of(context).size.height+20.0,
    width: 50,
    color: Colors.white,
    child: listDrawerItem(false,context)))),
    Container(
    width:  MediaQuery.of(context).size.width > 1300
    ? MediaQuery.of(context).size.width-60:MediaQuery.of(context).size.width,
    child:Column(
        children:[
        SizedBox(height: 20.0),
        Padding(child:Text("Truck Number ${widget.number} Job Records",style: TextStyle(color: Colors.black87,fontSize: 20.0)),padding: EdgeInsets.only(left:20.0),),
        SizedBox(height: 20.0),
        Expanded(child:Padding(child:NativeDataTable.builder(
      rowsPerPage: _rowsPerPage,
      itemCount: _items?.length ?? 0,
      firstRowIndex: _rowsOffset,
      handleNext:() async {
        setState(() {
          _rowsOffset += _rowsPerPage;
        });

      /*  await new Future.delayed(new Duration(seconds: 3));
        print(_rowsOffset);

        setState(() {
          _items += truckReport.getTruckJobs(115);
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
              DataCell(Text('${loading.wayBill}')),
              DataCell(Text('${loading.officer}')),
              DataCell(Text('${loading.product}')),
              DataCell(Text('${loading.businessType}')),
              DataCell(Text('${loading.driver}')),
              DataCell(Text('${loading.terminal}')),
              DataCell(Text('${loading.destination}')),
              DataCell(Text('${loading.ton}')),
              DataCell(Text('${formatDate.format(loading.date)}')),
              DataCell(Text('${formatTime.format(loading.timeIn)}')),
              DataCell(Text('${formatTime.format(loading.timeOut)}')),
            ]);
      },
      header:Text(' ',style: TextStyle(color: Colors.blue,fontSize: 20.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      onRefresh: ()  async{
       await new Future.delayed(new Duration(seconds: 3));
        setState(() {
          _driver=null;
          _destination =null;
          _terminal=null;
          _business = null;
          _product = null;
          _date = null;
          _ton = null;
          _items.clear();
          _items = truckReport.getTruckJobs(widget.number);
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
        DropdownButton<String>(
          items:  truckReport.getDrivers().map((String driver){
      return new DropdownMenuItem<String>(
        value: driver,
        child: Text(driver),
      );
    }).toList(),
          value: _driver,
          onChanged: (value) {
            setState(() {
              _driver = value;
              _items = sortTruckJobs(_driver, _product, _terminal, _business, _destination, _ton, _date);
            });
          },
          hint: Text(
            "Driver!",
            style: TextStyle(
              color: Colors.black87,
            ),
          ),icon: Icon(Icons.local_shipping),
        ),
        DropdownButton<String>(
          items: truckReport.getProducts().map((String product){
            return new DropdownMenuItem<String>(
              value: product,
              child: Text(product),
            );
          }).toList(),
          value: _product,
          onChanged: (value) {
            setState(() {
              _product = value;
              _items = sortTruckJobs(_driver, _product, _terminal, _business, _destination, _ton, _date);
            });
          },
          hint: Text(
            "Product!",
            style: TextStyle(
              color: Colors.black87,
            ),
          ),icon: Icon(Icons.local_offer),
        ),
        DropdownButton<String>(
          items: truckReport.getBusinesses().map((String business){
            return new DropdownMenuItem<String>(
              value: business,
              child: Text(business),
            );
          }).toList(),
          value: _business,
          onChanged: (value) {
            setState(() {
              _business = value;
              _items = sortTruckJobs(_driver, _product, _terminal, _business, _destination, _ton, _date);
            });
          },
          hint: Text(
            "Business!",
            style: TextStyle(
              color: Colors.black87,
            ),
          ),icon: Icon(Icons.business),
        ),
        DropdownButton<String>(
          items:truckReport.getTerminals().map((String terminal){
            return new DropdownMenuItem<String>(
              value: terminal,
              child: Text(terminal),
            );
          }).toList(),
          value: _terminal,
          onChanged: (value) {
            setState(() {
              _terminal = value;
              _items = sortTruckJobs(_driver, _product, _terminal, _business, _destination, _ton, _date);
            });
          },
          hint: Text(
            "Terminal!",
            style: TextStyle(
              color: Colors.black87,
            ),
          ),icon: Icon(Icons.directions),
        ),
        DropdownButton<String>(
          items: truckReport.getDestinations().map((String destination){
            return new DropdownMenuItem<String>(
              value: destination,
              child: Text(destination),
            );
          }).toList(),
          value: _destination,
          onChanged: (value) {
            setState(() {
              _destination = value;
              _items = sortTruckJobs(_driver, _product, _terminal, _business, _destination, _ton, _date);
            });
          },
          hint: Text(
            "Destination!",
            style: TextStyle(
              color: Colors.black87,
            ),
          ),icon: Icon(Icons.map),
        ),
        DropdownButton<int>(
          items: [
            DropdownMenuItem<int>(
              value:5,
              child: Text("${'5'}"),
            ),
            DropdownMenuItem<int>(
              value:10,
              child: Text("${'10'}"),
            ),
            DropdownMenuItem<int>(
              value:15,
              child: Text("${'15'}"),
            ),
            DropdownMenuItem<int>(
              value:20,
              child: Text("${'20'}"),
            ),
            DropdownMenuItem<int>(
              value:40,
              child: Text("${'40'}"),
            ),
            DropdownMenuItem<int>(
              value:50,
              child: Text("${'50'}"),
            )],
          value: _ton,
          onChanged: (value) {
            setState(() {
              _ton = value;
              _items = sortTruckJobs(_driver, _product, _terminal, _business, _destination, _ton, _date);
            });
          },
          hint: Text(
            "Tons!",
            style: TextStyle(
              color: Colors.black87,
            ),
          ),icon: Icon(Icons.line_weight),
        ),
        DropdownButton<int>(
          items: [
            DropdownMenuItem<int>(
              value:0,
              child: Text("${'Day'}"),
            ),
            DropdownMenuItem<int>(
              value:1,
              child: Text("${'Week'}"),
            ),
            DropdownMenuItem<int>(
              value:2,
              child: Text("${'Month'}"),
            ),
            DropdownMenuItem<int>(
              value:3,
              child: Text("${'Year'}"),
            )],
          value: _date,
          onChanged: (value) {
            setState(() {
              _date = value;
              _items = sortTruckJobs(_driver, _product, _terminal, _business, _destination, _ton, _date);
            });
          },
          hint: Text(
            "Date!",
            style: TextStyle(
              color: Colors.black87,
            ),
          ),icon: Icon(Icons.date_range),
        ),
        IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () {},
        ),
    ],
      selectedActions: <Widget>[],
      mobileIsLoading: CircularProgressIndicator(),
      noItems: Text("No Items Found"),
      columns: <DataColumn>[
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
      ],
        ),padding: EdgeInsets.only(left: 15.0)))],crossAxisAlignment: CrossAxisAlignment.start,))]),backgroundColor: Colors.white,
    );
  }

  List<LoadingPoint> sortTruckJobs(String driver, String product,String terminal,String business,String destination,int ton,int date){
    List<LoadingPoint> sorted=[];
    DateTime sortDate;
    date!=null?sortDate=getDate(date):sortDate=null;
    _items.forEach((job){
   if((job.driver == driver || driver==null) && (job.destination == destination || destination==null) && (job.product == product || product==null) && (job.terminal==terminal || terminal==null) && (job.businessType ==business || business==null) && (ton== null  || job.ton <=ton || ton==0) && (sortDate==null || job.date.isAfter(sortDate)) ){
      sorted.add(job);
    }
  });
    return sorted;
  }

  DateTime getDate(int i){
    switch(i){
      case 0: return DateTime.now().subtract(Duration(days: 1));break;
      case 1: return DateTime.now().subtract(Duration(days: 7));break;
      case 2: return DateTime.now().subtract(Duration(days: 30));break;
      case 3: return DateTime.now().subtract(Duration(days: 365));break;
    }
    return null;
  }
  Widget listDrawerItem(bool drawerStatus,BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(0),
      children: [
        SizedBox(height: 20.0),
        GestureDetector(child:ImageIcon(NetworkImage("assets/icons/analysis.png"),size: 40.0,),onTap: ()=> Navigator.of(context)
            .pushNamedAndRemoveUntil(UIData.homeRoute, (Route<dynamic> route) => false,arguments: 0),),
        SizedBox(height: 20.0),
        ImageIcon(NetworkImage("assets/icons/icons8-truck-50 copy.png"),size: 40.0,),
        SizedBox(height: 30.0),
        ImageIcon(NetworkImage("assets/icons/logistics.png"),size: 40.0,),
        SizedBox(height: 30.0),
        ImageIcon(NetworkImage("assets/icons/warehouse.png"),size: 40.0,),
        SizedBox(height: 30.0),
        ImageIcon(NetworkImage("assets/icons/bank.png"),size: 40.0,),
        SizedBox(height: 30.0),
        ImageIcon(NetworkImage("assets/icons/meeting.png"),size: 40.0,),
        SizedBox(height: 30.0),
        ImageIcon(NetworkImage("assets/icons/dashboard.png"),size: 40.0,),
        SizedBox(height: 10.0),
      ],
    );

  }
}
