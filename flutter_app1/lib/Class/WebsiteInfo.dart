import 'package:WP_news_APP/Class/WebPortal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Globals.dart';
import '../Utils/ColorsFunc.dart';
import '../Utils/StringUtils.dart';
import '../Utils/SaveLogs.dart';
import 'Firebase.dart';

List<WebsiteInfo> readWebsData = [];

class WebsiteInfoDetails {
  String fullArticle = "";
  WebsiteInfoDetails({
    this.fullArticle = "N/A",
  }) {
    this.fullArticle = StringUtils_RemoveAllHTMLVal(this.fullArticle, true);
  }

  Map<String, dynamic> toJson() => {
        'fullArticle': fullArticle,
      };

  fromJson(Map<String, dynamic> json) {
    try {
      this.fullArticle = json['fullArticle'];
    } catch (ex) {
      this.fullArticle = "NA";
    }
  }
}

class WebsiteInfo {
  String url = "",
      tittle = "",
      thumbnailUrlLink = Global_NoImagePost,
      articleDate = "",
      descriptionBrief = "";
  WebsiteInfoDetails? articleDetails = WebsiteInfoDetails();
  String providerColorAccent = "";
  String domain = "";
  String articleID = "";
  PortalType portalType = PortalType.Other;
  List<String> imgsInArticle = [];

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
    this.imgsInArticle = const [],
    required this.portalType,
  }) {
    this.tittle = StringUtils_RemoveAllHTMLVal(this.tittle, false);
    this.descriptionBrief =
        StringUtils_RemoveAllHTMLVal(this.descriptionBrief, false);
    if (this.thumbnailUrlLink.length < 5) {
      this.thumbnailUrlLink = Global_NoImagePost;
    }
    if (this.imgsInArticle == null) {
      this.imgsInArticle = [];
    }

    if (this.articleDetails == null) {
      this.articleDetails = new WebsiteInfoDetails();
    }
  }

  Color getColor() {
    return Color_GetColor(this.providerColorAccent);
  }

  getColorText() {
    Color? actColor;
    try {
      actColor = colorPalette[this.providerColorAccent];
    } catch (ex) {
      actColor = Colors.black;
    }
    return Color_getColorText(actColor!);
  }

  fromJson(Map<String, dynamic> json) {
    try {
      this.url = json['url'];
      this.tittle = json['tittle'];
      this.thumbnailUrlLink = json['thumbnailUrlLink'];
      this.articleDate = json['articleDate'];
      this.providerColorAccent = json['providerColorAccent'];
      this.descriptionBrief = json['descriptionBrief'];
      this.articleID = json['articleID'];
      this.domain = json['domain'];
      try {
        this.articleDetails = WebsiteInfoDetails();
        this.articleDetails?.fromJson(json['articleDetails']);
      } catch (ex) {
        saveLogs.error(ex.toString());
      }
      this.portalType = PortalType.values.byName(json['portalType']);
    } catch (ex) {
      saveLogs.error(ex.toString());
    }
  }

  Map<String, dynamic> toJson() => {
        'url': url,
        'tittle': tittle,
        'thumbnailUrlLink': thumbnailUrlLink,
        'articleDate': articleDate,
        'providerColorAccent': providerColorAccent,
        'descriptionBrief': descriptionBrief,
        'articleID': articleID,
        'domain': domain,
        'articleDetails': articleDetails,
        'portalType': portalType.name,
      };

  WebsiteInfo tryParseJson(String jsonString) {
    Map<String, dynamic> _websiteData = jsonDecode(jsonString);
    this.fromJson(_websiteData);
    return this;
  }

  String toStringJson() {
    Map<String, dynamic> jsonObj = this.toJson();
    String jsonString = jsonEncode(jsonObj);
    return jsonString;
  }

  void launchURL() async {
    Uri findURl = Uri.parse(url);
    if (await canLaunchUrl(findURl)) {
      await launchUrl(findURl);
    } else {
      throw 'Could not launch $url';
    }
  }
} //class

void _saveDataToFirebase(String data) async {
  try {
    DataFromWebsDb d =
        DataFromWebsDb(Global_GoogleSign.getGoogleUserEmail(), data);
    fbDataFromBaseWebsRef.doc(d.id).update(d.toJson());
  } catch (ex) {
    saveLogs.error(ex.toString());
  }
}

Future<List<String>> _loadDataFromFirebase() async {
  try {
    final retDoc = await fbDataFromBaseWebsRef
        .doc(Global_GoogleSign.getGoogleUserEmail())
        .get();
    List val = jsonDecode(retDoc.data()!.description);
    List<String> list = [];
    for (int i = 0; i < val.length; i++) {
      list.add(val[i]);
    }

    return list;
  } catch (ex) {
    saveLogs.error(ex.toString());
  }
  return [];
}

Future<bool> webInfoSaveToFirebase(List<WebsiteInfo> webObj) async {
  List<String> objSave = [];
  for (WebsiteInfo objectVal in webObj) {
    objSave.add(objectVal.toStringJson());
  }

  if (Global_GoogleSign.googleUserIsSignIn() == true) {
    try {
      _saveDataToFirebase(jsonEncode(objSave));
    } catch (ex) {
      saveLogs.error(ex.toString());
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
    List<String>? resp = prefs.getStringList("SaverURLS");
    if (resp != null) {
      loadedWebs = resp;
    }
  }

  try {
    for (String _jsonString in loadedWebs) {
      WebsiteInfo newSavedPage = new WebsiteInfo(portalType: PortalType.Other);
      newSavedPage = newSavedPage.tryParseJson(_jsonString);
      if (newSavedPage.tittle.length > 0) {
        readWebs.add(newSavedPage);
      }
    }
  } catch (ex) {
    saveLogs.error(ex.toString());
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
    objSave.add(objectVal.toStringJson());
  }
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("SavePages");
  return prefs.setStringList("SavePages", objSave);
}

Future<bool> webInfoLoadedWebLoad() async {
  List<WebsiteInfo> readWebs = [];
  List<String> loadedWebs = [];
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? p = prefs.getStringList("SavePages");
  if (p != null) {
    loadedWebs = p;
  }

  try {
    for (String _jsonString in loadedWebs) {
      WebsiteInfo newSavedPage = new WebsiteInfo(portalType: PortalType.Other);
      newSavedPage = newSavedPage.tryParseJson(_jsonString);
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
    saveLogs.error(ex.toString());
  }
  return true;
}
