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
import 'package:admob_flutter/admob_flutter.dart';
import 'dart:io';

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
    FirebaseAdMob.instance.initialize(appId: getAppAdUnitId()).then((response) {
      myBanner
        ..load()
        ..show();
    });
  }

  Widget getBaner() {
    return (AdmobBanner(
      adUnitId: getBannerAdUnitId(),
      adSize: AdmobBannerSize.BANNER,
    ));
  }

  hideBaner() {
    myBanner.dispose();
  }

  void dispose() {
    myBanner.dispose();
  }

  String getAppAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-2632418691113458~9011907820';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-2632418691113458~9011907820';
    }
    return null;
  }

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-2632418691113458/1133417803';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-2632418691113458/1133417803';
    }
    return null;
  }
}
