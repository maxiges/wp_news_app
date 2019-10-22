import 'package:WP_news_APP/Dialogs/ShowMoreInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'dart:async';

import 'Class/WebsideInfo.dart';
import 'SplashScreen.dart';
import 'Dialogs/YesNoAlert.dart';
import 'Setting_page.dart';
import 'Globals.dart';
import 'Elements/PagesToTab.dart';
import 'Class/WebPortal.dart';
import 'Elements/GoogleSignIn.dart';
import "HomePage.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]); //disable
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);//enable
    return MaterialApp(
      title: 'WP news Collector',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        accentColor: Colors.white,
        secondaryHeaderColor: Colors.white,
        splashColor: Colors.white,
        brightness: Brightness.dark,
      ),
      home: new SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/mainScreen': (BuildContext context) => Global_MyHomePage,
        '/settingScreen': (BuildContext context) => new Setting_page(),
        '/moreInfo': (BuildContext context) => new ShowMoreInfo(),
      },
    );
  }
}
