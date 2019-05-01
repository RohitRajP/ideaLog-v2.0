import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AboutPageState();
  }
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            child: Text(
              'IdeaLog App',
              style: TextStyle(fontSize: 25),
            ),
          )
        ],
      ),
    );
  }
}
