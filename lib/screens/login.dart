import 'package:flutter/material.dart';
import 'package:leeway/dashboard.dart';
import 'package:leeway/home_screen.dart';
import 'package:leeway/services/user.dart';
import 'package:provider/provider.dart';

import '../home.dart';
class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: Container(
        child: SizedBox(
       child:Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
    child: loginBody(context),
         margin: EdgeInsets.all(20.0)
       ),
          width: 500.0,
          height: 800.0,
        ),alignment: Alignment.center,
        decoration: BoxDecoration(image: DecorationImage(image:NetworkImage("assets/bg.png"),fit: BoxFit.cover)),
      )
    );
  }

   showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(value)
    ));
  }

  loginBody(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Flexible(child: loginHeader(),flex: 4), Flexible(child:loginFields(context),flex: 6)],
  );

  loginHeader() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      SizedBox(
        height: 20.0,
      ),
     Expanded(child: Image.network(
         "assets/icons/logo.png",width: 100.0,height: 100.0,
         fit: BoxFit.contain
     )),
      SizedBox(
        height: 30.0,
      ),
      Text(
        "Welcome to ${"Coastwise LTD Portal"}",
        style: TextStyle(fontWeight: FontWeight.w700,color: Colors.blue),
      ),
      SizedBox(
        height: 5.0,
      ),
      Text(
        "Sign in to continue",
        style: TextStyle(color: Colors.grey),
      ),
    ],
  );

  loginFields(BuildContext context) => Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
          child: TextField(
            maxLines: 1,
            decoration: InputDecoration(
              hintText: "Enter your username",
              labelText: "Username",
            ),
            autocorrect: false,
            controller: usernameController,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
          child: TextField(
            maxLines: 1,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Enter your password",
              labelText: "Password",
            ),
            autocorrect: false,
            controller: passwordController,
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
          width: double.infinity,
          child: RaisedButton(
            padding: EdgeInsets.all(12.0),
            shape: StadiumBorder(),
            child: Text(
              "SIGN IN",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue,
            onPressed: () {
             var test= Provider.of<UserController>(context).validateUser(usernameController.text, passwordController.text);
             test?Navigator.of(context).push(
                 MaterialPageRoute(builder: (context)=>Home())):Navigator.of(context).push(
                 MaterialPageRoute(builder: (context)=>Home()));//showInSnackBar("Invalid username or password");
             usernameController.text="";
             passwordController.text = "";
            },
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
      ],
    ),
  );
}
