import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leeway/models/dispatch.dart';
import 'package:leeway/models/truck.dart';
import 'package:leeway/models/user.dart';
import 'package:leeway/utils/validators.dart';
import 'package:leeway/services/user.dart';
import 'package:leeway/services/dispatchController.dart';
import 'package:leeway/models/driver.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';


class Register extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xFFF8FBFF),
            Color(0xFFFCFDFD),
          ])),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child:Align(child:Column(
            children: <Widget>[
              Padding(child:RegisterForm(_scaffoldKey),padding: EdgeInsets.all(50.0),)],mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center
          ),alignment: Alignment.center),
        )
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey;
  const RegisterForm(this._scaffoldKey,{Key key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _formWasEdited = false;
  final formatDate = new DateFormat.yMMMMd("en_US");
  final formatTime = new DateFormat.jm();
  User user;
  Dispatch dispatch;
  int _truck;
  String _driver;
  Validators validate;
  TextEditingController txt;


  _RegisterFormState() {
    dispatch= new Dispatch();
    validate = new Validators(_formWasEdited);
    txt=  new TextEditingController();

  }

  void showInSnackBar(String value) {
    widget._scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(value)
    ));
  }



  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if(_truck == null || _driver == null){
      _autoValidate = true; // Start validating on every change.
      showInSnackBar('Please select an option from the select fields.');
    }
    else if (!form.validate()) {
      _autoValidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      Provider.of<DispatchController>(context).add(dispatch);
      showInSnackBar('Registeration Complete');
      print(Provider.of<DispatchController>(context,listen: false).get(0).date);
      _reset(form);
    }
  }

  void _reset(FormState form){
    _driver = null;
    _truck = null;
    form.reset();
    txt.text = " ";


  }

  Future<bool> _warnUserAboutInvalidData() async {
    final FormState form = _formKey.currentState;
    if (form == null || !_formWasEdited || form.validate())
      return true;

    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: const Text('This form has errors'),
          content: const Text('Really leave this form?'),
          actions: <Widget> [
            new FlatButton(
              child: const Text('YES'),
              onPressed: () { Navigator.of(context).pop(true); },
            ),
            new FlatButton(
              child: const Text('NO'),
              onPressed: () { Navigator.of(context).pop(false); },
            ),
          ],
        );
      },
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserController>(context, listen: false).user;
    var dispatchController = Provider.of<DispatchController>(context,listen: false);
    return  Form(
      key: _formKey,
      autovalidate: _autoValidate,
      onWillPop: _warnUserAboutInvalidData,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child:TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Dispatch Officer',icon: Icon(Icons.perm_identity)
                ),
                initialValue: user.username,
                readOnly: true,
                maxLength: 50,
                onSaved: (String val)=> dispatch.officer = user.staffId,
              ),),
              const SizedBox(width: 30.0),
              Expanded(child:TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Telephone',icon: Icon(Icons.phone),hintText: "Tel",
                ),
                keyboardType: TextInputType.numberWithOptions(),
                readOnly: true,
                initialValue: user.telephoneNo.toString(),
                textCapitalization: TextCapitalization.words,
                maxLength: 11,
                textInputAction: TextInputAction.emergencyCall,
              ),),
            ],mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          const SizedBox(height: 16.0),
          Row(
            children: <Widget>[
              Flexible(child:Column(
                children: <Widget>[
                  Row(children:[ Icon(Icons.local_shipping),SizedBox(width: 15.0),Text("Driver",style:TextStyle(color:Colors.grey)),]),
                  Row(children:[SizedBox(width: 40.0),
                    Expanded(child:DropdownButton<String>(
                      items: dispatchController.getDrivers().map((Driver d){
                        return new DropdownMenuItem<String>(
                          value: d.telephoneNo.toString(),
                          child: Text("${d.staffID}"),
                        );
                      }).toList(),
                      value: _driver,
                      onChanged: (value) {
                        setState(() {
                          _driver = value;
                          dispatch.driver=value;
                        });
                        txt.text=value.toString();
                      },
                      hint: Text(
                        "Please select driver!",
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                      ),icon: Icon(Icons.drive_eta),isExpanded: true,
                    )
                    )
                  ])
                ],mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
              ),flex: 5),
              const SizedBox(width: 30.0),
              Flexible(child:TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Driver Telephone',icon: Icon(Icons.phone),hintText: "Tel",
                ),
                keyboardType: TextInputType.numberWithOptions(),
                textCapitalization: TextCapitalization.words,
                maxLength: 11,
                readOnly: true,
                textInputAction: TextInputAction.emergencyCall,controller: txt,
              ),flex: 5),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),

          const SizedBox(height: 16.0),
          Column(
            children: <Widget>[
              const SizedBox(height: 16.0),
       Row(children:[ Icon(Icons.local_shipping),SizedBox(width: 15.0),Text("Truck Number",style:TextStyle(color:Colors.grey)),]),
      Row(children:[SizedBox(width: 40.0),
    Expanded(child: DropdownButton<int>(
        items: dispatchController.getTrucks().map((Truck d){
          return DropdownMenuItem<int>(
            value: d.no,
            child: Text("${d.no} "),
          );
        }).toList(),
    value: _truck,
    onChanged: (value) {
          setState(() {
            _truck = value;
            dispatch.truckNo=value;
          });
    },

    hint: Text(
    "Please select the Truck number!",
    style: TextStyle(
    color: Colors.black87)),icon: Icon(Icons.format_list_numbered),isExpanded: true))
    ])],mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start),
          const SizedBox(height: 16.0),
          Row(
            children: <Widget>[
              Expanded(child:Column(children: <Widget>[
                Row(children:[ Icon(Icons.date_range),SizedBox(width: 15.0),Text("Date",style:TextStyle(color:Colors.grey)),]),
                Padding(child:DateTimeField(
                  format: formatDate,
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                  },
                  onSaved: (DateTime val)=> dispatch.date = val,validator: (DateTime value)=>validate.validateDateTime(value,errorMsg:"Please select date"),
                ),padding:EdgeInsets.only(left: 40.0))

              ],crossAxisAlignment: CrossAxisAlignment.start,)),
              const SizedBox(width: 30.0),
              Expanded(child:Column(children: <Widget>[
                Row(children:[ Icon(Icons.access_time),SizedBox(width: 15.0),Text("Time",style:TextStyle(color:Colors.grey)),]),
                Padding(child:DateTimeField(
                  format: formatTime,
                  onShowPicker: (context, currentValue) async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.convert(time);
                  },
                  onSaved: (DateTime val)=>dispatch.time = val,validator: (DateTime value)=>validate.validateDateTime(value,errorMsg:"Please select time"),
                ),padding: EdgeInsets.only(left: 40.0),)
              ],crossAxisAlignment: CrossAxisAlignment.start,)),
            ],mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          const SizedBox(height: 100.0),
          Row(
            children: <Widget>[
              RaisedButton(onPressed: ()=>_handleSubmitted(),child: Text("Register"),color:Color.fromRGBO(245, 246, 247, 1.0),highlightColor: Colors.white,hoverColor: Colors.black,textColor: Colors.black87,)
            ],
          ),
        ],mainAxisAlignment: MainAxisAlignment.start,
      ),
    );
  }

}



