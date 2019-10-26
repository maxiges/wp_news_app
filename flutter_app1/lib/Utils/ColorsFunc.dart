import 'package:WP_news_APP/Globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';

ColorPicker_ThemeSet(bool darkTheme) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("DarkTheme", darkTheme);
}

ColorPicker_ThemeLoad() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("DarkTheme")) {
      GlobalTheme = GlobalThemeDart;
    } else {
      GlobalTheme = GlobalThemeLight;
    }
  }
  catch(ex){}
}

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

class ColorsTheme {
  final ThemeData mainTheme;
  final Color background,
      backgroundDialog,
      navAccent,
      textColor,
      tabsColorPrimary,
      tabsDayBackground,
      textColor2,
      tabs;
  final TextStyle textstyle;
  final TextTheme textTheme;
  final IconThemeData iconTheme;

  ColorsTheme({
    this.background = Colors.black,
    this.navAccent = Colors.black,
    this.textColor = Colors.white,
    this.textstyle = const TextStyle(color: Colors.white),
    this.mainTheme = null,
    this.tabsColorPrimary = Colors.black54,
    this.tabsDayBackground = Colors.black54,
    this.textColor2 = Colors.black54,
    this.tabs = Colors.black38,
    this.iconTheme = const IconThemeData(color: Colors.white),
    this.textTheme = const TextTheme(
        title: TextStyle(color: Colors.white),
        button: TextStyle(color: Colors.white)),
    this.backgroundDialog = Colors.black54,
  });
}








ColorsTheme GlobalThemeDart = new ColorsTheme(
    background: Colors.black,
    navAccent: Color.fromARGB(255, 40, 40, 40),
    textColor: Colors.white,
    textstyle: const TextStyle(color: Colors.white),
    tabsColorPrimary: Color.fromARGB(100, 40, 40, 40),
    tabsDayBackground: Colors.black,
    textColor2: Color.fromARGB(255, 200, 200, 200),
    tabs: Color.fromARGB(255, 0, 100, 100),
    iconTheme: const IconThemeData(color: Colors.white),
    textTheme: const TextTheme(
        title: TextStyle(color: Colors.white),
        button: TextStyle(color: Colors.white)),
    backgroundDialog: Color.fromARGB(255, 60, 60, 60),
    mainTheme: ThemeData(
      primarySwatch: Colors.cyan,
      accentColor: Colors.white,
      secondaryHeaderColor: Colors.white,
      splashColor: Colors.black,
      brightness: Brightness.light,
      textTheme: TextTheme(title: TextStyle(color: Colors.white)),
      backgroundColor: Colors.black,
    ));






ColorsTheme GlobalThemeLight = new ColorsTheme(
    background: Colors.white,
    navAccent: Color.fromARGB(255, 200, 200, 200),
    textColor: Colors.black,
    backgroundDialog: Color.fromARGB(255, 150, 150, 150),
    textstyle: const TextStyle(color: Colors.black),
    tabsColorPrimary: Color.fromARGB(255, 200, 220, 220),
    tabsDayBackground: Color.fromARGB(255, 150, 150, 150),
    textColor2: Color.fromARGB(255, 60, 60, 60),
    tabs: Color.fromARGB(255, 150, 255, 255),
    iconTheme: const IconThemeData(color: Colors.black),
    textTheme: const TextTheme(
        title: TextStyle(color: Colors.black),
        button: TextStyle(color: Colors.black)),
    mainTheme: ThemeData(
      primarySwatch: Colors.cyan,
      accentColor: Colors.cyan,
      secondaryHeaderColor: Colors.white,
      splashColor: Colors.white,
      brightness: Brightness.light,
      textTheme: TextTheme(title: TextStyle(color: Colors.white)),
      backgroundColor: Colors.white,
    ));

Color Color_GetColor(String color) {
  try {
    return colorPalet[color];
  } catch (ex) {}
  return Colors.black;
}

Color Color_getColorText(Color act) {
  if (act.computeLuminance() > 0.3) {
    return Colors.black;
  } else {
    return Colors.white;
  }
}

String Color_GetColorInString(Color color) {
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
