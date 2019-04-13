import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './pages/loginPage.dart';
import './pages/dashPage.dart';
import './pages/editIdeaPage.dart';
import './pages/signUpPage.dart';
import './pages/colorPickerPage.dart';
import './global.dart' as globals;
import './pages/profilePage.dart';
import './pages/forgotPasswordPage.dart';

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

  void reloadPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      routes: {
        '/explorePage': (BuildContext context) => DashPage(),
        '/editIdea': (BuildContext context) => EditIdeaPage(),
        '/loginPage': (BuildContext context) => MyApp(),
        '/signUpPage': (BuildContext context) => SignUpPage(reloadPage),
        '/appSettingsPage': (BuildContext context) =>
            ColorPickerPage(reloadPage),
        '/profilePage': (BuildContext context) => ProfilePage(),
        '/forgotPasswordPage': (BuildContext context) => ForgotPasswordPage()
      },
      theme: ThemeData(primarySwatch: globals.primaryColor),
      home: SafeArea(
        child: Scaffold(
            key: _scaffoldKey, body: LoginPage(_scaffoldKey, reloadPage)),
      ),
    );
  }
}
