import 'package:WP_news_APP/Globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import "../Globals.dart";

Future<bool> yesNoDialogShowDialog(
    String textAbove, Color yesColor, dynamic context, Icon icon) async {
  bool shouldUpdate = await showDialog(
      context: context,
      builder: (context) {
        return (new AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                margin: new EdgeInsets.all(0),
                padding: new EdgeInsets.all(20),
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.all(Radius.circular(10)),
                  color: GlobalTheme.backgroundDialog,
                ),
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
                          child: icon,
                        ),
                      ),
                      Center(
                        child: Text(
                          textAbove,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, color: GlobalTheme.textColor),
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
                            child: Container(),
                          ),
                          Expanded(
                            child: FlatButton(
                              child: new Text(
                                "NO ",
                                style: TextStyle(color: GlobalTheme.textColor),
                              ),
                              onPressed: () => Navigator.pop(context, false),
                            ),
                          ),
                        ],
                      ),
                    ]))));
      });

  try {
    if (shouldUpdate == null) {
      return false;
    }
    return shouldUpdate;
  } catch (ex) {
    return false;
  }
}
