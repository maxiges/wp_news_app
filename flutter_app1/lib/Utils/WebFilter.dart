import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../Globals.dart';
import '../Class/WebPortal.dart';
import 'package:flutter_picker/flutter_picker.dart';

WebFilter webFilter = new WebFilter();

class WebFilter {
  List<String> filterPages = [];
  String actSetFilter = "All";
  List<PickerItem> filterDataList = [];

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
              style: TextStyle(color: GlobalTheme.textColor, fontSize: 18),
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
            value: act.url),
      );
    }
  }
}
