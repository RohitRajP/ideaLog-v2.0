import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../global.dart' as globals;

class UserDetailsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UserDetailsPageState();
  }
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  bool _isLoadingDetails = true;
  var _response;
  List _userLst;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDetails();
  }

  Widget _loadingDetails() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(height: 10.0),
          Text("Fetching user details")
        ],
      ),
    );
  }

  Widget _uDetailsTiles() {
    return LiquidPullToRefresh(
        key: _refreshIndicatorKey,
        onRefresh: _getDetails,
        child: ListView.builder(
          itemBuilder: _tileBuilder,
          itemCount: _userLst.length,
        ));
  }

  Future<String> _getDetails() async {
    try {
      _response = await http.get(Uri.encodeFull(
          "http://rrjprojects.000webhostapp.com/api/getbat.php"));
      _response = json.decode(_response.body);
      //print(_response);
      if (_response[0]['userId'] != -1) {
        _userLst = _response;
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.orange,
          content: Text('Woah! Couldn\'t get any user details 😭'),
          duration: Duration(seconds: 3),
        ));
      }
    } catch (SocketException) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.orange,
        content: Text('Woah! Seems like a Network Error 😭'),
        duration: Duration(seconds: 3),
      ));
    }
    setState(() {
      _isLoadingDetails = false;
    });
  }

  Widget _tileBuilder(BuildContext context, int index) {
    return ListTile(
      leading: Icon(FontAwesomeIcons.user),
      title: Text(_userLst[index]['username']),
      subtitle: Text("Battery percentage: " + _userLst[index]['battper'] + "%"),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("User Details"),
        ),
        body: Container(
          child: (_isLoadingDetails == true)
              ? _loadingDetails()
              : _uDetailsTiles(),
        ),
      ),
    );
  }
}
