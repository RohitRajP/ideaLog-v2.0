import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../global.dart' as globals;

class ForgotPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ForgotPasswordPageState();
  }
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  var _response;
  String _userName;
  bool _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget _informMessage() {
    return Container(
      child: Text(
        "A temporary password will be sent to your email ID: ",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _getUsername() {
    return Container(
      child: TextField(
        maxLength: 20,
        onChanged: (value) {
          _userName = value;
        },
        decoration: InputDecoration(
            hintText: "Your Username",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
      ),
    );
  }

  Widget _submitBtn() {
    return Container(
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        color: Colors.indigo,
        textColor: Colors.white,
        padding: EdgeInsets.all(20.0),
        onPressed: () {
          if (_userName.length > 0) {
            setState(() {
              _isLoading = true;
              _updateProfilePOST();
            });
          } else {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              backgroundColor: Colors.orange,
              content: Text('Please check for empty fields 🧐'),
              duration: Duration(seconds: 3),
            ));
          }
        },
        child: (_isLoading == false)
            ? Text("Submit")
            : SizedBox(
                height: 30.0,
                width: 30.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
      ),
    );
  }

  Future<String> _updateProfilePOST() async {
    //print(_username.text);
    try {
      _response = await http.post(
          Uri.encodeFull(
              "http://rrjprojects.000webhostapp.com/api/forgotPassword.php"),
          body: {
            "userName": _userName.trim(),
          });
      _response = json.decode(_response.body);
      if (_response[0]['status'] == 1) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content:
              Text('Your recovery password has been sent to your email! 😃'),
          duration: Duration(seconds: 3),
        ));
      } else if (_response[0]['status'] == -1) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Couldn\'t find your account in my database 🙁'),
          duration: Duration(seconds: 3),
        ));
      }
    } catch (SocketException) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.orange,
        content: Text('Woah! Seems like a Network Error'),
        duration: Duration(seconds: 3),
      ));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.indigo,
            title: Text("Password Reset"),
          ),
          body: Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                  minWidth: MediaQuery.of(context).size.width),
              alignment: Alignment.center,
              child: Center(
                  child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(50.0),
                children: <Widget>[
                  _informMessage(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _getUsername(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _submitBtn()
                ],
              )))),
    );
  }
}
