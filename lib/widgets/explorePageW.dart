import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:advanced_share/advanced_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:battery/battery.dart';

import '../global.dart' as globals;

class ExplorePageW extends StatefulWidget {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ExplorePageW(this._scaffoldKey);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ExplorePageState();
  }
}

class _ExplorePageState extends State<ExplorePageW> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  var _response;
  bool _isLoadingExplore = true, _noContent = false;
  List _ideasLst;
  var battery = Battery();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getIdeas();
  }

  Future<String> getIdeas() async {
    _isLoadingExplore = true;
    var _batt = await battery.batteryLevel;
    try {
      _response = await http.get(Uri.encodeFull(
          "http://rrjprojects.000webhostapp.com/api/ideasGet.php?userId=" +
              globals.userId +
              "&battPercent=" +
              _batt.toString()));
      _response = json.decode(_response.body);
      //print(_response);
      if (_response[0]['sno'] != -1) {
        setState(() {
          _ideasLst = _response;
          _isLoadingExplore = false;
        });
      } else {
        setState(() {
          _isLoadingExplore = false;
          _noContent = true;
        });
      }
    } catch (SocketException) {
      // widget._scaffoldKey.currentState.showSnackBar(SnackBar(
      //   backgroundColor: Colors.orange,
      //   content: Text('Woah! Seems like a Network Error 🙁'),
      //   duration: Duration(seconds: 3),
      // ));
    }
  }

  void _moveToEditIdea(String sno, String name, String desc, String priority) {
    globals.editIdeaSno = sno;
    globals.editIdeaName = name;
    globals.editIdeaDesc = desc;
    globals.editIdeaPriority = priority;
    Navigator.pushNamed(context, '/editIdea').whenComplete(getIdeas);
  }

  void _updateShare(String value, String sno, int index) async {
    widget._scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: globals.primaryColor,
      content: Row(
        children: <Widget>[
          SizedBox(
            height: 20.0,
            width: 20.0,
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Text('Updating sharing details 😃')
        ],
      ),
    ));
    value = (value == '0') ? '1' : '0';
    try {
      _response = await http.post(
          Uri.encodeFull(
              "http://rrjprojects.000webhostapp.com/api/updateShare.php"),
          body: {"sno": sno, "share": value});
      _response = json.decode(_response.body);
      // print(_response);
      if (_response[0]['status'] == '1') {
        setState(() {
          widget._scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text('Yay! Sharing details updated 😃'),
            duration: Duration(seconds: 3),
          ));
          _ideasLst[index]['share'] = value;
        });
      } else {
        setState(() {
          widget._scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Colors.orange,
            content: Text('Woah! Could not update share details 🙁'),
            duration: Duration(seconds: 3),
          ));
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
    // switch (index % 4) {
    //   case 0:
    //     globals.ideaTextColor = Colors.green;
    //     break;
    //   case 1:
    //     globals.ideaTextColor = Colors.orange;
    //     break;
    //   case 2:
    //     globals.ideaTextColor = Colors.purple;
    //     break;
    //   case 3:
    //     globals.ideaTextColor = Colors.red;
    //     break;
    //   case 4:
    //     globals.ideaTextColor = Colors.teal;
    //     break;
    // }
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                _ideasLst[index]['ideaName'],
                style: TextStyle(color: globals.ideaTextColor),
              ),
              Container(
                child: (_ideasLst[index]['share'].toString() == '1')
                    ? Text(
                        "Public",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 12.0,
                            fontFamily: 'TimeBurner'),
                      )
                    : Text(
                        "Private",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontFamily: 'TimeBurner'),
                      ),
              )
            ],
          ),
          // Container(
          //   child: (_ideasLst[index]['share'].toString() == '1')
          //       ? Icon(FontAwesomeIcons.globeAsia, color: Colors.green)
          //       : Icon(
          //           FontAwesomeIcons.userSecret,
          //           color: Colors.black,
          //         ),
          // )

          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10.0),
              child: Text(_ideasLst[index]['ideaDescription'].toString()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: Text(
                    "Priority: " + _ideasLst[index]['ideaPriority'].toString(),
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
                Container(
                  child: ButtonBar(
                    children: <Widget>[
                      FlatButton.icon(
                        icon: Icon(FontAwesomeIcons.whatsapp),
                        onPressed: () {
                          AdvancedShare.whatsapp(
                              msg: "*" +
                                  _ideasLst[index]['ideaName'] +
                                  "*" +
                                  " : " +
                                  _ideasLst[index]['ideaDescription']);
                        },
                        label: Text("Share"),
                      ),
                      FlatButton.icon(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _moveToEditIdea(
                              _ideasLst[index]['sno'],
                              _ideasLst[index]['ideaName'],
                              _ideasLst[index]['ideaDescription'],
                              _ideasLst[index]['ideaPriority']);
                        },
                        label: Text("Edit"),
                      )
                    ],
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: AnimatedContainer(
                    duration: Duration(seconds: 1),
                    color: (_ideasLst[index]['share'].toString() == '1')
                        ? Colors.green
                        : Colors.blueGrey,
                    child: FlatButton(
                      colorBrightness: Brightness.dark,
                      color: Colors.transparent,
                      child: (_ideasLst[index]['share'].toString() == '1')
                          ? Text("Shared to Public (Click to Privatize)")
                          : Text("Kept Private (Click to Publish)"),
                      onPressed: () {
                        _updateShare(_ideasLst[index]['share'].toString(),
                            _ideasLst[index]['sno'].toString(), index);
                      },
                    ),
                  ),
                )
              ],
            )
          ],
        ),
        Container(
          margin: (index == _ideasLst.length - 1)
              ? EdgeInsets.only(top: 10.0, bottom: 30.0)
              : null,
          child: (index == _ideasLst.length - 1)
              ? Text(
                  "Pull down to refresh feed",
                  style: TextStyle(color: Colors.grey),
                )
              : null,
        )
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
          Text("Fetching your ideas")
        ],
      ),
    );
  }

  Widget _ideasExpansionTile() {
    return LiquidPullToRefresh(
        key: _refreshIndicatorKey,
        onRefresh: getIdeas,
        child: ListView.builder(
          itemBuilder: _expansionTileBuilder,
          itemCount: _ideasLst.length,
        ));
  }

  Widget _noContentView() {
    return Container(
        margin: EdgeInsets.all(20.0),
        child: Center(
            child: Center(
          child: Text(
            "😃 " +
                globals.welMessage[0] +
                " 😃" +
                '\n' +
                globals.welMessage[1] +
                " 😉" +
                '\n' +
                globals.welMessage[2] +
                " 👉",
            textAlign: TextAlign.center,
          ),
        )));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: (_isLoadingExplore == true)
          ? _loadingIdeas()
          : (_noContent == false) ? _ideasExpansionTile() : _noContentView(),
    );
  }
}
