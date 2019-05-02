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
  List<String> _scheduleList, _permanentList;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _taskController = new TextEditingController();

  String _task;
  bool _isLoading = true;
  final List<FloatingActionButton> fabs = [
    new FloatingActionButton(
      child: new Icon(Icons.access_time),
      onPressed: () {},
    ),
    new FloatingActionButton(
      child: new Icon(Icons.account_balance),
      onPressed: () {},
    ),
    new FloatingActionButton(
      child: new Icon(Icons.add_alert),
      onPressed: () {},
    )
  ];

  void initState() {
    // _dateTimeVerification();
    _getSchedule();
  }

  // void _dateTimeVerification() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   print(prefs.getStringList('templateList'));
  //   print(prefs.getStringList('scheduleList'));
  //   print(_scheduleList);
  //   String lastTime = prefs.getString('lastTime');
  //   if (lastTime == null) {
  //     prefs.setString('lastTime', DateTime.now().toString());
  //   } else {
  //     DateTime before = DateTime.parse(lastTime);
  //     DateTime now = DateTime.now();
  //     //print(before.difference(now).inHours);
  //     if (before.difference(now).inHours > 24) {
  //       _scheduleList = prefs.getStringList('templateList');
  //       prefs.setStringList('scheduleList', _scheduleList);
  //     }
  //   }
  //   _getSchedule();
  // }

  void _getSchedule() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _scheduleList = prefs.getStringList('scheduleList');
    _permanentList = prefs.getStringList('permanentList');
    if (_scheduleList == null) {
      _scheduleList = [];
    }
    if (_permanentList == null) {
      _permanentList = [];
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

  void _updateCreateSharedPrefs(String _task, int addOrNot) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('scheduleList', _scheduleList);
    _permanentList = prefs.getStringList('permanentList');
    if (_permanentList == null) {
      _permanentList = [];
    } else {
      _permanentList = prefs.getStringList('permanentList');
    }
    if (addOrNot == 1) {
      _permanentList.add(_task);
    }
    prefs.setStringList('permanentList', _permanentList);
    print(prefs.getStringList('permanentList'));
    // prefs.setStringList('templateList', _scheduleList);
    //print(prefs.getStringList('scheduleList'));
  }

  void _showCreateTask() {
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
                  // _permanentList.add(_task);
                  _updateCreateSharedPrefs(_task, 1);
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  void _updatePermanentList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('permanentList', _permanentList);
  }

  Widget _allTasksList(BuildContext context, int index) {
    return ExpansionTile(
      title: Text(_permanentList[index]),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton.icon(
              textColor: Colors.green,
              icon: Icon(Icons.add),
              label: Text("Add"),
              onPressed: () {
                _scheduleList.add(_permanentList[index]);
                Navigator.pop(context);
                setState(() {});
              },
            ),
            FlatButton.icon(
              textColor: Colors.red,
              icon: Icon(Icons.delete),
              label: Text("Delete"),
              onPressed: () {
                _permanentList.removeAt(index);
                _updatePermanentList();
                Navigator.pop(context);
              },
            )
          ],
        )
      ],
    );
  }

  void _showEditTasks() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            title: Text("Task List"),
            content: SizedBox(
              width: 400,
              child: Container(
                child: (_permanentList.length == 0)
                    ? Center(
                        child: Text("No data to show"),
                      )
                    : ListView.builder(
                        itemBuilder: _allTasksList,
                        itemCount: _permanentList.length,
                      ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                textColor: Colors.white,
                color: Colors.green,
                child: Text("Done"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void _taskComplete(int index) async {
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

  void _showTaskEdit(index) {
    _taskController.text = _scheduleList[index];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            title: Text("Edit Task"),
            content: SizedBox(
              width: 400,
              child: Container(
                child: TextField(
                  controller: _taskController,
                  onChanged: (value) {
                    _task = value;
                  },
                  decoration: InputDecoration(labelText: "Edit this task"),
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
                child: Text("Edit Task"),
                onPressed: () {
                  int flag = 0;
                  for (int i = 0; i < _permanentList.length; i++) {
                    if (_permanentList[i] == _scheduleList[index]) {
                      _permanentList[i] = _task;
                      flag++;
                    }
                  }
                  _scheduleList[index] = _task;
                  if (flag != 0) {
                    _updateCreateSharedPrefs(_task, 0);
                  } else {
                    _updateCreateSharedPrefs(_task, 1);
                  }
                  // _permanentList.add(_task);

                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Widget _taskTile(BuildContext context, int index) {
    return Slidable(
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Edit',
            foregroundColor: Colors.white,
            color: Colors.purple,
            icon: Icons.edit,
            onTap: () {
              _showTaskEdit(index);
            },
          ),
          IconSlideAction(
            caption: 'Completed',
            color: Colors.green,
            icon: Icons.check,
            onTap: () {
              _taskComplete(index);
            },
          ),
          // IconSlideAction(
          //   caption: 'Delete Task',
          //   color: Colors.red,
          //   icon: Icons.delete,
          //   onTap: () {
          //     _deleteTask(index);
          //   },
          // )
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
              floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FloatingActionButton.extended(
                    foregroundColor: Colors.white,
                    onPressed: () {
                      _showEditTasks();
                    },
                    backgroundColor: Colors.purple,
                    icon: Icon(FontAwesomeIcons.list),
                    label: Text("List"),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  FloatingActionButton.extended(
                    foregroundColor: Colors.white,
                    onPressed: () {
                      _showCreateTask();
                    },
                    backgroundColor: Colors.green,
                    icon: Icon(FontAwesomeIcons.plus),
                    label: Text('Create'),
                  ),
                ],
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
                                '😮 \n There are no daily tasks to show right now \n How about you try creating one by pressing the + icon below \n 😃',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
              ),
            )));
  }
}
