import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './pages/loginPage.dart';
import './pages/dashPage.dart';
import './pages/editIdeaPage.dart';
import './global.dart' as globals;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _autoLoginCheck();
  }

  void _autoLoginCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String temp = prefs.getString("userId");
    print(temp);
    if (temp != null) {
      globals.userId = temp;
      globals.userName = prefs.getString("userName");
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      routes: {
        '/explorePage': (BuildContext context) => DashPage(),
        '/editIdea': (BuildContext context) => EditIdeaPage(),
        '/loginPage': (BuildContext context) => MyApp()
      },
      theme: ThemeData(
          primaryColor: Colors.indigo, accentColor: Colors.indigoAccent),
      home: SafeArea(
        child: Scaffold(key: _scaffoldKey, body: LoginPage(_scaffoldKey)),
      ),
    );
  }
}