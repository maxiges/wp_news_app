import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Utils/ColorsFunc.dart';
import '../Utils/SaveLogs.dart';

class WebPortal {
  String url;
  String decColor;

  WebPortal(this.url, this.decColor);

  Color getColor() {
    return Color_GetColor(this.decColor);
  }

  void tryRead(String JsonString) {
    try {
      Map<String, dynamic> user = jsonDecode(JsonString);
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
    final databaseReference = Firestore.instance;
    await databaseReference
        .collection("dataFromBase")
        .document(Global_GoogleSign.getGoogleUserEmail())
        .setData({
      'id': Global_GoogleSign.getGoogleUserEmail(),
      'description': data
    });
  } catch (ex) {
    saveLogs.error(ex);
  }
}

Future<List<String>> _loadDataFromFirebase() async {
  try {
    final databaseReference = Firestore.instance;
    DocumentSnapshot retval = await databaseReference
        .collection("dataFromBase")
        .document(Global_GoogleSign.getGoogleUserEmail())
        .get();
    List<String> valll = retval.data["description"].toString().split(";");
    return valll;
  } catch (ex) {
    saveLogs.error(ex);
  }
}

Future<bool> WebPortal_saveWebs(List<WebPortal> list) async {
  List<String> objSave = new List<String>();

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

Future<List<WebPortal>> WebPortal_loadWebs() async {
  List<String> loadedWebs = new List<String>();
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (Global_GoogleSign.googleUserIsSignIn() == true) {
    try {
      loadedWebs = await _loadDataFromFirebase();
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

  List<WebPortal> readWebs = new List<WebPortal>();
  try {
    for (String JsonString in loadedWebs) {
      WebPortal newSavedPage = new WebPortal("", "");
      newSavedPage.tryRead(JsonString);
      if (newSavedPage.url.length > 0) {
        readWebs.add(newSavedPage);
      }
    }
  } catch (ex) {
    saveLogs.error(ex);
  }

  return readWebs;
}
