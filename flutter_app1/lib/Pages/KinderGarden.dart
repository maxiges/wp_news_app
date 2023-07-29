import 'package:WP_news_APP/Class/WebPortal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import '../Globals.dart';

import 'package:flutter/services.dart';

import '../Class/WebsiteInfo.dart';

import '../Pages/ShowMoreInfoPage.dart';

class KinderGarden extends StatefulWidget {
  KinderGarden({Key? key}) : super(key: key);

  @override
  _KinderGarden createState() => _KinderGarden();
}

class _KinderGarden extends State<KinderGarden>
    with SingleTickerProviderStateMixin {
  static const platform = const MethodChannel('flutterChannel');
  String _batteryLevel = 'Unknown battery level.';

  Future onSelectNotification(String payload) async {
    WebsiteInfo webFromNot = new WebsiteInfo(portalType: PortalType.Other);
    webFromNot = webFromNot.tryParseJson(payload);
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

  displayNotification() async {}

  @override
  void initState() {
    super.initState();
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

  void dispose() {
    super.dispose();
  }
}
