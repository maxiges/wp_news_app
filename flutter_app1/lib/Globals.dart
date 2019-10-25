import 'Class/WebsideInfo.dart';
import 'dart:async';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Class/WebPortal.dart';
import 'package:package_info/package_info.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Elements/GoogleSignIn.dart';
import "HomePage.dart";

enum ACT_PAGE { none, LOADED_PAGES, SAVED_PAGES, SETTINGS }

List<WebPortal> Global_webList = new List<WebPortal>();
List<WebsideInfo> Global_savedWebside = new List<WebsideInfo>();

double Global_width = 0;
double Global_height = 0;
Timer Global_timer;
bool Global_RefreshPage = false;

ACT_PAGE Global_ACT_TO_REFRESH = ACT_PAGE.LOADED_PAGES;

MyHomePage Global_MyHomePage = new MyHomePage(title: 'WP news APP');

PackageInfo Global_packageInfo;
GoogleSign Global_GoogleSign = new GoogleSign();

const String Global_NoImageAvater =
    "https://secure.gravatar.com/avatar/d187e7d1ad82bca50f490848dc98f1e3?s=96&d=mm&r=g";
const String Global_NoImagePost =
    "https://icon-library.net/images/no-image-available-icon/no-image-available-icon-6.jpg";
Map<String, Color> colorPalet = {
  "black": Colors.black,
  "black26": Colors.black26,
  "grey": Colors.grey,
  "white": Colors.white,
  "red": Colors.red,
  "redAccent": Colors.redAccent,
  "orangeDip": Colors.deepOrange,
  "orange": Colors.orange,
  "yellow": Colors.yellow,
  "yellowAccent": Colors.yellowAccent,
  "green": Colors.green,
  "greenAccent": Colors.greenAccent,
  "blue": Colors.blue,
  "blueAccent": Colors.blueAccent,
  "purple": Colors.deepPurple,
};

LoadFromStorage() async {
  Global_webList = await loadWebPorts();
  Global_savedWebside = await load_WebsideArch();
}

String GetStringColor(Color color) {
  String findname = "black";
  int listnb = 0;
  int number = -1;
  for (Color colorval in colorPalet.values.toList()) {
    if (colorval.value == color.value) {
      number = listnb;
      break;
    }
    listnb++;
  }
  if (number > 0) {
    return colorPalet.keys.toList()[number];
  }
  return findname;
}

String RemoveAllHTMLVal(String str) {
  str = str.replaceAll("\u0105", "ą");
  str = str.replaceAll("\u0107", "ć");
  str = str.replaceAll("\u0119", "ę");
  str = str.replaceAll("\u0142", "ł");
  str = str.replaceAll("\u0144", "ń");
  str = str.replaceAll("\u00f3", "ó");
  str = str.replaceAll("\u015b", "ś");
  str = str.replaceAll("\u017a", "ź");
  str = str.replaceAll("\u017c", "ż");
  str = str.replaceAll("\r", "");
  str = str.replaceAll("\n", "");
  str = str.replaceAll("&#8211;", " ");
  str = str.replaceAll("&#8217;", " ");
  str = str.replaceAll("&#8230;", " ");
  str = str.replaceAll("&#8222;", " ");
  str = str.replaceAll("&#8221;", " ");
  str = str.replaceAll("<p>", " ");
  str = str.replaceAll("<br />", "\r\n");
  str = str.replaceAll("</p>", " ");
  str = str.replaceAll("[&hellip;]", " ");
  return str;
}
