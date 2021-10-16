import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Utils/ColorsFunc.dart';
import '../Utils/StringUtils.dart';
import '../Utils/SaveLogs.dart';

List<WebsiteInfo> readWebsData = [];

class WebsiteInfoDetails {
  String fullArticle = "";

  WebsiteInfoDetails({
    this.fullArticle = "N/A",
  }) {
    this.fullArticle = StringUtils_RemoveAllHTMLVal(this.fullArticle, true);
  }
}

class WebsiteInfo {
  String url = "",
      tittle = "",
      thumbnailUrlLink = Global_NoImagePost,
      articleDate = "",
      descriptionBrief = "";
  WebsiteInfoDetails articleDetails = WebsiteInfoDetails();
  String providerColorAccent = "";
  String domain = "";
  String articleID = "";

  WebsiteInfo({
    this.url = "",
    this.tittle = "",
    this.thumbnailUrlLink = "",
    this.articleDate = "",
    this.providerColorAccent = "",
    this.descriptionBrief = "",
    this.articleID = "",
    this.domain = "",
    this.articleDetails,
  }) {
    this.tittle = StringUtils_RemoveAllHTMLVal(this.tittle, false);
    this.descriptionBrief = StringUtils_RemoveAllHTMLVal(this.descriptionBrief, false);
    if (this.thumbnailUrlLink.length < 5) {
      this.thumbnailUrlLink = Global_NoImagePost;
    }

    if (this.articleDetails == null) {
      this.articleDetails = new WebsiteInfoDetails();
    }
  }

  Color getColor() {
    return Color_GetColor(this.providerColorAccent);
  }

  getColorText() {
    Color actColor;
    try {
      actColor = colorPalette[this.providerColorAccent];
    } catch (ex) {
      actColor = Colors.black;
    }
    return Color_getColorText(actColor);
  }

  tryParseJson(String jsonString) {
    Map<String, dynamic> user = jsonDecode(jsonString);

    try {
      this.articleDate = user["DATE"];
    } catch (ex) {
      this.articleDate = "";
    }

    try {
      this.url = user["URL"];
    } catch (ex) {
      this.url = "";
    }

    try {
      this.tittle = user["TITTLE"];
    } catch (ex) {
      this.tittle = "";
    }

    try {
      this.thumbnailUrlLink = user["HREF"];
    } catch (ex) {
      this.thumbnailUrlLink = "";
    }

    try {
      this.descriptionBrief = user["DESCRIPTION"];
    } catch (ex) {
      this.descriptionBrief = "";
    }

    try {
      this.providerColorAccent = user["LinkColor"];
    } catch (ex) {
      this.providerColorAccent = "";
    }

    try {
      this.domain = user["DOMAIN"];
    } catch (ex) {
      this.domain = "";
    }

    try {
      this.articleID = user["ID"];
    } catch (ex) {
      this.articleID = "";
    }
  }

  String toJson() {
    String jsonStr = '{ "DATE" : "' +
        this.articleDate.replaceAll("\n", "") +
        '", "URL" :"' +
        this.url.replaceAll("\n", "") +
        '", "DESCRIPTION" :"' +
        this.descriptionBrief.replaceAll("\n", "") +
        '", "TITTLE" :"' +
        this.tittle.replaceAll("\n", "") +
        '", "HREF" :"' +
        this.thumbnailUrlLink.replaceAll("\n", "") +
        '", "DOMAIN" :"' +
        this.domain.replaceAll("\n", "") +
        '", "ID" :"' +
        this.articleID.replaceAll("\n", "") +
        '", "LinkColor" :"' +
        this.providerColorAccent.replaceAll("\n", "") +
        '"}';

    return jsonStr;
  }

  void launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
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
    DocumentSnapshot retVal = await databaseReference
        .collection("dataFromBaseWebs")
        .document(Global_GoogleSign.getGoogleUserEmail())
        .get();
    List val = jsonDecode(retVal.data["description"].toString());

    List<String> list = [];

    for (int i = 0; i < val.length; i++) {
      list.add(val[i]);
    }

    return list;
  } catch (ex) {
    saveLogs.error(ex);
  }
  return  [];
}

Future<bool> webInfoSaveToFirebase(List<WebsiteInfo> webObj) async {
  List<String> objSave = [];
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
  List<WebsiteInfo> readWebs = [];
  List<String> loadedWebs = [];

  if (Global_GoogleSign.googleUserIsSignIn() == true) {
    loadedWebs = await _loadDataFromFirebase();
  } else {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    loadedWebs = prefs.getStringList("SaverURLS");
  }

  try {
    for (String _jsonString in loadedWebs) {
      WebsiteInfo newSavedPage = new WebsiteInfo();
      newSavedPage.tryParseJson(_jsonString);
      if (newSavedPage.tittle.length > 0) {
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
    if (iWeb.tittle == act.tittle && iWeb.url == act.url) {
      return i;
    }
    i++;
  }
  return -1;
}

Future<bool> webInfoLoadedWebSave() async {
  List<String> objSave = [];
  for (WebsiteInfo objectVal in readWebsData) {
    objSave.add(objectVal.toJson());
  }
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("SavePages");
  return prefs.setStringList("SavePages", objSave);
}

Future<bool> webInfoLoadedWebLoad() async {
  List<WebsiteInfo> readWebs = [];
  List<String> loadedWebs = [];
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  loadedWebs = prefs.getStringList("SavePages");
  try {
    for (String _jsonString in loadedWebs) {
      WebsiteInfo newSavedPage = new WebsiteInfo();
      newSavedPage.tryParseJson(_jsonString);
      bool tooOld = DateTime.parse(newSavedPage.articleDate)
          .isBefore(DateTime.now().subtract(Duration(days: 2)));
      if (newSavedPage.tittle.length > 0 && tooOld == false) {
        readWebs.add(newSavedPage);
      }
    }

    readWebs.sort((a, b) {
      DateTime dataA = DateTime.parse(a.articleDate);
      DateTime dataB = DateTime.parse(b.articleDate);
      return dataB.compareTo(dataA);
    });

    readWebsData = readWebs;
  } catch (ex) {
    saveLogs.error(ex);
  }
  return true;
}
