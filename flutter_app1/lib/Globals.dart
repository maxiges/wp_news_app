import 'Class/WebsiteInfo.dart';
import 'dart:async';
import 'Class/WebPortal.dart';
import 'package:package_info/package_info.dart';
import 'Elements/GoogleSignIn.dart';
import 'Pages/HomePage.dart';
import 'Utils/ColorsFunc.dart';
import "Class/Settings.dart";



bool isLargeWideScreen(){
  if (Global_width < 500){
    return false;
  }
  return true;
}

enum ACT_PAGE { none, LOADED_PAGES, SAVED_PAGES, SETTINGS }

List<WebPortal> Global_webList = [];
List<WebsiteInfo> Global_savedWebsList = [];
double Global_width = 0;
double Global_height = 0;
Timer Global_timer =
    new Timer.periodic(Duration(minutes: 1000), (Timer timer) => {});
bool Global_refreshPage = false;
ACT_PAGE Global_actPageToRefresh = ACT_PAGE.LOADED_PAGES;
MyHomePage Global_MyHomePage = new MyHomePage(title: 'WP news APP');
PackageInfo Global_packageInfo = PackageInfo(
    version: ".....",
    appName: "WP APP",
    buildNumber: "N/A",
    packageName: "N/A");
late GoogleSign Global_GoogleSign = new GoogleSign();
const String Global_NoImageAvater =
    "https://secure.gravatar.com/avatar/d187e7d1ad82bca50f490848dc98f1e3?s=96&d=mm&r=g";
const String Global_NoImagePost =
    "https://icon-library.net/images/no-image-available-icon/no-image-available-icon-6.jpg";

ColorsTheme GlobalTheme = GlobalThemeDark;
Settings Global_Settings = new Settings();

loadFromStorage() async {
  Global_webList = await webPortalLoadWebs();
  Global_savedWebsList = await webInfoLoadFromFirebase();
}
