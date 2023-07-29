import 'package:WP_news_APP/Globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Decors {
  static List<BoxShadow>? boxShadow = [
    BoxShadow(
      color: GlobalTheme.backgroundDialog,
      blurRadius: 8,
      offset: Offset(0, 4), // Shadow position
    ),
  ];

  static List<BoxShadow>? boxShadow2 = [
    BoxShadow(
      color: GlobalTheme.backgroundDialog,
      blurRadius: 2,
      offset: Offset(0, 2), // Shadow position
    ),
  ];

  static BoxDecoration tabBoxDecor = new BoxDecoration(
    color: GlobalTheme.tabs,
    borderRadius: new BorderRadius.all(Radius.circular(5)),
    boxShadow: Decors.boxShadow,
  );

  static BoxDecoration tab2BoxDecor = new BoxDecoration(
    color: GlobalTheme.tabsDayBackground,
    borderRadius: new BorderRadius.all(Radius.circular(5)),
    boxShadow: Decors.boxShadow2,
  );

  static ButtonStyle basicButtonStyle = new ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
      shadowColor:
          MaterialStateProperty.all<Color>(GlobalTheme.basicButtonBackground),
      backgroundColor:
          MaterialStateProperty.all<Color>(GlobalTheme.basicButtonBackground),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
      )));

  static ButtonStyle primaryButtonStyle = new ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
      shadowColor:
          MaterialStateProperty.all<Color>(GlobalTheme.basicButtonBackground),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
      )));



  static Color primaryButtonStyleTextColour = Colors.white;
}
