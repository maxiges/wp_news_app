import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Globals.dart';
import '../Utils/ColorsFunc.dart';
import '../Utils/SaveLogs.dart';
import 'Firebase.dart';

class WebPortal {
  String url;
  String decColor;

  WebPortal(this.url, this.decColor);

  Color getColor() {
    return Color_GetColor(this.decColor);
  }

  void tryRead(String jsonString) {
    try {
      Map<String, dynamic> user = jsonDecode(jsonString);
      this.url = user["URL"];
      this.decColor = user["Color"];
    } catch (ex) {
      this.url = "";
      this.decColor = "red";
    }
  }

  String toJson() {
    String jsonStr = '{ "URL" : "' +
        this.url.replaceAll("\n", "") +
        '", "Color" :"' +
        this.decColor.replaceAll("\n", "") +
        '"}';
    return jsonStr;
  }
} //class  WebPortal

void _saveDataToFirebase(String data) async {
  try {
    DataFromDb d = DataFromDb(Global_GoogleSign.getGoogleUserEmail(), data);
    fbDataFromBaseRef.doc(d.id).update(d.toJson());
  } catch (ex) {
    saveLogs.error(ex);
  }
}

Future<List<DataFromDb>> _loadDataFromFirebase() async {
  try {
    List<DataFromDb> retList = [];
    final users = await fbDataFromBaseRef
        .doc(Global_GoogleSign.getGoogleUserEmail())
        .get();
    retList.add(users.data());
    return retList;
  } catch (ex) {
    saveLogs.error(ex);
  }
  return [];
}

Future<bool> webPortalSaveWebs(List<WebPortal> list) async {
  List<String> objSave = [];

  for (WebPortal objectVal in list) {
    objSave.add(objectVal.toJson());
  }

  if (Global_GoogleSign.googleUserIsSignIn() == true) {
    try {
      _saveDataToFirebase(
          objSave.reduce((value, element) => value + ';' + element));
    } catch (ex) {
      saveLogs.error(ex);
    }
  }
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("SavedWebs");
  return prefs.setStringList("SavedWebs", objSave);
}

Future<List<WebPortal>> webPortalLoadWebs() async {
  List<String> loadedWebs = [];
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (Global_GoogleSign.googleUserIsSignIn() == true) {
    try {
      List<DataFromDb> ret = await _loadDataFromFirebase();
      for (DataFromDb objectVal in ret) {
        for (String savedWebpages in objectVal.description.split(";")) {
          loadedWebs.add(savedWebpages);
        }
      }
    } catch (ex) {
      saveLogs.error(ex);
    }
  } else {
    try {
      loadedWebs = prefs.getStringList("SavedWebs");
    } catch (ex) {
      saveLogs.error(ex);
    }
  }

  List<WebPortal> readWebs = [];
  try {
    for (String _jsonString in loadedWebs) {
      WebPortal newSavedPage = new WebPortal("", "");
      newSavedPage.tryRead(_jsonString);
      if (newSavedPage.url.length > 0) {
        readWebs.add(newSavedPage);
      }
    }
  } catch (ex) {
    saveLogs.error(ex);
  }

  return readWebs;
}
