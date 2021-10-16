import 'package:WP_news_APP/Utils/ColorPicker.dart' as ColorsPicker;
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../Globals.dart';
import '../Class/WebPortal.dart';
import '../Utils/ColorsFunc.dart';

import 'package:toast/toast.dart';

// create some values
Color pickerColor = Colors.black;
Color currentColor = Colors.black;
String actUrl = "";

Function _changeColor(Color newColor) {
  currentColor = newColor;
  return null;
}

BoxDecoration buttonDecor(Color back) {
  return BoxDecoration(
    color: back,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
      width: 2,
      color: Colors.black38,
    ),
  );
}

double _getMaxDialogSize(context) {
  {
    if ((MediaQuery.of(context).size.height) > 530) {
      return 530.0;
    } else {
      return MediaQuery.of(context).size.height;
    }
  }
}

Future<bool> settingAddPageShowDialog(WebPortal web, dynamic context) async {
  pickerColor = web.getColor();
  currentColor = web.getColor();
  actUrl = web.url;
  bool shouldUpdate = await showDialog(
      context: context,
      builder: (context) {
        return (new AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: const EdgeInsets.all(0),
            titlePadding: const EdgeInsets.all(0),
            content: Container(
                height: _getMaxDialogSize(context),
                width: MediaQuery.of(context).size.width,
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.all(Radius.circular(10)),
                  color: GlobalTheme.backgroundDialog,
                ),
                child: ListView(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(
                          bottom: 30, left: 5, right: 5, top: 5),
                      child: TextFormField(
                        initialValue: web.url,
                        style: TextStyle(color: GlobalTheme.textColor),
                        decoration: InputDecoration(
                          icon: Icon(Icons.bookmark_border),
                          hintText: '',
                          labelText: 'Click and write http://',
                          labelStyle: TextStyle(color: GlobalTheme.textColor),
                          counterStyle: TextStyle(color: GlobalTheme.textColor),
                          errorStyle: TextStyle(color: GlobalTheme.textColor),
                          hintStyle: TextStyle(color: GlobalTheme.textColor),
                          helperStyle: TextStyle(color: GlobalTheme.textColor),
                        ),
                        onSaved: (String value) {
                          actUrl = value;
                        },
                        onChanged: (String value) {
                          actUrl = value;
                        },
                        validator: (String value) {
                          if (value.length < 2) return "URL is too short";
                          if (!value.contains("."))
                            return "No prefix ex.  .pl .org .com ";
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 30, top: 15),
                      child: ColorsPicker.ColorPicker(
                        colorPalette.values.toList(),
                        _changeColor,
                        initColor: currentColor,
                        maxRow: Global_width ~/ 80,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              child: Container(
                            margin:
                                new EdgeInsets.only(top: 20, left: 5, right: 5),
                            decoration: buttonDecor(Colors.greenAccent),
                            child: FlatButton(
                              child: new Text(
                                "Add/Edit",
                                style: TextStyle(
                                    color:
                                    Color_getColorText(Colors.greenAccent)),
                              ),
                              onPressed: () => Navigator.pop(context, true),
                            ),
                          )),
                          Expanded(
                              child: Container(
                            margin:
                                new EdgeInsets.only(top: 20, left: 5, right: 5),
                            decoration: buttonDecor(GlobalTheme.textColor),
                            child: FlatButton(
                              child: new Text(
                                "Cancel ",
                                style: TextStyle(color: GlobalTheme.background),
                              ),
                              onPressed: () => Navigator.pop(context, false),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                ))));
      });

  try {
    if (shouldUpdate == true) {
      if (actUrl.length < 3 ||
          currentColor == null ||
          currentColor == Colors.transparent) {
        if (actUrl.length < 3) {
          Toast.show("No add/edit page\r\nUrl is too short", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        } else {
          Toast.show("No add/edit page\r\nColor wasn't choose", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }

        return false;
      }

      for (WebPortal readWeb in Global_webList) {
        if (readWeb.url == actUrl && actUrl.length > 2) {
          readWeb.decColor = Color_GetColorInString(currentColor);
          webPortalSaveWebs(Global_webList);
          return true;
        }
      }
      web.decColor = Color_GetColorInString(currentColor);
      web.url = actUrl;
      Global_webList.add(web);
      webPortalSaveWebs(Global_webList);
      return true;
    }
    if (shouldUpdate == null) {
      return false;
    }
    return shouldUpdate;
  } catch (ex) {
    return false;
  }
}
