import 'package:WP_news_APP/Decors/decors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import '../Globals.dart';

double _getWidgetSize(context) {
  if (MediaQuery.of(context).size.height > 400) return 400.0;
  return MediaQuery.of(context).size.height;
}

aboutInfoDialog(dynamic context) async {
  bool shouldUpdate = await showDialog(
      context: context,
      builder: (context) {
        return (AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(0),
          titlePadding: const EdgeInsets.all(0),
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: _getWidgetSize(context),
            decoration: new BoxDecoration(
              color: GlobalTheme.backgroundDialog,
              borderRadius: new BorderRadius.all(Radius.circular(20)),
            ),
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
                        style: new TextStyle(
                            fontSize: 18, color: GlobalTheme.textColor),
                        textAlign: TextAlign.center),
                    margin: EdgeInsets.only(top: 10, bottom: 20),
                  ),
                ),
                Center(
                  child: Container(
                    child: Text("Rev." + Global_packageInfo.buildNumber,
                        style: new TextStyle(
                            fontSize: 14, color: GlobalTheme.textColor),
                        textAlign: TextAlign.center),
                    margin: EdgeInsets.only(top: 10, bottom: 20),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 140,
                            child: Text('App created by: Mateusz "maxiges"',
                                style: new TextStyle(
                                    fontSize: 14, color: GlobalTheme.textColor),
                                textAlign: TextAlign.center),
                            margin: EdgeInsets.only(
                                top: 10, bottom: 5, left: 5, right: 0),
                          ),
                          Container(
                            child: Text('Email: maxiges10@gmail.com',
                                style: new TextStyle(
                                    fontSize: 14, color: GlobalTheme.textColor),
                                textAlign: TextAlign.center),
                            margin: EdgeInsets.only(
                                top: 10, bottom: 5, left: 5, right: 0),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(
                            top: 10, bottom: 5, right: 5, left: 0),
                        child: Image(
                          image: AssetImage('images/my_logo.png'),
                          height: 40,
                          width: 40,
                        )),
                  ],
                ),
                Expanded(
                    child: Align(
                  child: TextButton(
                    style: Decors.basicButtonStyle,
                    child: new Text(
                      "    Cancel    ",
                      style: GlobalTheme.textStyle,
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
      });
}
