import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../global.dart' as globals;

class SchedulePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SchedulePageState();
  }
}

class _SchedulePageState extends State<SchedulePage> {
  List<String> _scheduleList;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _task;
  bool _isLoading = true;

  void initState() {
    _getSchedule();
  }

  void _getSchedule() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _scheduleList = prefs.getStringList('scheduleList');
    if (_scheduleList == null) {
      _scheduleList = [];
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _clearLoginLogs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    globals.userId = null;
    globals.userName = null;
    globals.accUserName = null;
    globals.userPassword = null;
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                title: new Text('Are you sure?'),
                content: new Text('This action will exit IdeaLog 🙁'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('No'),
                  ),
                  new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      Navigator.of(context).pop(true);
                    },
                    child: new Text('Yes'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  void _showConfirmDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            title: Text("Are you sure?"),
            content: Text("This action will log you out of IdeaLog 😧"),
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
                  _clearLoginLogs();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/loginPage', (Route<dynamic> route) => false);
                },
              )
            ],
          );
        });
  }

  void _updateCreateSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('scheduleList', _scheduleList);
    //print(prefs.getStringList('scheduleList'));
  }

  void _showCreateIdea() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            title: Text("Create Task"),
            content: SizedBox(
              width: 400,
              child: Container(
                child: TextField(
                  onChanged: (value) {
                    _task = value;
                  },
                  decoration: InputDecoration(labelText: "Enter new task"),
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                textColor: Colors.white,
                color: Colors.red,
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                textColor: Colors.white,
                color: Colors.green,
                child: Text("Add Task"),
                onPressed: () {
                  _scheduleList.add(_task);
                  _updateCreateSharedPrefs();
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  void _deleteTask(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _scheduleList.removeAt(index);
    });
    prefs.setStringList('scheduleList', _scheduleList);
  }

  void _moveUp(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(_scheduleList[index]);
    if (index >= 1) {
      setState(() {
        String temp = _scheduleList[index];

        _scheduleList[index] = _scheduleList[index - 1];
        //print(_scheduleList[index]);
        _scheduleList[index - 1] = temp;
      });
    }
    prefs.setStringList('scheduleList', _scheduleList);
  }

  void _moveDown(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(_scheduleList[index]);
    if (index < _scheduleList.length - 1) {
      setState(() {
        String temp = _scheduleList[index];

        _scheduleList[index] = _scheduleList[index + 1];
        //print(_scheduleList[index]);
        _scheduleList[index + 1] = temp;
      });
    }
    prefs.setStringList('scheduleList', _scheduleList);
  }

  Widget _taskTile(BuildContext context, int index) {
    return Slidable(
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Completed',
            color: Colors.green,
            icon: Icons.check,
            onTap: () {
              _deleteTask(index);
            },
          ),
        ],
        actions: <Widget>[
          IconSlideAction(
            caption: 'Move Up',
            color: Colors.blue,
            icon: Icons.arrow_upward,
            onTap: () {
              _moveUp(index);
            },
          ),
          new IconSlideAction(
            caption: 'Move Down',
            color: Colors.indigo,
            icon: Icons.arrow_downward,
            onTap: () {
              _moveDown(index);
            },
          ),
        ],
        delegate: new SlidableDrawerDelegate(),
        actionExtentRatio: 0.25,
        child: ListTile(
          title: Text(_scheduleList[index]),
          leading: Icon(FontAwesomeIcons.check),
        ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              key: _scaffoldKey,
              floatingActionButton: FloatingActionButton(
                foregroundColor: Colors.white,
                onPressed: () {
                  _showCreateIdea();
                },
                backgroundColor: Colors.green,
                child: Icon(FontAwesomeIcons.plus),
              ),
              appBar: AppBar(
                title: Text("Daily Tasks"),
              ),
              drawer: Drawer(
                child: ListView(
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      accountEmail: Text("Innovator ID: " + globals.userId),
                      accountName: Text(globals.userName,
                          style: TextStyle(fontSize: 18.0)),
                      currentAccountPicture: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(globals.userName[0],
                            style: TextStyle(fontSize: 40.0)),
                      ),
                    ),
                    ListTile(
                      title: Text("IDEA Dashboard"),
                      leading: Icon(
                        FontAwesomeIcons.lightbulb,
                        color: globals.primaryColor,
                      ),
                      subtitle: Text("It's an innovator's world out there"),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/explorePage');
                      },
                    ),
                    ListTile(
                      title: Text("Q&A Dashboard"),
                      leading: Icon(
                        FontAwesomeIcons.question,
                        color: globals.primaryColor,
                      ),
                      subtitle:
                          Text("All the questions you want the answers to"),
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, '/questionsPage');
                      },
                    ),
                    ListTile(
                      title: Text("Profile Settings"),
                      leading: Icon(
                        FontAwesomeIcons.userCog,
                        color: globals.primaryColor,
                      ),
                      subtitle: Text("Change your profile details"),
                      onTap: () {
                        Navigator.pushNamed(context, '/profilePage');
                      },
                    ),
                    ListTile(
                      title: Text("App Settings"),
                      leading: Icon(
                        FontAwesomeIcons.cogs,
                        color: globals.primaryColor,
                      ),
                      subtitle: Text("Change application specific settings"),
                      onTap: () {
                        Navigator.pushNamed(context, '/appSettingsPage');
                      },
                    ),
                    Container(
                      child: (globals.userId == '1')
                          ? ListTile(
                              title: Text("Users"),
                              leading: Icon(
                                FontAwesomeIcons.users,
                                color: globals.primaryColor,
                              ),
                              subtitle: Text("Show all user details"),
                              onTap: () {
                                Navigator.pushNamed(context, '/userDetails');
                              },
                            )
                          : null,
                    ),
                    ListTile(
                      title: Text("About App"),
                      leading: Icon(
                        FontAwesomeIcons.info,
                        color: globals.primaryColor,
                      ),
                      subtitle: Text("All about the app and the developers"),
                      onTap: () {
                        Navigator.pushNamed(context, '/aboutPage');
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Logout",
                        style: TextStyle(color: Colors.red),
                      ),
                      leading: Icon(
                        FontAwesomeIcons.signOutAlt,
                        color: Colors.red,
                      ),
                      subtitle: Text("Sign out of account",
                          style: TextStyle(color: Colors.redAccent)),
                      onTap: () {
                        _showConfirmDialog();
                      },
                    )
                  ],
                ),
              ),
              body: Container(
                child: (_isLoading == true)
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : (_scheduleList.length != 0)
                        ? ListView.builder(
                            itemBuilder: _taskTile,
                            itemCount: _scheduleList.length,
                          )
                        : Center(
                            child: Container(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                '😮 \n There are no daily tasks to show right now \n\n How about you try creating one by pressing the + icon below \n 😃',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
              ),
            )));
  }
}
