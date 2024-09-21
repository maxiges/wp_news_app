
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
  late PortalType portalType;
  bool isInvalid = false;
  String requestTime ="";
  int articlesRead =5;

  WebPortal(this.url, this.decColor, PortalType? portalType,  this.articlesRead  ) {
    this.portalType = PortalType.Wordpress;
    if (portalType != null) {
      this.portalType = portalType;
    }
  }

  setIsInvalid() {
    this.isInvalid = true;
  }

  setQueryTime(String value) {
    this.requestTime = value;
  }

  Color getColor() {
    return Color_GetColor(this.decColor);
  }

  void tryRead(String jsonString) {
    try {
      Map<String, dynamic> jsonObj = jsonDecode(jsonString);
      try {
        fromJson(jsonObj);
      } catch (ex) {
        this.portalType = PortalType.Wordpress;
      }
    } catch (ex) {
      this.url = "";
      this.decColor = "red";
      this.portalType = PortalType.Wordpress;
    }
  }

  String toJsonString() {
    Map<String, dynamic> jsonObj = this.toJson();
    String jsonString = jsonEncode(jsonObj);
    return jsonString;
  }

  fromJson(Map<String, dynamic> json) {
    try {
      this.url = json['URL'];
    } catch (ex) {
      this.url = "";
    }
    try {
      this.decColor = json['Color'];
    } catch (ex) {
      this.decColor = "";
    }
    try {
      this.portalType = PortalType.values.byName(json['PortalType']);
    } catch (ex) {
      this.portalType = PortalType.Other;
    }
  }

  Map<String, dynamic> toJson() => {
        'URL': url,
        'Color': decColor,
        'PortalType': portalType.name,
      };
} //class  WebPortal

void _saveDataToFirebase(String data) async {
  try {
    DataFromDb d = DataFromDb(Global_GoogleSign.getGoogleUserEmail(), data);
    fbDataFromBaseRef.doc(d.id).update(d.toJson());
  } catch (ex) {
    saveLogs.error(ex.toString());
  }
}

Future<List<DataFromDb>> _loadDataFromFirebase() async {
  try {
    List<DataFromDb> retList = [];
    final users = await fbDataFromBaseRef
        .doc(Global_GoogleSign.getGoogleUserEmail())
        .get();
    retList.add(users.data()!);
    return retList;
  } catch (ex) {
    saveLogs.error(ex.toString());
  }
  return [];
}

Future<bool> webPortalSaveWebs(List<WebPortal> list) async {
  List<String> objSave = [];
  for (WebPortal objectVal in list) {
    objSave.add(objectVal.toJsonString());
  }
  if (Global_GoogleSign.googleUserIsSignIn() == true) {
    try {
      _saveDataToFirebase(
          objSave.reduce((value, element) => value + ';' + element));
    } catch (ex) {
      saveLogs.error(ex.toString());
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
      saveLogs.error(ex.toString());
    }
  } else {
    try {
      loadedWebs = prefs.getStringList("SavedWebs")!;
    } catch (ex) {
      saveLogs.error(ex.toString());
    }
  }

  List<WebPortal> readWebs = [];
  try {
    for (String _jsonString in loadedWebs) {
      WebPortal newSavedPage = new WebPortal("", "", null, 5);
      newSavedPage.tryRead(_jsonString);
      if (newSavedPage.url.length > 0) {
        readWebs.add(newSavedPage);
      }
    }
  } catch (ex) {
    saveLogs.error(ex.toString());
  }

  return readWebs;
}

enum PortalType {
  Wordpress,
  DywanikPL,
  PrawoPL,
  GolangNews,
  Other,
}

Map<String, PortalType> mapPTStoEnum = {
  "Wordpress": PortalType.Wordpress,
  "DywanikPL": PortalType.DywanikPL,
  "PrawoPL": PortalType.PrawoPL,
  "GolangNews": PortalType.GolangNews,
  "Other": PortalType.Other,
};

String getPortalTypeString(PortalType pt) {
  var result = "Other";
  mapPTStoEnum.forEach((k, v) {
    if (v.toString() == pt.toString()) {
      result = k;
      return;
    }
  });
  return result;
}

PortalType getPortalTypeFromString(String pt) {
  var result = PortalType.Other;
  mapPTStoEnum.forEach((k, v) {
    if (k == pt) {
      result = v;
      return;
    }
  });
  return result;
}

List<String> getPortalTypeStringList() {
  List<String> result = [];
  mapPTStoEnum.forEach((k, v) {
    result.add(k);
  });
  return result;
}
