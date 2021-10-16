import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../Globals.dart';
import "../Utils/SaveLogs.dart";

class LogPage extends StatefulWidget {
  LogPage({Key key}) : super(key: key);

  @override
  _LogPage createState() => _LogPage();
}

class _LogPage extends State<LogPage> with SingleTickerProviderStateMixin {
  String _currLog = "";

  @override
  void initState() {
    super.initState();
    logData();
  }

  logData() async {
    _currLog = await saveLogs.read();
    setState(() {
      _currLog += "\r\n";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: GlobalTheme.background,
        appBar: AppBar(
          backgroundColor: GlobalTheme.navAccent,
          iconTheme: GlobalTheme.iconTheme,
          titleTextStyle: TextStyle(fontSize: 20, color: GlobalTheme.textColor),
          title: const Text(
            'Logs',
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
        body: SingleChildScrollView(
            child: Text(
          _currLog,
          style: TextStyle(color: GlobalTheme.textColor),
        )));
  }

  void dispose() {
    super.dispose();
  }
}
