import 'package:flutter/cupertino.dart';

import '../main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';

import '../Globals.dart';
import '../Class/WebsideInfo.dart';
import 'YesNoAlert.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'ShowMoreInfo.dart';
import '../main.dart';

Future<bool> DialogSaveRemoveWebside(
    bool isSaved, BuildContext context, WebsideInfo page) async {
  String orderFunct = "Save for later ?";
  Color yesColor = Colors.greenAccent;

  if (isSaved) {
    orderFunct = "Delete from saved ?";
    yesColor = Colors.redAccent;
  }
  bool shouldUpdate = await ShowDialog(
      orderFunct,
      yesColor,
      context,
      Icon(
        Icons.file_download,
        color: Colors.blue,
        size: 36.0,
      ));
  if (shouldUpdate) {
    int find = savedFileContainsThisWebside(page);
    if (find < 0) {
      Global_savedWebside.add(page);
    } else {
      Global_savedWebside.removeAt(find);
    }
    Global_RefreshPage = true;
    save_WebsideArch(Global_savedWebside);
  }
  return shouldUpdate;
}
