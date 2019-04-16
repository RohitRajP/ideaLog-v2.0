import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../global.dart' as globals;

class QAskW extends StatefulWidget {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  QAskW(this._scaffoldKey);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _QAskWState();
  }
}

class _QAskWState extends State<QAskW> {
  TextEditingController _qNameControl = new TextEditingController();
  TextEditingController _qAnswerControl = new TextEditingController();
  bool _isUpdating = false;
  var _response;
  double _priorityValue = 1.0;
  String _qAnswer = "Yet to find answer";

  Future<String> _updateIdea() async {
    setState(() {
      _isUpdating = true;
    });
    String _qName = _qNameControl.text.toString();
    if (_qAnswerControl.text.length != 0) {
      _qAnswer = _qAnswerControl.text.trim();
    }
    _qName = _qName.replaceAll('\'', '\'\'');
    _qAnswer = _qAnswer.replaceAll('\'', '\'\'');
    try {
      _response = await http.post(
          Uri.encodeFull(
              "http://rrjprojects.000webhostapp.com/api/qCreate.php"),
          body: {
            "userId": globals.userId.toString(),
            "qName": _qName.trim(),
            "qAnswer": _qAnswer.trim(),
            "qPriority": _priorityValue.round().toString()
          });
      _response = json.decode(_response.body);
      if (_response[0]['status'] == '1') {
        setState(() {
          _isUpdating = false;
          widget._scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text('Question Created! 😃'),
            duration: Duration(seconds: 3),
          ));
          _qNameControl.text = "";
          _qAnswer = "Yet to find answer";
        });
      }
    } catch (FormatException) {
      setState(() {
        _isUpdating = false;
        widget._scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('An error occurred during updating 😥'),
          duration: Duration(seconds: 3),
        ));
      });
    } catch (SocketException) {
      widget._scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.orange,
        content: Text('Woah! Seems like a Network Error 😥'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  Widget _getQues() {
    return Container(
        child: TextFormField(
      maxLength: 200,
      controller: _qNameControl,
      decoration: InputDecoration(
          labelText: "Question?",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          hintText: "What is your question?"),
    ));
  }

  Widget _getAnswer() {
    // int maxLines = int.parse(globals.editqAnswer.length.toString());
    // maxLines = maxLines ~/ 30;
    return Container(
        child: TextFormField(
      maxLines: null,
      maxLength: 1500,
      controller: _qAnswerControl,
      decoration: InputDecoration(
          labelText: "Answer for question",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          hintText: "What must that be?"),
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
                ? Text("Create Question")
                : SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
            onPressed: (_isUpdating == false)
                ? () {
                    if (_qNameControl.text.length != 0) {
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
          _getQues(),
          SizedBox(
            height: 20.0,
          ),
          _getAnswer(),
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
