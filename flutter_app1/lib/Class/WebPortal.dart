import '../main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

void _SaveDataToFirebase(String data) async {
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
    assert(ex);
  }
}

Future<List<String>> _LoadDataFromFirebase() async {
  try {
    final databaseReference = Firestore.instance;
    DocumentSnapshot retval = await databaseReference
        .collection("dataFromBase")
        .document(Global_GoogleSign.getGoogleUserEmail())
        .get();
    List<String> valll = retval.data["description"].toString().split(";");
    return valll;
  } catch (ex) {
    assert(ex);
  }
}

Future<bool> saveWebPorts(List<WebPortal> list) async {
  List<String> objSave = new List<String>();

  for (WebPortal objectVal in list) {
    objSave.add(objectVal.toJson());
  }

  if (Global_GoogleSign.GoogleUserIsSignIn() == true) {
    try {
      _SaveDataToFirebase(
          objSave.reduce((value, element) => value + ';' + element));
    } catch (ex) {
      assert(ex);
    }
  }
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("SavedWebs");
  return prefs.setStringList("SavedWebs", objSave);
}

Future<List<WebPortal>> loadWebPorts() async {
  List<String> loadedWevs = new List<String>();
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (Global_GoogleSign.GoogleUserIsSignIn() == true) {
    try {
      loadedWevs = await _LoadDataFromFirebase();
    } catch (ex) {
      assert(ex);
    }
  } else {
    try {
      loadedWevs = prefs.getStringList("SavedWebs");
    } catch (ex) {
      assert(ex);
    }
  }

  List<WebPortal> redadWebs = new List<WebPortal>();
  try {
    for (String JsonString in loadedWevs) {
      WebPortal newSavedPage = new WebPortal("", "");
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
