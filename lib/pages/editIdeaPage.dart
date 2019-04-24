import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
//import 'package:speech_recognition/speech_recognition.dart';

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
  //SpeechRecognition _speechRecognition;
  double _priorityValue = 0.0;
  bool _isUpdating = false,
      _srIsAvailable = false,
      _srIsListening = false,
      _recStart = false;
  var _response;

  void initState() {
    _ideaNameControl.text = globals.editIdeaName;
    _ideaDescControl.text = globals.editIdeaDesc;
    _priorityValue = double.parse(globals.editIdeaPriority);
    //_initSpeechRecognizer();
  }

  // void _initSpeechRecognizer() {
  //   _speechRecognition = SpeechRecognition();
  //   _speechRecognition.setAvailabilityHandler(
  //       (bool result) => setState(() => _srIsAvailable = result));
  //   _speechRecognition.setRecognitionStartedHandler(() {
  //     setState(() {
  //       _srIsListening = true;
  //     });
  //   });
  //   _speechRecognition
  //       .setRecognitionResultHandler((String text) => setState(() {
  //             globals.editIdeaDesc += text;
  //             _ideaDescControl.text = globals.editIdeaDesc;
  //           }));

  //   _speechRecognition.setRecognitionCompleteHandler(
  //       () => setState(() => _srIsListening = false));
  //   _speechRecognition
  //       .activate()
  //       .then((res) => setState(() => _srIsAvailable = res));
  // }

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
              "http://rrjprojects.000webhostapp.com/api/ideasUpdate.php"),
          body: {
            "sno": globals.editIdeaSno,
            "ideaName": _ideaName.trim(),
            "ideaDesc": _ideaDesc.trim(),
            "ideaPriority": _priorityValue.round().toString()
          });
      _response = json.decode(_response.body);
      if (_response[0]['status'] == "1") {
        setState(() {
          _isUpdating = false;
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text('Idea detail updated 😃'),
            duration: Duration(seconds: 3),
          ));
        });
      }
    } catch (FormatException) {
      setState(() {
        _isUpdating = false;
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('An error occurred during updating 😯'),
          duration: Duration(seconds: 3),
        ));
      });
    } catch (SocketException) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.orange,
        content: Text('Woah! Seems like a Network Error 🙁'),
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
      maxLength: 2500,
      decoration: InputDecoration(
          // suffixIcon: IconButton(
          //   onPressed: () {
          //     if (!_recStart) {
          //       if (_srIsAvailable && !_srIsListening) {
          //         print("Hi");
          //         _recStart = !_recStart;
          //         _speechRecognition
          //             .listen(locale: "en_US")
          //             .then((result) => print('$result'));
          //       }
          //     } else {
          //       if (_srIsListening) {
          //         _recStart = !_recStart;
          //         _speechRecognition.stop().then((result) {
          //           setState(() {
          //             _srIsListening = result;
          //           });
          //         });
          //       }
          //     }
          //   },
          //   icon: Icon(Icons.mic),
          // ),
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
            content: Text(
                "This action will remove the idea from the explore list 😥                                                                                                                                                                                                                                                                                                                                       "),
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
                  Navigator.pop(context);
                  _deleteIdeaConfirm();
                },
              )
            ],
          );
        });
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
          content: Text('An error occurred during deleting 😥'),
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
              disabledElevation: 0.0,
              onPressed: (_isUpdating == false)
                  ? () {
                      if (_ideaNameControl.text.length != 0 &&
                          _ideaDescControl.text.length != 0) {
                        _updateIdea();
                      } else {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          backgroundColor: Colors.orange,
                          content: Text('Please check for empty fields 🧐'),
                          duration: Duration(seconds: 3),
                        ));
                      }
                    }
                  : null,
              child: (_isUpdating == false)
                  ? Icon(Icons.check)
                  : CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
              backgroundColor:
                  (_isUpdating == false) ? Colors.green : Colors.grey,
            ),
            appBar: AppBar(
              actions: <Widget>[
                Container(
                  margin: EdgeInsets.all(9.0),
                  child: FlatButton.icon(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)),
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
                    height: 70.0,
                  ),
                ],
              ),
            )));
  }
}
