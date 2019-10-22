
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

enum ACT_PAGE {
  none,
  LOADED_PAGES,
  SAVED_PAGES,
  SETTINGS
}
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


Map<String, Color> colorPalet =   {
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

} ;


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

