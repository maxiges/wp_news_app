import 'package:firebase_admob/firebase_admob.dart';
import 'package:admob_flutter/admob_flutter.dart';

import '../Utils/SaveLogs.dart';

class Ads {
  MobileAdTargetingInfo targetingInfo;
  BannerAd myBanner;

  Ads() {
    setData();
    Admob.initialize(getBannerAdUnitId());
  }

  setData() {
    targetingInfo = MobileAdTargetingInfo(
      keywords: <String>[
        'news',
        'wordpress',
        "bissnes",
        "office",
        "shoes",
        "games"
      ],
      contentUrl: 'https://flutter.io',
      birthday: DateTime.now(),
      childDirected: false,
      designedForFamilies: false,
      gender: MobileAdGender.male,
// or MobileAdGender.female, MobileAdGender.unknown
      testDevices: <String>[], // Android emulators are considered test devices
    );

    myBanner = BannerAd(
// Replace the testAdUnitId with an ad unit id from the AdMob dash.
// https://developers.google.com/admob/android/test-ads
// https://developers.google.com/admob/ios/test-ads
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );
  }

  showBaner() {
    try {
      FirebaseAdMob.instance
          .initialize(appId: getAppAdUnitId())
          .then((response) {
        myBanner
          ..load()
          ..show();
      });
    } catch (ex) {
      saveLogs.error(ex.toString());
    }
  }

  BannerAd getBaner() {
    try {
      return (BannerAd(
        adUnitId: getBannerAdUnitId(),
        size: AdSize.banner,
      ));
    } catch (ex) {
      saveLogs.error(ex.toString());
    }
  }

  hideBaner() {
    myBanner.dispose();
  }

  void dispose() {
    myBanner.dispose();
  }

  String getAppAdUnitId() {
    return 'ca-app-pub-2632418691113458~9011907820';
  }

  String getBannerAdUnitId() {
    return 'ca-app-pub-2632418691113458/1133417803';
  }
}
