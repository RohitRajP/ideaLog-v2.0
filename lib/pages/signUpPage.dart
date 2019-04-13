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
  TextEditingController _emailIdController = new TextEditingController();
  TextEditingController _passwordConfirmController =
      new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _userName, _name, _password, _passwordConfirm, _email;
  bool _isLoading = false;
  var _response;

  Widget _getUserName() {
    return TextField(
      controller: _userNameController,
      maxLength: 10,
      onChanged: (String value) {
        _userName = value;
      },
      decoration: InputDecoration(
          labelText: "Username",
          helperText: "Uniquely identifies you amongst innovators",
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
          helperText: "Include numbers and special characters",
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
          helperText: "It must be same as password",
          hintText: "Please enter one more time",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }

  Widget _getEmailId() {
    return TextField(
      maxLength: 50,
      controller: _emailIdController,
      onChanged: (String value) {
        _email = value;
      },
      decoration: InputDecoration(
          labelText: "Your email id",
          helperText: "For password recovery purposes",
          hintText: "Your current email Id",
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
          helperText: "Helps humans identify you",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }

  Widget _signUpBtn() {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            padding: EdgeInsets.all(20.0),
            elevation: 5.0,
            color: Colors.indigo,
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
        _userNameController.text.length > 0 &&
        _passwordConfirmController.text.length > 0 &&
        _emailIdController.text.length > 0) {
      if (_password.compareTo(_passwordConfirm) == 0) {
        setState(() {
          _isLoading = true;
        });
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
            "name": _name.trim(),
            "email": _email.trim(),
          });
      _response = json.decode(_response.body);
      if (_response[0]['status'] == '1') {
        _nameController.text = "";
        _passwordController.text = "";
        _passwordConfirmController.text = "";
        _nameController.text = "";
        _userNameController.text = "";
        setState(() {
          _isLoading = false;
        });
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
    } catch (SocketException) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.orange,
        content: Text('Woah! Seems like a Network Error'),
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
          backgroundColor: Colors.indigo,
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
                  height: 20.0,
                ),
                _getPassword(),
                SizedBox(
                  height: 20.0,
                ),
                _getPasswordConfirm(),
                SizedBox(
                  height: 20.0,
                ),
                _getEmailId(),
                SizedBox(
                  height: 20.0,
                ),
                _getName(),
                SizedBox(
                  height: 20.0,
                ),
                _signUpBtn()
              ],
            ),
          ),
        ));
  }
}
