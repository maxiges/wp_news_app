import 'dart:ffi';

import 'package:WP_news_APP/Class/WebsiteInfo.dart';
import 'package:WP_news_APP/Utils/SaveLogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../Globals.dart';
import '../Class/WebPortal.dart';
import 'package:flutter_picker_plus/flutter_picker_plus.dart';

WebFilter webFilter = new WebFilter();

class WebFilter {
  List<String> _filterPages = [];
  List<String> _filterTypes = [];
  String _actSetFilter = "All";
  PortalType _portalType = PortalType.Other;
  List<PickerItem> _filterDataList = [];
  List<PickerItem> _filterDataListByType = [];

  void setFilterByDomain(String domainName) {
    _actSetFilter = domainName;
    _portalType = PortalType.Other;
  }

  void setFilterByType(String portalTypeName) {
    try {
      PortalType portalType = PortalType.values.byName(portalTypeName);
      _portalType = portalType;
      _actSetFilter = "All";
    } catch (ex) {
      saveLogs.error(ex.toString());
    }
  }

  bool webFilterIsOK(WebsiteInfo webInfo) {
    bool isValid = true;
    if (_actSetFilter != "All") {
      if (!webInfo.domain.contains(_actSetFilter)) {
        isValid = false;
        return isValid;
      }
    }
    if (_portalType != PortalType.Other) {
      if (webInfo.portalType != _portalType) {
        isValid = false;
        return isValid;
      }
    }

    return isValid;
  }

  String getFilterByDomain() {
    return _actSetFilter;
  }

  String getFilterByType() {
    return _portalType.name;
  }

  List<PickerItem> getFilterDataList() {
    return _filterDataList;
  }

  List<PickerItem> getFilterDataListForType() {
    return _filterDataListByType;
  }

  void setPageFilter() {
    _filterPages.clear();
    _filterDataList.clear();
    _filterDataListByType.clear();
    _filterTypes.clear();
    _filterTypes.clear();
    _filterPages.add("All");
    _filterTypes.add("All");


    TextStyle _textStyle = TextStyle(color: GlobalTheme.textColor,  fontSize: 28);

    _filterDataListByType.add(
      PickerItem(
          text: Text(
            "Show All",
            style: _textStyle,
          ),
          value: "All"),
    );

    _filterDataList.add(
      PickerItem(
          text: Text(
            "Show All",
            style: _textStyle,
          ),
          value: "All"),
    );
    for (WebPortal act in Global_webList) {
      _filterPages.add(act.url);
      _filterDataList.add(
        PickerItem(
            text: Text(
              act.url,
              style: _textStyle,
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
            value: act.url),
      );
    }

    PortalType.values.forEach((element) {
      _filterTypes.add(element.name);
      _filterDataListByType.add(
        PickerItem(
            text: Text(
              element.name,
              style: _textStyle,
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
            value: element.name),
      );
    });
  }
}
