import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:advanced_share/advanced_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../global.dart' as globals;

class FriendsPageW extends StatefulWidget {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FriendsPageW(this._scaffoldKey);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FriendsPageState();
  }
}

class _FriendsPageState extends State<FriendsPageW> {
  TextEditingController _friendnameControl = new TextEditingController();
  var _response;
  bool _isLoadingExplore = true, _noContent = false, _noUserFound = false;
  List _ideasLst;
  String _friendName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<String> getFIdeas() async {
    try {
      _response = await http.get(Uri.encodeFull(
          "http://rrjprojects.000webhostapp.com/api/shareIdeasGet.php?username=" +
              _friendName));
      _response = json.decode(_response.body);
      //print(_response);
      if (_response[0]['sno'] != -1 && _response[0]['sno'] != 0) {
        setState(() {
          _ideasLst = _response;
          _isLoadingExplore = false;
        });
      } else if (_response[0]['sno'] == 0) {
        widget._scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.orange,
          content: Text(
              'Apologies! We aren\'t able to find the user in our database 🙁'),
          duration: Duration(seconds: 3),
        ));
        _friendName = "";
        setState(() {
          _isLoadingExplore = false;
        });
      } else if (_response[0]['sno'] == -1) {
        widget._scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.orange,
          content: Text(
              'Apologies! The user has not shared any ideas to public domain 🙁'),
          duration: Duration(seconds: 3),
        ));
        _friendName = "";
        setState(() {
          _isLoadingExplore = false;
        });
      }
    } catch (SocketException) {
      widget._scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.orange,
        content: Text('Woah! Seems like a Network Error 🙁'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  Widget _expansionTileBuilder(BuildContext context, int index) {
    int val = int.parse(_ideasLst[index]['ideaPriority']);
    if (val >= 8)
      globals.ideaTextColor = Colors.purple;
    else if (val >= 4 && val < 8)
      globals.ideaTextColor = Colors.green;
    else
      globals.ideaTextColor = Colors.indigo;
    return Column(
      children: <Widget>[
        ExpansionTile(
          leading: Icon(FontAwesomeIcons.lightbulb),
          title: Text(
            _ideasLst[index]['ideaName'],
            style: TextStyle(color: globals.ideaTextColor),
          ),
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10.0),
              child: Text(_ideasLst[index]['ideaDescription'].toString()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: Text(
                    "Priority: " + _ideasLst[index]['ideaPriority'].toString(),
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget _loadingIdeas() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(height: 10.0),
          Text("Fetching ideas")
        ],
      ),
    );
  }

  Widget _ideasExpansionTile() {
    return ListView.builder(
      itemBuilder: _expansionTileBuilder,
      itemCount: _ideasLst.length,
    );
  }

  Widget _friendnameTextBox() {
    return TextField(
      controller: _friendnameControl,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          hintText: "For eg. TommyGo or MrIdeaMan...",
          labelText: "Friend's Username"),
    );
  }

  Widget _friendnameSubmit() {
    return RaisedButton(
      padding: EdgeInsets.all(30.0),
      color: globals.primaryColor,
      colorBrightness: Brightness.dark,
      onPressed: () {
        if (_friendnameControl.text.length > 0) {
          setState(() {
            _friendName = _friendnameControl.text;
            // print(_friendName);
            _isLoadingExplore = true;
            getFIdeas();
          });
        } else {
          widget._scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Colors.orange,
            content: Text('Please enter a friend username 🙁'),
            duration: Duration(seconds: 3),
          ));
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Text("Get Shared Ideas"),
    );
  }

  Widget _enterFriendName() {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            _friendnameTextBox(),
            SizedBox(
              height: 20.0,
            ),
            _friendnameSubmit()
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        child: (_friendName.length == 0)
            ? _enterFriendName()
            : (_isLoadingExplore == true)
                ? _loadingIdeas()
                : _ideasExpansionTile());
  }
}
