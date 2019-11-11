import 'package:WP_news_APP/Globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/ColorsFunc.dart';
import '../Utils/WebFilter.dart';

class Settings {
  bool _isDarkTheme = true;
  bool _adsOn = true;

  saveData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("DarkTheme", _isDarkTheme);
    prefs.setBool("AdsOn", _adsOn);
    webFilter.setPageFilter();
  }

  loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      if (prefs.getBool("DarkTheme")) {
        GlobalTheme = GlobalThemeDart;
        _isDarkTheme = true;
      } else {
        GlobalTheme = GlobalThemeLight;
        _isDarkTheme = false;
      }
    } catch (ex) {}

    try {
      if (prefs.getBool("AdsOn")) {
        _adsOn = true;
      } else {
        _adsOn = false;
      }
    } catch (ex) {}
  }

  setTheme(bool darkTheme) async {
    _isDarkTheme = darkTheme;
    saveData();
  }

  setAddsOn(bool oN) async {
    _adsOn = oN;
    saveData();
  }

  bool isAdsOn() {
    return _adsOn;
  }

  bool isDarkTheme() {
    return _isDarkTheme;
  }
}
