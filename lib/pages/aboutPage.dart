import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AboutPageState();
  }
}

class _AboutPageState extends State<AboutPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    //     statusBarColor: Colors.white,
    //     systemNavigationBarColor: Colors.white,
    //     systemNavigationBarIconBrightness: Brightness.dark));
    // TODO: implement build
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "About",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        child: Center(
          child: ListView(
            padding: EdgeInsets.only(top: 40.0, left: 40, right: 40),
            shrinkWrap: true,
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'IdeaLog App',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w300),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.45, top: 5.0),
                child: Container(
                  height: 5,
                  color: Colors.blue,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Text('Version',
                    style: TextStyle(color: Colors.grey, fontSize: 15.0)),
              ),
              Container(
                child: Text('2.1',
                    style: TextStyle(color: Colors.black, fontSize: 20.0)),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Text('Last Update',
                    style: TextStyle(color: Colors.grey, fontSize: 15.0)),
              ),
              Container(
                child: Text('May 2019',
                    style: TextStyle(color: Colors.black, fontSize: 20.0)),
              ),
              // Container(
              //   margin: EdgeInsets.only(top: 50.0),
              //   alignment: Alignment.topLeft,
              //   child: Text(
              //     'About Developer',
              //     style: TextStyle(fontSize: 40, fontWeight: FontWeight.w300),
              //   ),
              // ),
              // Container(
              //   padding: EdgeInsets.only(right: 160, top: 5.0),
              //   child: Container(
              //     height: 5,
              //     color: Colors.blue,
              //   ),
              // ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Text('Developer',
                    style: TextStyle(color: Colors.grey, fontSize: 15.0)),
              ),
              Container(
                child: Text('Rohit Raj, TMFT',
                    style: TextStyle(color: Colors.black, fontSize: 20.0)),
              ),

              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Text('My Projects',
                    style: TextStyle(color: Colors.grey, fontSize: 15.0)),
              ),
              Container(
                child: InkWell(
                    child: new Text(
                      'Visit Github',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onTap: () {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                          'Link copied to clipboard',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.green,
                      ));
                      Clipboard.setData(new ClipboardData(
                          text: 'https://github.com/RohitRajP'));
                    }),
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Developed using',
                        style: TextStyle(color: Colors.grey, fontSize: 15.0)),
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: FlutterLogo(
                        size: 100.0,
                        style: FlutterLogoStyle.horizontal,
                      ),
                    )
                  ],
                ),
              ),

              // Container(
              //   child: Text('https://github.com/RohitRajP',
              //       style: TextStyle(color: Colors.black, fontSize: 25.0)),
              // ),
              // Container(
              //   child: Text('',
              //       style: TextStyle(color: Colors.black, fontSize: 25.0)),
              // )
            ],
          ),
        ),
      ),
    ));
  }
}
