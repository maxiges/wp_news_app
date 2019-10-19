import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

Future<bool> ShowDialog(
    String textAbove, Color yesColor, dynamic context, Icon p_icon) async {
  bool shouldUpdate = await showDialog(
      context: context,
      child: new AlertDialog(
          content: Container(
              margin: new EdgeInsets.all(0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        decoration: new BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(Radius.circular(10)),
                          color: Color.fromARGB(255, 50, 50, 50),
                        ),
                        padding: new EdgeInsets.all(5),
                        margin: new EdgeInsets.only(bottom: 15),
                        child: p_icon,
                      ),
                    ),
                    Center(
                      child: Text(
                        textAbove,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                            color: yesColor,
                            child: new Text(
                              "YES",
                            ),
                            onPressed: () => Navigator.pop(context, true),
                          ),
                        ),
                        Expanded(
                          child: FlatButton(),
                        ),
                        Expanded(
                          child: FlatButton(
                            child: new Text(
                              "NO ",
                            ),
                            onPressed: () => Navigator.pop(context, false),
                          ),
                        ),
                      ],
                    ),
                  ]))));

  try {
    if (shouldUpdate == null) {
      return false;
    }
    return shouldUpdate;
  } catch (ex) {
    return false;
  }
}
