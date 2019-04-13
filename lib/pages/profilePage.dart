import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../global.dart' as globals;

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordConfirmController =
      new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false,
      _passwordNotVisible = true,
      _passwordNotVisible2 = true;
  var _response;

  Widget _getUserName() {
    return TextField(
      controller: _userNameController,
      maxLength: 20,
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
      obscureText: _passwordNotVisible,
      decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(Icons.remove_red_eye),
            onPressed: () {
              setState(() {
                _passwordNotVisible = !_passwordNotVisible;
              });
            },
          ),
          labelText: "Password",
          hintText: "Your secure password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }

  Widget _getPasswordConfirm() {
    return TextField(
      maxLength: 20,
      controller: _passwordConfirmController,
      obscureText: _passwordNotVisible2,
      decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(Icons.remove_red_eye),
            onPressed: () {
              setState(() {
                _passwordNotVisible2 = !_passwordNotVisible2;
              });
            },
          ),
          labelText: "Password Confirmation",
          hintText: "Please enter one more time",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }

  Widget _getEmailID() {
    return TextField(
      maxLength: 50,
      controller: _emailController,
      decoration: InputDecoration(
          labelText: "Your email ID",
          hintText: "Your current email Id",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }

  Widget _getName() {
    return TextField(
      maxLength: 20,
      controller: _nameController,
      decoration: InputDecoration(
          labelText: "Your name",
          hintText: "What do I call you?",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }

  Widget _updateBtn() {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            padding: EdgeInsets.all(20.0),
            elevation: 5.0,
            color: globals.primaryColor,
            textColor: Colors.white,
            colorBrightness: Brightness.light,
            onPressed: () {
              _processUpdate();
            },
            child: (_isLoading != true)
                ? Text("Update profile")
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

  void _processUpdate() {
    if (_nameController.text.length > 0 &&
        _passwordController.text.length > 0 &&
        _userNameController.text.length > 0 &&
        _passwordConfirmController.text.length > 0 &&
        _emailController.text.length > 0) {
      if (_passwordController.text.compareTo(_passwordConfirmController.text) ==
          0) {
        setState(() {
          _isLoading = true;
          _updateProfilePOST();
        });
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

  Future<String> _updateProfilePOST() async {
    //print(_username.text);
    try {
      _response = await http.post(
          Uri.encodeFull(
              "http://rrjprojects.000webhostapp.com/api/updateUserInfo.php"),
          body: {
            "username": _userNameController.text.trim(),
            "passkey": _passwordController.text.trim(),
            "userName": _nameController.text.trim(),
            "emailID": _emailController.text.trim(),
            "userId": globals.userId
          });
      _response = json.decode(_response.body);
      if (_response[0]['status'] == '1') {
        _passwordConfirmController.text = "";
        globals.accUserName = _userNameController.text;
        globals.userName = _nameController.text;
        globals.userPassword = _passwordController.text;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("accUserName", globals.accUserName);
        prefs.setString("userPassword", globals.userPassword);
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text('Your profile has been updated! 😃'),
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
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userNameController.text = globals.accUserName;
    _nameController.text = globals.userName;
    _passwordController.text = globals.userPassword;
    _emailController.text = globals.userEmail;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: globals.primaryColor,
          title: Text("Profile"),
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
                _getEmailID(),
                SizedBox(
                  height: 10.0,
                ),
                _getName(),
                SizedBox(
                  height: 10.0,
                ),
                _updateBtn()
              ],
            ),
          ),
        ));
  }
}
