import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:advanced_share/advanced_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:battery/battery.dart';

import '../global.dart' as globals;

class QAskedW extends StatefulWidget {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  QAskedW(this._scaffoldKey);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _QAskedWState();
  }
}

class _QAskedWState extends State<QAskedW> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  var _response;
  bool _isLoadingQues = true, _noContent = false;
  List _quesLst;
  var battery = Battery();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getIdeas();
  }

  Future<String> getIdeas() async {
    _isLoadingQues = true;
    var _batt = await battery.batteryLevel;
    try {
      _response = await http.get(Uri.encodeFull(
          "https://idealogrestapi.000webhostapp.com/api/qGet.php?userId=" +
              globals.userId +
              "&battPercent=" +
              _batt.toString()));
      _response = json.decode(_response.body);
      //print(_response);
      if (_response[0]['sno'] != -1) {
        setState(() {
          _quesLst = _response;
          _isLoadingQues = false;
        });
      } else {
        setState(() {
          _isLoadingQues = false;
          _noContent = true;
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

  void _moveToEditIdea(String sno, String name, String desc, String priority) {
    globals.editIdeaSno = sno;
    globals.editIdeaName = name;
    globals.editIdeaDesc = desc;
    globals.editIdeaPriority = priority;
    Navigator.pushNamed(context, '/questionEdit').whenComplete(getIdeas);
  }

  Widget _expansionTileBuilder(BuildContext context, int index) {
    int val = int.parse(_quesLst[index]['qPriority']);
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
            _quesLst[index]['qName'],
            style: TextStyle(color: globals.ideaTextColor),
          ),
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10.0),
              child: Text(_quesLst[index]['qAnswer'].toString()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: Text(
                    "Priority: " + _quesLst[index]['qPriority'].toString(),
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
                                  _quesLst[index]['qName'] +
                                  "* : " +
                                  _quesLst[index]['qAnswer']);
                        },
                        label: Text("Share"),
                      ),
                      FlatButton.icon(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _moveToEditIdea(
                              _quesLst[index]['sno'],
                              _quesLst[index]['qName'],
                              _quesLst[index]['qAnswer'],
                              _quesLst[index]['qPriority']);
                        },
                        label: Text("Edit"),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
        Container(
          margin: (index == _quesLst.length - 1)
              ? EdgeInsets.only(top: 15.0, bottom: 30.0)
              : null,
          child: (index == _quesLst.length - 1)
              ? Text(
                  "Pull down to refresh feed",
                  style: TextStyle(color: Colors.grey),
                )
              : null,
        )
      ],
    );
  }

  Widget _loadingQues() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(height: 10.0),
          Text("Fetching your questions")
        ],
      ),
    );
  }

  Widget _quesExpansionTile() {
    return LiquidPullToRefresh(
        key: _refreshIndicatorKey,
        onRefresh: getIdeas,
        child: ListView.builder(
          itemBuilder: _expansionTileBuilder,
          itemCount: _quesLst.length,
        ));
  }

  Widget _noContentView() {
    return Container(
        padding: EdgeInsets.all(30.0),
        child: Center(
            child: Center(
          child: Text(
              "😃 " +
                  globals.qWelMessage[0] +
                  " 😃" +
                  '\n' +
                  globals.qWelMessage[1] +
                  " 😊\n" +
                  globals.qWelMessage[2] +
                  " 👉",
              textAlign: TextAlign.center),
        )));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: (_isLoadingQues == true)
          ? _loadingQues()
          : (_noContent == false) ? _quesExpansionTile() : _noContentView(),
    );
  }
}
