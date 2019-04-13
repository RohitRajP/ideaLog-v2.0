import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:advanced_share/advanced_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getIdeas();
  }

  Future<String> _getIdeas() async {
    _isLoadingExplore = true;
    try {
      _response = await http.get(Uri.encodeFull(
          "http://rrjprojects.000webhostapp.com/api/ideasGet.php?userId=" +
              globals.userId));
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
      widget._scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.orange,
        content: Text('Woah! Seems like a Network Error'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  void _moveToEditIdea(String sno, String name, String desc, String priority) {
    globals.editIdeaSno = sno;
    globals.editIdeaName = name;
    globals.editIdeaDesc = desc;
    globals.editIdeaPriority = priority;
    Navigator.pushNamed(context, '/editIdea');
  }

  Widget _expansionTileBuilder(BuildContext context, int index) {
    return Column(
      children: <Widget>[
        ExpansionTile(
          leading: Icon(FontAwesomeIcons.lightbulb),
          title: Text(
            _ideasLst[index]['ideaName'],
          ),
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
        onRefresh: _getIdeas,
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
          child: Text(globals.welMessage, textAlign: TextAlign.center),
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
