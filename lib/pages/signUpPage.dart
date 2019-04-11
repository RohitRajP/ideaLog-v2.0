import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class SignUpPage extends StatefulWidget {
  Function reloadMain;
  SignUpPage(this.reloadMain);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignUpPageState();
  }
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _passwordConfirmController =
      new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _userName, _name, _password, _passwordConfirm;
  bool _isLoading = false;
  var _response;

  Widget _getUserName() {
    return TextField(
      controller: _userNameController,
      maxLength: 20,
      onChanged: (String value) {
        _userName = value;
      },
      decoration: InputDecoration(
          labelText: "Username",
          hintText: "Your unique username",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }

  Widget _getPassword() {
    return TextField(
      maxLength: 20,
      controller: _passwordController,
      onChanged: (String value) {
        _password = value;
      },
      obscureText: true,
      decoration: InputDecoration(
          labelText: "Password",
          hintText: "Your secure password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }

  Widget _getPasswordConfirm() {
    return TextField(
      maxLength: 20,
      controller: _passwordConfirmController,
      onChanged: (String value) {
        _passwordConfirm = value;
      },
      obscureText: true,
      decoration: InputDecoration(
          labelText: "Password Confirmation",
          hintText: "Please enter one more time",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }

  Widget _getName() {
    return TextField(
      maxLength: 20,
      controller: _nameController,
      onChanged: (String value) {
        _name = value;
      },
      decoration: InputDecoration(
          labelText: "Your name",
          hintText: "What do I call you?",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }

  Widget _signUpBtn() {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            elevation: 5.0,
            color: Colors.green,
            textColor: Colors.white,
            colorBrightness: Brightness.light,
            onPressed: () {
              _processSignIn();
            },
            child: (_isLoading != true)
                ? Text("Sign Up")
                : SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
        )
      ],
    );
  }

  void _processSignIn() {
    if (_nameController.text.length > 0 &&
        _passwordController.text.length > 0 &&
        _nameController.text.length > 0 &&
        _passwordConfirm.length > 0) {
      if (_password.compareTo(_passwordConfirm) == 0) {
        _registerUser();
      } else {
        _passwordController.clear();
        _passwordConfirmController.clear();
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.orange,
          content: Text('Oops! Passwords don\'t match 😯'),
          duration: Duration(seconds: 3),
        ));
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.orange,
        content: Text('Please check for empty fields 😮'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  Future<String> _registerUser() async {
    //print(_username.text);
    try {
      _response = await http.post(
          Uri.encodeFull(
              "http://rrjprojects.000webhostapp.com/api/createUser.php"),
          body: {
            "username": _userName.trim(),
            "passkey": _password.trim(),
            "name": _name.trim()
          });
      _response = json.decode(_response.body);
      if (_response[0]['status'] == '1') {
        _nameController.text = "";
        _passwordController.text = "";
        _passwordConfirmController.text = "";
        _nameController.text = "";
        _userNameController.text = "";
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text('Welcome to the club! Proceed to login 😃'),
          duration: Duration(seconds: 3),
        ));
      }
    } catch (FormatException) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text('Apologies! Username already taken 🤔'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text("Sign Up"),
        ),
        body: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(30.0),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                _getUserName(),
                SizedBox(
                  height: 10.0,
                ),
                _getPassword(),
                SizedBox(
                  height: 10.0,
                ),
                _getPasswordConfirm(),
                SizedBox(
                  height: 10.0,
                ),
                _getName(),
                SizedBox(
                  height: 10.0,
                ),
                _signUpBtn()
              ],
            ),
          ),
        ));
  }
}
