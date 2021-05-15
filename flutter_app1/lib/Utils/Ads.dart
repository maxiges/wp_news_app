import 'package:admob_flutter/admob_flutter.dart';

class Ads {
  Ads() {
    setData();
    Admob.initialize(getBannerAdUnitId());
  }

  setData() {}

  String getAppAdUnitId() {
    return 'ca-app-pub-2632418691113458~9011907820';
  }

  String getBannerAdUnitId() {
    return 'ca-app-pub-2632418691113458/1133417803';
  }
}
