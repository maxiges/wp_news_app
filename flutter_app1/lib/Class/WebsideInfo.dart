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

List<WebsideInfo> readedWebs = new List<WebsideInfo>();



class WebsideInfo {
  String URL = "",
      TITTLE = "",
      IMAGEHREF = Global_NoImagePost,
      DATE = "",
      DESCRIPTION = "";
  String LinkColor = "";
  String DOMAIN = "";
  String ID = "";

  WebsideInfo(
      {this.URL = "",
      this.TITTLE = "",
      this.IMAGEHREF = "",
      this.DATE = "",
      this.LinkColor = "",
      this.DESCRIPTION = "",
      this.ID = "",
      this.DOMAIN = ""}) {
    this.TITTLE = StringUtils_RemoveAllHTMLVal(this.TITTLE);
    this.DESCRIPTION = StringUtils_RemoveAllHTMLVal(this.DESCRIPTION);

    if (this.IMAGEHREF.length < 5) {
      this.IMAGEHREF = Global_NoImagePost;
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

Future<List<WebsideInfo>> WebsideInfo_GetWebInfos(WebPortal web) async {
  List<WebsideInfo> websCheckList = new List<WebsideInfo>();
  try {
    try {
      final response =
          await http.get("https://" + web.url + "/wp-json/wp/v2/posts?_embed");
      if (response.statusCode == 200) {
        List<dynamic> retJson = json.decode(response.body);
        for (dynamic items in retJson) {
          try {
            dynamic imaSrc = "";
            String _articleTittle = "N/A";
            String _articleDesc = "N/A";
            String _postComments = "N/A";
            String _id = "";

            try {
              imaSrc = items['_embedded']['wp:featuredmedia'][0]
                  ['media_details']['sizes']['medium']['source_url'];
            } catch (ex) {}
            try {
              _articleTittle = items['title']['rendered'];
            } catch (ex) {}
            try {
              _articleDesc = items['excerpt']['rendered'];
            } catch (ex) {}
            try {
              _postComments = items['_links']['replies'][0]['href'].toString();
            } catch (ex) {}
            try {
              _id = _postComments.substring(_postComments.lastIndexOf("=") + 1);
            } catch (ex) {}

            websCheckList.add(new WebsideInfo(
                URL: items['link'],
                TITTLE: _articleTittle,
                IMAGEHREF: imaSrc,
                DATE: items['date'],
                LinkColor: Color_GetColorInString(web.getColor()),
                DESCRIPTION: _articleDesc,
                ID: _id,
                DOMAIN: web.url));
          } catch (ex) {}
        }
      }
    } catch (ex) {
      print("Load Page error :" + ex);
    }
    websCheckList.sort((a, b) {
      if (DateTime.parse(a.DATE).isBefore(DateTime.parse(b.DATE)) == true)
        return 1;
      else
        return 0;
    });
  } catch (ex) {
    print(ex);
  }
  return websCheckList;
}



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
    assert(ex);
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
    saveLogs.write(ex);
  }
}

Future<bool> WebsideInfo_save(List<WebsideInfo> webObj) async {
  List<String> ObjSave = new List<String>();
  for (WebsideInfo objectVal in webObj) {
    ObjSave.add(objectVal.toJson());
  }

  if (Global_GoogleSign.googleUserIsSignIn() == true) {
    try {
      _saveDataToFirebase(jsonEncode(ObjSave));
    } catch (ex) {
      assert(ex);
    }
  }

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("SaverURLS");
  return prefs.setStringList("SaverURLS", ObjSave);
}

Future<List<WebsideInfo>> WebsideInfo_load() async {
  List<WebsideInfo> readWebs = new List<WebsideInfo>();
  List<String> loadedWebs = new List<String>();

  if (Global_GoogleSign.googleUserIsSignIn() == true) {
    loadedWebs = await _loadDataFromFirebase();
  } else {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    loadedWebs = prefs.getStringList("SaverURLS");
  }

  try {
    for (String JsonString in loadedWebs) {
      WebsideInfo newSavedPage = new WebsideInfo();
      newSavedPage.tryParseJson(JsonString);
      if (newSavedPage.TITTLE.length > 0) {
        readWebs.add(newSavedPage);
      }
    }
  } catch (ex) {
    saveLogs.write(ex.toString());
  }

  return readWebs;
}

int savedFileContainsThisWebside(WebsideInfo act) {
  int i = 0;
  for (WebsideInfo iter in Global_savedWebsList) {
    if (iter.TITTLE == act.TITTLE && iter.URL == act.URL) {
      return i;
    }
    i++;
  }
  return -1;
}




Future<bool> WebsideInfo_loadedWeb_save() async {
  List<String> ObjSave = new List<String>();
  for (WebsideInfo objectVal in readedWebs) {
    ObjSave.add(objectVal.toJson());
  }
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("SavePages");
  return prefs.setStringList("SavePages", ObjSave);
}


Future<bool> WebsideInfo_loadedWeb_load() async {
  List<WebsideInfo> readWebs = new List<WebsideInfo>();
  List<String> loadedWebs = new List<String>();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  loadedWebs = prefs.getStringList("SavePages");
  try {
    for (String JsonString in loadedWebs) {
      WebsideInfo newSavedPage = new WebsideInfo();
      newSavedPage.tryParseJson(JsonString);
       bool tooOld = DateTime.parse(newSavedPage.DATE).isBefore(DateTime.now().subtract(Duration(days: 2)));
      if (newSavedPage.TITTLE.length > 0 && tooOld==false) {
        readWebs.add(newSavedPage);
      }
    }

    readedWebs = readWebs;
  } catch (ex) {
    saveLogs.write(ex.toString());
  }


}
