import '../main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Globals.dart';

class WebPortal {
  String url;
  String decColor;
  WebPortal(this.url, this.decColor);
  Color getColor() {
    try {
      return colorPalet[this.decColor];
    } catch (ex) {}
    return Colors.black;
  }
  void tryRead(String JsonString)
  {
    try {
      Map<String, dynamic> user = jsonDecode(JsonString);
      this.url = user["URL"];
      this.decColor = user["Color"];
    }
    catch(ex)
    {
      this.url = "";
      this.decColor = "red";
    }
  }
  String toJsonString() {
    String JsonStr = '{ "URL" : "' +
        this.url.replaceAll("\n", "") +
        '", "Color" :"' +
        this.decColor.replaceAll("\n", "") +
        '"}';
    return JsonStr;
  }
}

Future<bool> saveWebPorts(List<WebPortal> list ) async
{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> objSave = new List<String>();

  for (WebPortal objectVal in list) {
    objSave.add(objectVal.toJsonString());
  }
  prefs.remove("SavedWebs");
  return prefs.setStringList("SavedWebs", objSave);

}
Future<List<WebPortal>> loadWebPorts() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<WebPortal> redadWebs = new List<WebPortal>();
  try {
    List<String> loadedWevs = prefs.getStringList("SavedWebs");
    for (String JsonString in loadedWevs) {
      WebPortal newSavedPage =
      new WebPortal("", "");
      newSavedPage.tryRead(JsonString);
      if (newSavedPage.url.length > 0) {
        redadWebs.add(newSavedPage);
      }
    }
  } catch (ex) {
    print(ex.toString());
  }

  return redadWebs;
}
