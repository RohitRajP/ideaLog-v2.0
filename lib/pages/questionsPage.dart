import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../global.dart' as globals;
import '../widgets/qAskedW.dart';
import '../widgets/qAskW.dart';

class QuestionsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _QuestionsPageState();
  }
}

class _QuestionsPageState extends State<QuestionsPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _clearLoginLogs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    globals.userId = null;
    globals.userName = null;
    globals.accUserName = null;
    globals.userPassword = null;
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

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                title: new Text('Are you sure?'),
                content: new Text('This action will exit IdeaLog 😭'),
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
        length: 2,
        child: SafeArea(
            child: WillPopScope(
                onWillPop: _onWillPop,
                child: Scaffold(
                    key: _scaffoldKey,
                    drawer: Drawer(
                      child: ListView(
                        children: <Widget>[
                          UserAccountsDrawerHeader(
                            accountEmail:
                                Text("Innovator ID: " + globals.userId),
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
                            subtitle:
                                Text("It's an innovator's world out there"),
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, '/explorePage');
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
                              Navigator.pushNamed(context, '/questionsPage');
                            },
                          ),
                          ListTile(
                            title: Text("App Settings"),
                            leading: Icon(
                              FontAwesomeIcons.cogs,
                              color: globals.primaryColor,
                            ),
                            subtitle:
                                Text("Change application specific settings"),
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
                                      Navigator.pushNamed(
                                          context, '/userDetails');
                                    },
                                  )
                                : null,
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
                    appBar: AppBar(
                      title: Text("Q&A Dashboard"),
                      bottom: TabBar(
                        tabs: <Widget>[
                          Tab(
                            icon: Icon(FontAwesomeIcons.comment),
                            text: "Asked",
                          ),
                          Tab(
                            icon: Icon(FontAwesomeIcons.question),
                            text: "Ask",
                          ),
                        ],
                      ),
                    ),
                    body: TabBarView(
                      children: <Widget>[
                        QAskedW(_scaffoldKey),
                        QAskW(_scaffoldKey),
                      ],
                    )))));
  }
}
