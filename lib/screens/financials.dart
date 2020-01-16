import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import '../utils/responsiveLayout.dart';
import 'package:intl/intl.dart';
//import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';


class Financial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xFFF8FBFF),
            Color(0xFFFCFDFD),
          ])),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child:Align(child:Column(
              children: <Widget>[
                Body()],mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            ),alignment: Alignment.center),
            /*Column(
            children: <Widget>[Body()],mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
          )*/
          )
      ),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      largeScreen: LargeChild(),
      smallScreen: SmallChild(),
    );
  }
}

class LargeChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Center(
        child:FinancialForm(),
      ),
      width: 700.0,
    );
  }
}

class SmallChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LargeChild();
  }
}

class FinancialForm extends StatefulWidget {
  const FinancialForm({Key key}) : super(key: key);

  @override
  _FinancialFormState createState() => _FinancialFormState();
}

class _FinancialFormState extends State<FinancialForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _agreedToTOS = true;
  final formatDate = new DateFormat.yMMMMd("en_US");
  final formatTime = new DateFormat.jm();

  String vals = "2";
  Map<String, dynamic> formData;
  List<String> cities = [
    'Bangalore',
    'Chennai',
    'New York',
    'Mumbai',
    'Delhi',
    'Tokyo',
  ];

  _RegisterFormState() {
    formData = {
      'City': 'Bangalore',
      'Country': 'INDIA',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'WayBill',icon: Icon(Icons.line_weight),hintText: "Tel",
            ),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return "Waybill is required";
              }
              return null;
            },keyboardType: TextInputType.numberWithOptions(),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            decoration: const InputDecoration(
                labelText: 'Total Cost',icon: Icon(Icons.account_balance_wallet)
            ),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return "Name is required";
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            decoration: const InputDecoration(
                labelText: 'Cost per Ton',icon: Icon(Icons.supervisor_account)
            ),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return "Name is required";
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            decoration: const InputDecoration(
                labelText: 'Profit',icon: Icon(Icons.account_balance)
            ),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return "Name is required";
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          Row(
            children: <Widget>[
              const Spacer(),
              RaisedButton(onPressed: (){},color: Colors.teal,child: Text("Register"),highlightColor: Colors.white,hoverColor: Colors.black,textColor: Colors.white,)
            ],
          ),
        ],mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  bool _submittable() {
    return _agreedToTOS;
  }

  void _submit() {
    _formKey.currentState.validate();
    print('Form submitted');
  }

  void _setAgreedToTOS(bool newValue) {
    setState(() {
      _agreedToTOS = newValue;
    });
  }
}



class DropDown extends StatefulWidget {
  DropDown() : super();

  final String title = "DropDown Demo";

  @override
  DropDownState createState() => DropDownState();
}

class Company {
  int id;
  String name;

  Company(this.id, this.name);

  static List<Company> getCompanies() {
    return <Company>[
      Company(1, 'Apple'),
      Company(2, 'Google'),
      Company(3, 'Samsung'),
      Company(4, 'Sony'),
      Company(5, 'LG'),
    ];
  }
}

class DropDownState extends State<DropDown> {
  //
  List<Company> _companies = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  Company _selectedCompany;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<Company>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Company>> items = List();
    for (Company company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Company selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar:AppBar(
          title: Text("DropDown Button Example"),
        ),
        body: Container(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Select a company"),
                SizedBox(
                  height: 20.0,
                ),
                DropdownButton(
                  value: _selectedCompany,
                  items: _dropdownMenuItems,
                  onChanged: onChangeDropdownItem,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text('Selected: ${_selectedCompany.name}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



