import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../global.dart' as globals;

class EditIdeaPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditIdeaPageState();
  }
}

class _EditIdeaPageState extends State<EditIdeaPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _ideaNameControl = new TextEditingController();
  TextEditingController _ideaDescControl = new TextEditingController();
  double _priorityValue = 0.0;
  bool _isUpdating = false;
  var _response;

  void initState() {
    _ideaNameControl.text = globals.editIdeaName;
    _ideaDescControl.text = globals.editIdeaDesc;
    _priorityValue = double.parse(globals.editIdeaPriority);
  }

  Future<String> _updateIdea() async {
    _isUpdating = true;
    _response = await http.post(
        Uri.encodeFull(
            "http://rrjprojects.000webhostapp.com/api/ideasUpdate.php"),
        body: {
          "sno": globals.editIdeaSno,
          "ideaName": _ideaNameControl.text.toString(),
          "ideaDesc": _ideaDescControl.text.toString(),
          "ideaPriority": _priorityValue.round().toString()
        });
    _response = json.decode(_response.body);
    if (_response[0]['status'] == "1") {
      setState(() {
        _isUpdating = false;
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text('Idea Detail Updated'),
          duration: Duration(seconds: 3),
        ));
      });
    } else {
      setState(() {
        _isUpdating = false;
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('An error occurred during updating'),
          duration: Duration(seconds: 3),
        ));
      });
    }
  }

  Widget _getTitle() {
    return Container(
        child: TextFormField(
      controller: _ideaNameControl,
      decoration: InputDecoration(
          labelText: "Idea Title",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          hintText: globals.editIdeaName),
    ));
  }

  Widget _getDesc() {
    // int maxLines = int.parse(globals.editIdeaDesc.length.toString());
    // maxLines = maxLines ~/ 30;
    return Container(
        child: TextFormField(
      controller: _ideaDescControl,
      maxLines: null,
      decoration: InputDecoration(
          labelText: "Idea Description",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          hintText: globals.editIdeaDesc),
    ));
  }

  Widget _getPriority() {
    return Container(
        child: Slider(
      value: _priorityValue,
      min: 1,
      max: 10,
      divisions: 9,
      label: _priorityValue.toString(),
      onChanged: (double value) {
        setState(() {
          _priorityValue = value;
        });
      },
    ));
  }

  void _showConfirmDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            title: Text("Are you sure?"),
            content:
                Text("This action will remove the idea from the explore list"),
            actions: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                textColor: Colors.white,
                color: Colors.green,
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                textColor: Colors.white,
                color: Colors.red,
                child: Text("Confirm"),
                onPressed: () {
                  _deleteIdeaConfirm();
                },
              )
            ],
          );
        });
  }

  Widget _deleteIdeaBtn() {
    return Row(
      children: <Widget>[
        Expanded(
          child: FlatButton.icon(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            color: Colors.red,
            colorBrightness: Brightness.dark,
            icon: Icon(Icons.delete),
            label: Text("Delete Idea"),
            onPressed: () {
              _showConfirmDialog();
            },
          ),
        )
      ],
    );
  }

  Future<String> _deleteIdeaConfirm() async {
    setState(() {
      _isUpdating = true;
    });
    _response = await http.post(
        Uri.encodeFull(
            "http://rrjprojects.000webhostapp.com/api/ideaDelete.php"),
        body: {
          "sno": globals.editIdeaSno,
        });
    _response = json.decode(_response.body);
    if (_response[0]['status'] == "1") {
      setState(() {
        _isUpdating = false;
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/explorePage', (Route<dynamic> route) => false);
      });
    } else {
      setState(() {
        _isUpdating = false;
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('An error occurred during deleting'),
          duration: Duration(seconds: 3),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (_ideaNameControl.text.length != 0 &&
                    _ideaDescControl.text.length != 0) {
                  _updateIdea();
                } else {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    backgroundColor: Colors.orange,
                    content: Text('Please check for empty fields'),
                    duration: Duration(seconds: 3),
                  ));
                }
              },
              child: (_isUpdating == false)
                  ? Icon(Icons.check)
                  : CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
              backgroundColor: Colors.green,
            ),
            appBar: AppBar(
              title: Text(globals.editIdeaName),
            ),
            body: Container(
              margin: EdgeInsets.all(20.0),
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  _getTitle(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _getDesc(),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    "Priority: " + _priorityValue.toString(),
                    style: TextStyle(fontSize: 18.0, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  _getPriority(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _deleteIdeaBtn()
                ],
              ),
            )));
  }
}