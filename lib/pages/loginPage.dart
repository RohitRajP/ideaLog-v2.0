import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../global.dart' as globals;

class LoginPage extends StatefulWidget {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  LoginPage(this._scaffoldKey);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _username = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  bool _isLoading = false, _continueLogin = false;
  var _response;

  Future<String> _auth() async {
    _response = await http.post(
        Uri.encodeFull(
            "http://rrjprojects.000webhostapp.com/api/authentication.php"),
        body: {
          "username": _username.text.trim(),
          "passkey": _password.text.trim()
        });
    _response = json.decode(_response.body);
    if (_response[0]['authstatus'] == '0') {
      globals.userName = _response[0]['name'];
      globals.userId = _response[0]['userId'];
      globals.welMessage = _response[0]['welMessage'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userId", globals.userId);
      prefs.setString("userName", globals.userName);
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/explorePage', (Route<dynamic> route) => false);
    } else if (_response[0]['authstatus'] == '2') {
      widget._scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text('Please check your username'),
        duration: Duration(seconds: 3),
      ));
      _resetPage(0);
    } else if (_response[0]['authstatus'] == '1') {
      widget._scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.orange,
        content: Text('Please check your password'),
        duration: Duration(seconds: 3),
      ));
      _resetPage(1);
    }
  }

  void _resetPage(int resetLevel) {
    setState(() {
      _isLoading = false;
      if (resetLevel == 0) {
        _username.clear();
        _password.clear();
      } else if (resetLevel == 1) {
        _password.clear();
      }
    });
  }

  Widget _userNameTextField() {
    return TextField(
      controller: _username,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          hintText: "Username"),
    );
  }

  Widget _passwordTextField() {
    return TextField(
      controller: _password,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          hintText: "Password"),
      obscureText: true,
    );
  }

  Widget _proceedBtn() {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            elevation: 5.0,
            color: Colors.white,
            colorBrightness: Brightness.light,
            onPressed: () {
              setState(() {
                _isLoading = true;
                _auth();
              });
            },
            child: (_isLoading == false)
                ? Text("Proceed")
                : SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(),
                  ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
          ),
        )
      ],
    );
  }

  Widget _signUpBtn() {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            elevation: 5.0,
            color: Colors.white,
            colorBrightness: Brightness.light,
            onPressed: () {},
            child: Text("Sign Up"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
          ),
        )
      ],
    );
  }

  Widget _loginBox() {
    return Column(
      children: <Widget>[
        Container(
          child: Text(
            "Log In",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30.0,
                color: Colors.indigo,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 40.0),
        _userNameTextField(),
        SizedBox(
          height: 20.0,
        ),
        _passwordTextField(),
        SizedBox(
          height: 20.0,
        ),
        _proceedBtn(),
        // SizedBox(
        //   height: 2.0,
        // ),
        // _signUpBtn()
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (globals.userId != null) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/explorePage', (Route<dynamic> route) => false);
    } else {
      setState(() {
        _continueLogin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (_continueLogin == true)
        ? Container(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
                minWidth: MediaQuery.of(context).size.width),
            alignment: Alignment.center,
            child: Center(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(50.0),
                children: <Widget>[
                  Container(
                    child: _loginBox(),
                  ),
                ],
              ),
            ))
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
