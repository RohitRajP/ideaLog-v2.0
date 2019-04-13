import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../global.dart' as globals;

class CreatePageW extends StatefulWidget {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  CreatePageW(this._scaffoldKey);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CreatePageWState();
  }
}

class _CreatePageWState extends State<CreatePageW> {
  TextEditingController _ideaNameControl = new TextEditingController();
  TextEditingController _ideaDescControl = new TextEditingController();
  bool _isUpdating = false;
  var _response;
  double _priorityValue = 1.0;

  Future<String> _updateIdea() async {
    setState(() {
      _isUpdating = true;
    });
    String _ideaName = _ideaNameControl.text.toString();
    String _ideaDesc = _ideaDescControl.text.toString();
    _ideaName = _ideaName.replaceAll('\'', '\'\'');
    _ideaDesc = _ideaDesc.replaceAll('\'', '\'\'');
    try {
      _response = await http.post(
          Uri.encodeFull(
              "http://rrjprojects.000webhostapp.com/api/ideaCreate.php"),
          body: {
            "userId": globals.userId.toString(),
            "ideaName": _ideaName.trim(),
            "ideaDesc": _ideaDesc.trim(),
            "ideaPriority": _priorityValue.round().toString()
          });
      _response = json.decode(_response.body);
      if (_response[0]['status'] == '1') {
        setState(() {
          _isUpdating = false;
          widget._scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text('Idea Created!'),
            duration: Duration(seconds: 3),
          ));
          _ideaNameControl.text = "";
          _ideaDescControl.text = "";
        });
      }
    } catch (FormatException) {
      setState(() {
        _isUpdating = false;
        widget._scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('An error occurred during updating'),
          duration: Duration(seconds: 3),
        ));
      });
    } catch (SocketException) {
      widget._scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.orange,
        content: Text('Woah! Seems like a Network Error'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  Widget _getTitle() {
    return Container(
        child: TextFormField(
      maxLength: 20,
      controller: _ideaNameControl,
      decoration: InputDecoration(
          labelText: "Idea Title",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          hintText: "Name the next revolution"),
    ));
  }

  Widget _getDesc() {
    // int maxLines = int.parse(globals.editIdeaDesc.length.toString());
    // maxLines = maxLines ~/ 30;
    return Container(
        child: TextFormField(
      controller: _ideaDescControl,
      maxLines: null,
      maxLength: 1500,
      decoration: InputDecoration(
          labelText: "Idea Description",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          hintText: "Make it short and sweet"),
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

  Widget _createIdeaBtn() {
    return Row(
      children: <Widget>[
        Expanded(
          child: FlatButton.icon(
            padding: EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            color: globals.primaryColor,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.white,
            colorBrightness: Brightness.dark,
            icon: Icon(Icons.lightbulb_outline),
            label: (_isUpdating == false)
                ? Text("Create Idea")
                : SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
            onPressed: (_isUpdating == false)
                ? () {
                    if (_ideaNameControl.text.length != 0 &&
                        _ideaDescControl.text.length != 0) {
                      _updateIdea();
                    } else {
                      widget._scaffoldKey.currentState.showSnackBar(SnackBar(
                        backgroundColor: Colors.orange,
                        content: Text('Please check for empty fields 😥'),
                        duration: Duration(seconds: 3),
                      ));
                    }
                  }
                : null,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
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
            height: 20.0,
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
          _createIdeaBtn()
        ],
      ),
    );
  }
}
