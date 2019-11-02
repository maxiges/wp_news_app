import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import '../Globals.dart';
import 'package:package_info/package_info.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_local_notifications_extended/flutter_local_notifications_extended.dart';
import '../Class/WebsideInfo.dart';

import '../Pages/ShowMoreInfoPage.dart';

class KinderGarden extends StatefulWidget {
  KinderGarden({Key key}) : super(key: key);

  @override
  _KinderGarden createState() => _KinderGarden();
}

class _KinderGarden extends State<KinderGarden>
    with SingleTickerProviderStateMixin {
  static const platform = const MethodChannel('flutterChannel');
  String _batteryLevel = 'Unknown battery level.';

  Future onSelectNotification(String payload) async {
    WebsideInfo webFromNot = new WebsideInfo();
    webFromNot.tryParseJson(payload);
    if (payload != null) {
      //press notification
      await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new ShowMoreInfo(),
            settings: RouteSettings(arguments: webFromNot)),
      );
    }
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  displayNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'wpChannel', 'wpChannel', 'wpChannel for notification',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'WP notification ',
        'Welcome this is my notification ', platformChannelSpecifics,
        payload: new WebsideInfo(TITTLE: "Test from notification").toJson());
  }

  @override
  void initState() {
    super.initState();

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    displayNotification();
  }

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    _getBatteryLevel();

    return Scaffold(
      backgroundColor: GlobalTheme.background,
      body: Container(
        child: Column(
          children: <Widget>[
            Text(
              "  " + _batteryLevel,
              style: TextStyle(color: GlobalTheme.textColor),
            )
          ],
        ),
      ),
    );
  }
}
