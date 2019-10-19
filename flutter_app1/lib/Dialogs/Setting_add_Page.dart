import 'package:WP_news_APP/Utils/ColorPicker.dart' as ColorsPicker;
import 'package:WP_news_APP/Class/WebsideInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_colorpicker/block_picker.dart';
import '../Globals.dart';
import '../Class/WebPortal.dart';
import '../Utils/ColorPicker.dart';

import 'package:toast/toast.dart';


// create some values
Color pickerColor = Colors.black;
Color currentColor = Colors.black;
String actUrl = "";

Function changeColor(Color newColor) {
  currentColor = newColor;
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

double retDialogHigh(context){
  {
    if((MediaQuery.of(context).size.height) > 550){
      return 550.0;
  }
  else
  {
  return MediaQuery.of(context).size.height;

  }


}
}

Future<bool> AddEditPageDialogPage(WebPortal web, dynamic context) async {
  pickerColor = web.getColor();
  currentColor = web.getColor();
  actUrl = web.url;
  bool shouldUpdate = await showDialog(
      context: context,

      child: new AlertDialog(

        contentPadding:const EdgeInsets.all(0) ,
        titlePadding: const EdgeInsets.all(0),
          content: Container(
            height: retDialogHigh(context) ,
              width: MediaQuery.of(context).size.width,

              child: ListView(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 30 , left: 5 , right: 5 , top: 5),
            child: TextFormField(
              initialValue: web.url,
              decoration: const InputDecoration(
                icon: Icon(Icons.bookmark_border),
                hintText: '',
                labelText: 'URL http://',
              ),
              onSaved: (String value) {
               actUrl = value;
              },
              onChanged: (String value)
              {
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

            margin: const EdgeInsets.only(bottom: 30 , top: 15 ),
            child: ColorsPicker.ColorPicker(colorPalet.values.toList(),changeColor ,initColor:currentColor ,MaxinRow: (Global_width/80).toInt(),  ),

            ),


         Align(
              alignment: Alignment.bottomCenter,
              child:
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(

                  child: Container(
                    margin: new EdgeInsets.only(top: 20,left: 5,right: 5),
                decoration: buttonDecor(Colors.greenAccent),
                child: FlatButton(
                  child: new Text(
                    "Add/Edit",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () => Navigator.pop(context, true),
                ),
              )),

              Expanded(
                  child: Container(
                    margin: new EdgeInsets.only(top: 20,left: 5,right: 5),
                    decoration: buttonDecor(Colors.transparent),
                    child: FlatButton(
                      child: new Text(
                        "Cancel ",
                      ),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                  )),
            ],
          ),
          ),

        ],
      )


          )));

  try {
    if (shouldUpdate == true) {

      if(actUrl.length<3 || currentColor == null ||currentColor == Colors.transparent )
        {
          if(actUrl.length<3) {
            Toast.show(
                "No add/edit page\r\nUrl is too short", context, duration: Toast.LENGTH_LONG,
                gravity: Toast.BOTTOM);
          }
          else {
            Toast.show(
                "No add/edit page\r\nColor wasn't choose", context, duration: Toast.LENGTH_LONG,
                gravity: Toast.BOTTOM);
          }

          return false;
        }

      for (WebPortal readWeb in Global_webList) {
        if (readWeb.url == actUrl && actUrl.length>2) {
          readWeb.decColor = GetStringColor(currentColor);
          saveWebPorts(Global_webList);
          return true;
        }
      }
      web.decColor = GetStringColor(currentColor);
      web.url = actUrl;
      Global_webList.add(web);
      saveWebPorts(Global_webList);
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
