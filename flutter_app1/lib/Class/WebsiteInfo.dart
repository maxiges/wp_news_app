import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Globals.dart';
import 'WebPortal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Utils/ColorsFunc.dart';
import '../Utils/StringUtils.dart';
import '../Utils/SaveLogs.dart';

List<WebsiteInfo> readedWebs = new List<WebsiteInfo>();

class WebsiteInfoDetails {
  String WEB_ALL_PAGE = "";

  WebsiteInfoDetails({
    this.WEB_ALL_PAGE = "N/A",
  }) {
    this.WEB_ALL_PAGE = StringUtils_RemoveAllHTMLVal(this.WEB_ALL_PAGE, true);
  }
}

class WebsiteInfo {
  String URL = "",
      TITTLE = "",
      IMAGEHREF = Global_NoImagePost,
      DATE = "",
      DESCRIPTION = "";
  WebsiteInfoDetails WEB_DETAILS = WebsiteInfoDetails();
  String LinkColor = "";
  String DOMAIN = "";
  String ID = "";

  WebsiteInfo({
    this.URL = "",
    this.TITTLE = "",
    this.IMAGEHREF = "",
    this.DATE = "",
    this.LinkColor = "",
    this.DESCRIPTION = "",
    this.ID = "",
    this.DOMAIN = "",
    this.WEB_DETAILS = null,
  }) {
    this.TITTLE = StringUtils_RemoveAllHTMLVal(this.TITTLE, false);
    this.DESCRIPTION = StringUtils_RemoveAllHTMLVal(this.DESCRIPTION, false);
    if (this.IMAGEHREF.length < 5) {
      this.IMAGEHREF = Global_NoImagePost;
    }

    if (this.WEB_DETAILS == null) {
      this.WEB_DETAILS = new WebsiteInfoDetails();
    }
  }

  Color getColor() {
    return Color_GetColor(this.LinkColor);
  }

  getColorText() {
    Color actColor;
    try {
      actColor = colorPalet[this.LinkColor];
    } catch (ex) {
      actColor = Colors.black;
    }
    return Color_getColorText(actColor);
  }

  tryParseJson(String jsonString) {
    Map<String, dynamic> user = jsonDecode(jsonString);

    try {
      this.DATE = user["DATE"];
    } catch (ex) {
      this.DATE = "";
    }

    try {
      this.URL = user["URL"];
    } catch (ex) {
      this.URL = "";
    }

    try {
      this.TITTLE = user["TITTLE"];
    } catch (ex) {
      this.TITTLE = "";
    }

    try {
      this.IMAGEHREF = user["HREF"];
    } catch (ex) {
      this.IMAGEHREF = "";
    }

    try {
      this.DESCRIPTION = user["DESCRIPTION"];
    } catch (ex) {
      this.DESCRIPTION = "";
    }

    try {
      this.LinkColor = user["LinkColor"];
    } catch (ex) {
      this.LinkColor = "";
    }

    try {
      this.DOMAIN = user["DOMAIN"];
    } catch (ex) {
      this.DOMAIN = "";
    }

    try {
      this.ID = user["ID"];
    } catch (ex) {
      this.ID = "";
    }
  }

  String toJson() {
    String jsonStr = '{ "DATE" : "' +
        this.DATE.replaceAll("\n", "") +
        '", "URL" :"' +
        this.URL.replaceAll("\n", "") +
        '", "DESCRIPTION" :"' +
        this.DESCRIPTION.replaceAll("\n", "") +
        '", "TITTLE" :"' +
        this.TITTLE.replaceAll("\n", "") +
        '", "HREF" :"' +
        this.IMAGEHREF.replaceAll("\n", "") +
        '", "DOMAIN" :"' +
        this.DOMAIN.replaceAll("\n", "") +
        '", "ID" :"' +
        this.ID.replaceAll("\n", "") +
        '", "LinkColor" :"' +
        this.LinkColor.replaceAll("\n", "") +
        '"}';

    return jsonStr;
  }

  void launchURL() async {
    if (await canLaunch(URL)) {
      await launch(URL);
    } else {
      throw 'Could not launch $URL';
    }
  }
} //class

void _saveDataToFirebase(String data) async {
  try {
    final databaseReference = Firestore.instance;
    await databaseReference
        .collection("dataFromBaseWebs")
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
        .collection("dataFromBaseWebs")
        .document(Global_GoogleSign.getGoogleUserEmail())
        .get();
    List val = jsonDecode(retval.data["description"].toString());

    List<String> list = new List<String>();

    for (int i = 0; i < val.length; i++) {
      list.add(val[i]);
    }

    return list;
  } catch (ex) {
    saveLogs.error(ex);
  }
}

Future<bool> webInfoSaveToFirebase(List<WebsiteInfo> webObj) async {
  List<String> objSave = new List<String>();
  for (WebsiteInfo objectVal in webObj) {
    objSave.add(objectVal.toJson());
  }

  if (Global_GoogleSign.googleUserIsSignIn() == true) {
    try {
      _saveDataToFirebase(jsonEncode(objSave));
    } catch (ex) {
      saveLogs.error(ex);
    }
  }

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("SaverURLS");
  return prefs.setStringList("SaverURLS", objSave);
}

Future<List<WebsiteInfo>> webInfoLoadFromFirebase() async {
  List<WebsiteInfo> readWebs = new List<WebsiteInfo>();
  List<String> loadedWebs = new List<String>();

  if (Global_GoogleSign.googleUserIsSignIn() == true) {
    loadedWebs = await _loadDataFromFirebase();
  } else {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    loadedWebs = prefs.getStringList("SaverURLS");
  }

  try {
    for (String JsonString in loadedWebs) {
      WebsiteInfo newSavedPage = new WebsiteInfo();
      newSavedPage.tryParseJson(JsonString);
      if (newSavedPage.TITTLE.length > 0) {
        readWebs.add(newSavedPage);
      }
    }
  } catch (ex) {
    saveLogs.error(ex);
  }

  return readWebs;
}

int savedFileContainsThisWeb(WebsiteInfo act) {
  int i = 0;
  for (WebsiteInfo iWeb in Global_savedWebsList) {
    if (iWeb.TITTLE == act.TITTLE && iWeb.URL == act.URL) {
      return i;
    }
    i++;
  }
  return -1;
}

Future<bool> webInfoLoadedWebSave() async {
  List<String> objSave = new List<String>();
  for (WebsiteInfo objectVal in readedWebs) {
    objSave.add(objectVal.toJson());
  }
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("SavePages");
  return prefs.setStringList("SavePages", objSave);
}

Future<bool> webInfoLoadedWebLoad() async {
  List<WebsiteInfo> readWebs = new List<WebsiteInfo>();
  List<String> loadedWebs = new List<String>();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  loadedWebs = prefs.getStringList("SavePages");
  try {
    for (String JsonString in loadedWebs) {
      WebsiteInfo newSavedPage = new WebsiteInfo();
      newSavedPage.tryParseJson(JsonString);
      bool tooOld = DateTime.parse(newSavedPage.DATE)
          .isBefore(DateTime.now().subtract(Duration(days: 2)));
      if (newSavedPage.TITTLE.length > 0 && tooOld == false) {
        readWebs.add(newSavedPage);
      }
    }

    readWebs.sort((a, b) {
      DateTime dataA = DateTime.parse(a.DATE);
      DateTime dataB = DateTime.parse(b.DATE);
      return dataB.compareTo(dataA);
    });

    readedWebs = readWebs;
  } catch (ex) {
    saveLogs.error(ex);
  }
  return true;
}
