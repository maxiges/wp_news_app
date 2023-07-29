import 'dart:io';

import 'package:WP_news_APP/Pages/ShowMoreInfoPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Pages/SplashPage.dart';
import 'Pages/SettingPage.dart';
import 'Globals.dart';
import 'Pages/KinderGarden.dart';
import "Pages/LogsPage.dart";
import "Utils/SaveLogs.dart";
import 'package:firebase_core/firebase_core.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

MyApp app = MyApp();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  HttpOverrides.global = MyHttpOverrides();

  runApp(app);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    Global_Settings.loadData();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge); //disable
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);//enable
    return MaterialApp(
      title: 'WP news Collector',
      theme: GlobalTheme.mainTheme,
      home: new SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/mainScreen': (BuildContext context) => Global_MyHomePage,
        '/settingScreen': (BuildContext context) => new SettingPage(),
        '/moreInfo': (BuildContext context) => new ShowMoreInfo(),
        '/kinderGarden': (BuildContext context) => new KinderGarden(),
        '/logScreen': (BuildContext context) => new LogPage(),
        '/splashScreen': (BuildContext context) => new SplashScreen(),
      },
    );
  }
}
