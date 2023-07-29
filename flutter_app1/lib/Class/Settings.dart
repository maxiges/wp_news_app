import 'package:WP_news_APP/Globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/ColorsFunc.dart';
import '../Utils/WebFilter.dart';
import '../Utils/SaveLogs.dart';

class Settings {
  bool _isDarkTheme = true;
  bool _adsOn = true;

  saveData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("DarkTheme", _isDarkTheme);
    prefs.setBool("AdsOn", _adsOn);
    webFilter.setPageFilter();
  }

  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      if (prefs.getBool("DarkTheme") == true) {
        GlobalTheme = GlobalThemeDark;
        _isDarkTheme = true;
      } else {
        GlobalTheme = GlobalThemeLight;
        _isDarkTheme = false;
      }
    } catch (ex) {
      saveLogs.error(ex.toString());
    }

    try {
      if (prefs.getBool("AdsOn") == true) {
        _adsOn = true;
      } else {
        _adsOn = false;
      }
    } catch (ex) {
      saveLogs.error(ex.toString());
    }
  }

  setTheme(bool darkTheme) async {
    _isDarkTheme = darkTheme;
    saveData();
    GlobalTheme = darkTheme? GlobalThemeDark : GlobalThemeLight;
  }

  setAddsOn(bool oN) async {
    _adsOn = oN;
    saveData();
  }

  bool isAdsOn() {
    return _adsOn;
  }

  bool isDarkTheme() {
    return _isDarkTheme;
  }
}
