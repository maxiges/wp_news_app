import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../Utils/SaveLogs.dart';

Map<String, Color> colorPalette = {
  "black": Colors.black,
  "black26": Colors.black26,
  "grey": Colors.grey,
  "white": Colors.white,
  "redAccent": Colors.redAccent,
  "red": Colors.red,
  "orange": Colors.orange,
  "orangeDip": Colors.deepOrange,
  "yellow": Colors.yellow,
  "yellowAccent": Colors.yellowAccent,
  "green": Colors.green,
  "greenAccent": Colors.greenAccent,
  "blue": Colors.blue,
  "blueAccent": Colors.blueAccent,
  "purple": Colors.purple,
  "deepPurple": Colors.deepPurple,
};

class ColorsTheme {
  final ThemeData? mainTheme;
  final Color background,
      backgroundDialog,
      navAccent,
      textColor,
      tabsColorPrimary,
      tabsDayBackground,
      textColor2,
      tabs,
      basicButtonBackground;
  final TextStyle textStyle;
  final TextTheme textTheme;
  final IconThemeData iconTheme;

  ColorsTheme({
    this.background = Colors.black,
    this.navAccent = Colors.black,
    this.textColor = Colors.white,
    this.textStyle = const TextStyle(color: Colors.white),
    this.mainTheme = null,
    this.tabsColorPrimary = Colors.black54,
    this.tabsDayBackground = Colors.black26,
    this.textColor2 = Colors.black54,
    this.tabs = Colors.black38,
    this.basicButtonBackground = Colors.black26,
    this.iconTheme = const IconThemeData(color: Colors.white),
    this.textTheme = const TextTheme(
        headlineSmall: TextStyle(color: Colors.white),),
    this.backgroundDialog = Colors.black54,
  });
}

ColorsTheme GlobalThemeDark = new ColorsTheme(
    background: Colors.black,
    navAccent: Color.fromARGB(255, 40, 40, 40),
    textColor: Colors.white,
    textStyle: const TextStyle(color: Colors.white),
    tabsColorPrimary: Color.fromARGB(100, 68, 68, 68),
    tabsDayBackground: Color.fromARGB(255, 59, 59, 59),
    textColor2: Color.fromARGB(255, 200, 200, 200),
    tabs: Color(0xFF2191EA),
    basicButtonBackground: Color.fromARGB(140, 28, 28, 28),
    iconTheme: const IconThemeData(color: Colors.white),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white),
    ),
    backgroundDialog: Color.fromARGB(255, 60, 60, 60),
    mainTheme: ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.cyan,
      secondaryHeaderColor: Colors.white,
      splashColor: Colors.black,
      brightness: Brightness.light,
      textTheme: TextTheme(headlineSmall: TextStyle(color: Colors.white)),
      switchTheme: SwitchThemeData(),
    ));

ColorsTheme GlobalThemeLight = new ColorsTheme(
    background: Color.fromARGB(255, 217, 217, 217),
    navAccent: Color.fromARGB(255, 200, 200, 200),
    textColor: Colors.black,
    backgroundDialog: Color.fromARGB(255, 185, 185, 185),
    textStyle: const TextStyle(color: Colors.black),
    tabsColorPrimary: Color.fromARGB(255, 245, 245, 245),
    tabsDayBackground: Color.fromARGB(255, 227, 227, 227),
    textColor2: Color.fromARGB(255, 60, 60, 60),
    tabs: Color(0xFF90CAF9),
    iconTheme: const IconThemeData(color: Colors.white),
    basicButtonBackground: Color.fromARGB(168, 227, 227, 227),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white),
    ),
    mainTheme: ThemeData(
      primarySwatch: Colors.cyan,
      secondaryHeaderColor: Colors.white,
      splashColor: Colors.white,
      brightness: Brightness.light,
      textTheme: TextTheme(headlineSmall: TextStyle(color: Colors.white)),
      useMaterial3: true,
    ));

Color Color_GetColor(String color) {
  Color? c = colorPalette[color];
  if (c == null) {
    return Colors.black;
  }
  return c;
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
  for (Color colorval in colorPalette.values.toList()) {
    if (colorval.value == color.value) {
      number = listnb;
      break;
    }
    listnb++;
  }
  if (number > 0) {
    return colorPalette.keys.toList()[number];
  }
  return findname;
}
