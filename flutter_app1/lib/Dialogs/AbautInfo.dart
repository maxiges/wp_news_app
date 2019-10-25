import 'package:WP_news_APP/Utils/ColorPicker.dart' as ColorsPicker;
import 'package:WP_news_APP/Class/WebsideInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_colorpicker/block_picker.dart';
import '../Globals.dart';
import '../Class/WebPortal.dart';
import '../Utils/ColorPicker.dart';

import 'package:toast/toast.dart';

double _getWidgetSize(context) {
  if (MediaQuery.of(context).size.height > 400) return 400.0;
  return MediaQuery.of(context).size.height;
}

aboutInfoDialog(dynamic context) async {
  bool shouldUpdate = await showDialog(
      context: context,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        titlePadding: const EdgeInsets.all(0),
        content: Container(
          width: MediaQuery.of(context).size.width,
          height: _getWidgetSize(context),
          child: Column(
            children: <Widget>[
              Center(
                  child: Container(
                      child: Image(
                image: AssetImage('assets/icon.png'),
                height: 100,
                width: 100,
              ))),
              Center(
                child: Container(
                  child: Text(
                      Global_packageInfo.appName +
                          " v." +
                          Global_packageInfo.version,
                      style: new TextStyle(fontSize: 18),
                      textAlign: TextAlign.center),
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                ),
              ),
              Center(
                child: Container(
                  child: Text("Rev." + Global_packageInfo.buildNumber,
                      style: new TextStyle(fontSize: 14),
                      textAlign: TextAlign.center),
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text('App created by: Mateusz "maxiges"',
                              style: new TextStyle(fontSize: 14),
                              textAlign: TextAlign.center),
                          margin: EdgeInsets.only(top: 10, bottom: 5, left: 5),
                        ),
                        Container(
                          child: Text('Email: maxiges10@gmail.com',
                              style: new TextStyle(fontSize: 14),
                              textAlign: TextAlign.center),
                          margin: EdgeInsets.only(top: 10, bottom: 5, left: 5),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 10, bottom: 5, right: 5),
                      child: Image(
                        image: AssetImage('images/my_logo.png'),
                        height: 40,
                        width: 40,
                      )),
                ],
              ),
              Expanded(
                  child: Align(
                child: FlatButton(
                  padding: const EdgeInsets.all(15),
                  color: Colors.blueAccent,
                  child: new Text(
                    "    Cancel    ",
                  ),
                  onPressed: () => Navigator.pop(context, false),
                ),
                alignment: FractionalOffset.bottomCenter,
              )),
              Container(
                height: 10,
              )
            ],
          ),
        ),
      ));
}
