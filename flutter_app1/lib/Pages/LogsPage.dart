import 'package:WP_news_APP/Utils/ColorsFunc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../Globals.dart';
import '../Dialogs/YesNoDialog.dart';
import '../Dialogs/SettingAddPage.dart';
import '../Class/WebPortal.dart';
import '../Dialogs/AbautInfo.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_admob/firebase_admob.dart';
import "../Utils/SaveLogs.dart";

class LogPage extends StatefulWidget {
  LogPage({Key key}) : super(key: key);

  @override
  _LogPage createState() => _LogPage();
}

class _LogPage extends State<LogPage> with SingleTickerProviderStateMixin {
  String _ActReadedLog = "";

  @override
  void initState() {
    super.initState();
    logData();
  }

  logData() async {
    _ActReadedLog = await saveLogs.read();
    setState(() {
      _ActReadedLog += "\r\n";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: GlobalTheme.background,
        appBar: AppBar(
          backgroundColor: GlobalTheme.navAccent,
          textTheme: GlobalTheme.textTheme,
          iconTheme: GlobalTheme.iconTheme,
          title: const Text(
            'Logs',
            style: TextStyle(fontSize: 20),
          ),
          leading: IconButton(
            iconSize: 30,
            padding: const EdgeInsets.all(0),
            onPressed: () async {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back),
          ),
          actions: <Widget>[
            IconButton(
              iconSize: 30,
              color: GlobalTheme.textColor,
              padding: const EdgeInsets.all(0),
              onPressed: () async {
                saveLogs.delete();
              },
              icon: Icon(Icons.delete),
            ),
            IconButton(
              iconSize: 30,
              color: GlobalTheme.textColor,
              padding: const EdgeInsets.all(0),
              onPressed: () async {
                logData();
              },
              icon: Icon(Icons.all_inclusive),
            ),
          ],
        ),
        body: Text(
          _ActReadedLog,
          style: TextStyle(color: GlobalTheme.textColor),
        ));
  }

  void dispose() {
    super.dispose();
  }
}
