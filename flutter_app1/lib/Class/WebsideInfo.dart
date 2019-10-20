import '../main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

import '../Globals.dart';

import 'WebPortal.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class WebsideInfo {
  String URL = "", TITTLE = "", HREF = "", DATE = "", DESCRIPTION = "";
  String LinkColor = "";
  String DOMAIN = "";
  String ID = "";

  WebsideInfo(
      {this.URL = "",
      this.TITTLE = "",
      this.HREF = "",
      this.DATE = "",
      this.LinkColor = "",
      this.DESCRIPTION = "",
      this.ID = "",
      this.DOMAIN = ""}) {
    this.TITTLE = this.TITTLE.replaceAll("\u0105", "ą");
    this.TITTLE = this.TITTLE.replaceAll("\u0107", "ć");
    this.TITTLE = this.TITTLE.replaceAll("\u0119", "ę");
    this.TITTLE = this.TITTLE.replaceAll("\u0142", "ł");
    this.TITTLE = this.TITTLE.replaceAll("\u0144", "ń");
    this.TITTLE = this.TITTLE.replaceAll("\u00f3", "ó");
    this.TITTLE = this.TITTLE.replaceAll("\u015b", "ś");
    this.TITTLE = this.TITTLE.replaceAll("\u017a", "ź");
    this.TITTLE = this.TITTLE.replaceAll("\u017c", "ż");

    this.DESCRIPTION = this.DESCRIPTION.replaceAll("\u0105", "ą");
    this.DESCRIPTION = this.DESCRIPTION.replaceAll("\u0107", "ć");
    this.DESCRIPTION = this.DESCRIPTION.replaceAll("\u0119", "ę");
    this.DESCRIPTION = this.DESCRIPTION.replaceAll("\u0142", "ł");
    this.DESCRIPTION = this.DESCRIPTION.replaceAll("\u0144", "ń");
    this.DESCRIPTION = this.DESCRIPTION.replaceAll("\u00f3", "ó");
    this.DESCRIPTION = this.DESCRIPTION.replaceAll("\u015b", "ś");
    this.DESCRIPTION = this.DESCRIPTION.replaceAll("\u017a", "ź");
    this.DESCRIPTION = this.DESCRIPTION.replaceAll("\u017c", "ż");

    this.TITTLE = this.TITTLE.replaceAll("\r", "");
    this.TITTLE = this.TITTLE.replaceAll("\n", "");

    this.TITTLE = this.TITTLE.replaceAll("&#8211;", " ");
    this.DESCRIPTION = this.DESCRIPTION.replaceAll("&#8211;", " ");
    this.TITTLE = this.TITTLE.replaceAll("&#8217;", " ");
    this.DESCRIPTION = this.DESCRIPTION.replaceAll("&#8217;", " ");
    this.TITTLE = this.TITTLE.replaceAll("&#8230;", " ");
    this.DESCRIPTION = this.DESCRIPTION.replaceAll("&#8230;", " ");
    this.TITTLE = this.TITTLE.replaceAll("&#8222;", " ");
    this.DESCRIPTION = this.DESCRIPTION.replaceAll("&#8222;", " ");
    this.TITTLE = this.TITTLE.replaceAll("&#8221;", " ");
    this.DESCRIPTION = this.DESCRIPTION.replaceAll("&#8221;", " ");

    this.TITTLE = this.TITTLE.replaceAll("<p>", " ");
    this.DESCRIPTION = this.DESCRIPTION.replaceAll("<p>", " ");
    this.TITTLE = this.TITTLE.replaceAll("</p>", " ");
    this.DESCRIPTION = this.DESCRIPTION.replaceAll("</p>", " ");

    this.TITTLE = this.TITTLE.replaceAll("[&hellip;]", " ");
    this.DESCRIPTION = this.DESCRIPTION.replaceAll("[&hellip;]", " ");

    this.DESCRIPTION = this.DESCRIPTION.replaceAll("\r", "");
    this.DESCRIPTION = this.DESCRIPTION.replaceAll("\n", "");
  }

  Color getColor() {
    try {
      return colorPalet[this.LinkColor];
    } catch (ex) {}
    return Colors.black;
  }

  WebsideInfo_tryRead(String JsonString) {
    Map<String, dynamic> user = jsonDecode(JsonString);

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
      this.HREF = user["HREF"];
    } catch (ex) {
      this.HREF = "";
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

  String ToJsonString() {
    String JsonStr = '{ "DATE" : "' +
        this.DATE.replaceAll("\n", "") +
        '", "URL" :"' +
        this.URL.replaceAll("\n", "") +
        '", "DESCRIPTION" :"' +
        this.DESCRIPTION.replaceAll("\n", "") +
        '", "TITTLE" :"' +
        this.TITTLE.replaceAll("\n", "") +
        '", "HREF" :"' +
        this.HREF.replaceAll("\n", "") +
        '", "DOMAIN" :"' +
        this.DOMAIN.replaceAll("\n", "") +
        '", "ID" :"' +
        this.ID.replaceAll("\n", "") +
        '", "LinkColor" :"' +
        this.LinkColor.replaceAll("\n", "") +
        '"}';

    return JsonStr;
  }
}

