import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';
import '../Class/WebsideInfo.dart';
import '../Globals.dart';
import '../Elements/PagesToTab.dart';
import '../Class/WebPortal.dart';
import 'dart:math';
import '../Utils/Ads.dart';
import 'package:flutter_picker/flutter_picker.dart';

WebFilter webFilter = new WebFilter();

class WebFilter {
  List<String> filterPages = new List<String>();
  String actSetFilter = "All";
  List<PickerItem> filterDataList = new List<PickerItem>();

  void setPageFilter() {
    filterPages.clear();
    filterDataList.clear();
    filterPages.add("All");
    actSetFilter = "All";
    filterDataList.add(
      PickerItem(
          text: Text(
            "Show All",
            style: TextStyle(color: GlobalTheme.textColor),
          ),
          value: "All"),
    );
    for (WebPortal act in Global_webList) {
      filterPages.add(act.url);
      filterDataList.add(
        PickerItem(
            text: Text(
              act.url,
              style: TextStyle(color: GlobalTheme.textColor),
            ),
            value: act.url),
      );
    }
  }
}