/*
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



class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Widget Body;
  Widget Registered = Register();
  Widget drop =  DropDown();

  @override
  void initState() {
    Body = Registered;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leeway Logistics >  Dispatch"),
      ),
      body: Body,
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child:Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.all(0),
          children: [
            UserAccountsDrawerHeader(
              accountEmail: Text("Lanre@Leewaylogisticsltd.com"),
              accountName: Text("Lanre Esan"),
              currentAccountPicture: CircleAvatar(
                child: Text("Admin"),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Dispatch"),
              onTap: (){},
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text("Categories"),
              onTap: (){
                setState(() {
                  Body = drop;
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.add_to_photos),
              title: Text("Add Items"),
              onTap: (){},
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("About Us"),
              onTap: (){},
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text("Share with Friends"),
              onTap: (){},
            ),
            ListTile(
              leading: Icon(Icons.rate_review),
              title: Text("Rate and Review"),
              onTap: (){},
            ),
            ListTile(
              leading: Icon(Icons.flag),
              title: Text("Privacy Policy"),
              onTap: (){},
            ),
          ],
        ),
      ),
    );
  }
}
*/

/*
https://wolfninja.herokuapp.com/graphql
https://tomcasted.herokuapp.com/graphql
https://tomcast.herokuapp.com/graphQL
https://misin-73e94.firebaseio.com/.json
https://tomisin-esan.herokuapp.com/
https://gracelandacademyportal.sch.ng/university/sign-in.php
https://thescionmagazineng.com
 https://misin-73e94.firebaseapp.com/tactics
 https://github.com/Tomison-E/Fantasy_footballTeam
 */