Future<List<WebsideInfo>> GetWebsideInfos(WebPortal WEB) async {
  List<WebsideInfo> websideCheeck = new List<WebsideInfo>();
  try {
    try {
      final response =
          await http.get("https://" + WEB.url + "/wp-json/wp/v2/posts?_embed");
      if (response.statusCode == 200) {
        List<dynamic> retJson = json.decode(response.body);
        for (dynamic items in retJson) {
          try {
            dynamic imagersc = "";
            String m_article_tittle = "N/A";
            String m_article_descrip = "N/A";
            String PostComments = "N/A";
            String m_id = "";

            try {
              imagersc = items['_embedded']['wp:featuredmedia'][0]
                  ['media_details']['sizes']['medium']['source_url'];
            } catch (ex) {}
            try {
              m_article_tittle = items['title']['rendered'];
            } catch (ex) {}
            try {
              m_article_descrip = items['excerpt']['rendered'];
            } catch (ex) {}
            try {
              PostComments = items['_links']['replies'][0]['href'].toString();
            } catch (ex) {}
            try {
              m_id = PostComments.substring(PostComments.lastIndexOf("=") + 1);
            } catch (ex) {}

            websideCheeck.add(new WebsideInfo(
                URL: items['link'],
                TITTLE: m_article_tittle,
                HREF: imagersc,
                DATE: items['date'],
                LinkColor: GetStringColor(WEB.getColor()),
                DESCRIPTION: m_article_descrip,
                ID: m_id,
                DOMAIN: WEB.url));
          } catch (ex) {}
        }
      }
    } catch (ex) {
      print("Load Page error :" + ex);
    }
    websideCheeck.sort((a, b) {
      if (DateTime.parse(a.DATE).isBefore(DateTime.parse(b.DATE)) == true)
        return 1;
      else
        return 0;
    });
  } catch (ex) {
    print(ex);
  }
  return websideCheeck;
}

void launchURL(String URL) async {
  if (await canLaunch(URL)) {
    await launch(URL);
  } else {
    throw 'Could not launch $URL';
  }
}

void _SaveDataToFirebase(String data) async {
  try {
    final databaseReference = Firestore.instance;
    await databaseReference
        .collection("dataFromBaseWebs")
        .document(Global_googleUser.email)
        .setData({'id': Global_googleUser.email, 'description': data});
  } catch (ex) {
    assert(ex);
  }
}

Future<List<String>> _LoadDataToFirebase() async {
  try {
    final databaseReference = Firestore.instance;
    DocumentSnapshot retval = await databaseReference
        .collection("dataFromBaseWebs")
        .document(Global_googleUser.email)
        .get();
    List val = jsonDecode(retval.data["description"].toString());

    List<String> list = new List<String>();

    for (int i = 0; i < val.length; i++) {
      list.add(val[i]);
    }

    return list;
  } catch (ex) {
    assert(ex);
  }
}

Future<bool> save_WebsideArch(List<WebsideInfo> webObj) async {
  List<String> ObjSave = new List<String>();
  for (WebsideInfo objectVal in webObj) {
    ObjSave.add(objectVal.ToJsonString());
  }

  if (Global_googleUser != null) {
    _SaveDataToFirebase(jsonEncode(ObjSave));
  } else {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("SaverURLS");
    return prefs.setStringList("SaverURLS", ObjSave);
  }
}

Future<List<WebsideInfo>> load_WebsideArch() async {
  List<WebsideInfo> redadWebs = new List<WebsideInfo>();
  List<String> loadedWevs = new List<String>();

  if (Global_googleUser != null) {
    loadedWevs = await _LoadDataToFirebase();
  } else {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    loadedWevs = prefs.getStringList("SaverURLS");
  }

  try {
    for (String JsonString in loadedWevs) {
      WebsideInfo newSavedPage = new WebsideInfo();
      newSavedPage.WebsideInfo_tryRead(JsonString);
      if (newSavedPage.TITTLE.length > 0) {
        redadWebs.add(newSavedPage);
      }
    }
  } catch (ex) {
    print(ex.toString());
  }

  return redadWebs;
}

Animatable<Color> background = TweenSequence<Color>(
  [
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Colors.black,
        end: Colors.white,
      ),
    ),
  ],
);

int savedFileContainsThisWebside(WebsideInfo p_act) {
  int i = 0;
  for (WebsideInfo iter in Global_savedWebside) {
    if (iter.TITTLE == p_act.TITTLE && iter.URL == p_act.URL) {
      return i;
    }
    i++;
  }
  return -1;
}
