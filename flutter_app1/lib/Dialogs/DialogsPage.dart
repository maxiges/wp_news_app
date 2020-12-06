import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';
import '../Globals.dart';
import '../Class/WebsiteInfo.dart';
import 'YesNoDialog.dart';

Future<bool> dialogsPageSaveRemoveWebsite(bool isSaved, BuildContext context,
    WebsiteInfo page) async {
  String orderText = "Save for later ?";
  Color yesColor = Colors.greenAccent;
  if (isSaved) {
    orderText = "Delete from saved ?";
    yesColor = Colors.redAccent;
  }
  bool shouldUpdate = await yesNoDialogShowDialog(
      orderText,
      yesColor,
      context,
      Icon(
        Icons.file_download,
        color: Colors.blue,
        size: 36.0,
      ));
  if (shouldUpdate) {
    int find = savedFileContainsThisWeb(page);
    if (find < 0) {
      Global_savedWebsList.add(page);
    } else {
      Global_savedWebsList.removeAt(find);
    }
    Global_refreshPage = true;
    await webInfoSaveToFirebase(Global_savedWebsList);
  }
  return shouldUpdate;
}
