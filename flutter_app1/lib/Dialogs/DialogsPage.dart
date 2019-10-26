import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';
import '../Globals.dart';
import '../Class/WebsideInfo.dart';
import 'YesNoDialog.dart';


Future<bool> DialogsPage_saveRemoveWebside(
    bool isSaved, BuildContext context, WebsideInfo page) async {
  String orderText = "Save for later ?";
  Color yesColor = Colors.greenAccent;
  if (isSaved) {
    orderText = "Delete from saved ?";
    yesColor = Colors.redAccent;
  }
  bool shouldUpdate = await YesNoDialog_ShowDialog(
      orderText,
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
      Global_savedWebsList.add(page);
    } else {
      Global_savedWebsList.removeAt(find);
    }
    Global_refreshPage = true;
    WebsideInfo_save(Global_savedWebsList);
  }
  return shouldUpdate;
}
