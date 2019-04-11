import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global.dart' as globals;

class ColorPickerPage extends StatefulWidget {
  Function reloadMain;
  ColorPickerPage(this.reloadMain);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ColorPickerPageState();
  }
}

void _setColorPersistant(Color color) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (color == Colors.deepOrange) {
    prefs.setInt("primaryColor", 1);
  } else if (color == Colors.green) {
    prefs.setInt("primaryColor", 2);
  } else if (color == Colors.teal) {
    prefs.setInt("primaryColor", 3);
  } else if (color == Colors.purple) {
    prefs.setInt("primaryColor", 4);
  }
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  Color _currColor;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("App Settings"),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(30.0),
        child: ListView(
          children: <Widget>[
            Container(
              child: Text(
                "App color theme: ",
                style: TextStyle(fontSize: 20.0, color: Colors.blueGrey),
              ),
            ),
            MaterialColorPicker(
              onMainColorChange: (Color color) {
                // print(color.toString());
                _setColorPersistant(color);
                globals.primaryColor = color;
                widget.reloadMain();
              },
              circleSize: 50.0,
              selectedColor: globals.primaryColor,
              allowShades: false,
              colors: [
                Colors.deepOrange,
                Colors.green,
                Colors.teal,
                Colors.purple,
                Colors.indigo,
              ],
            )
          ],
        ),
      ),
    );
  }
}
