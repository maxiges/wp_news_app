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
import '../Utils/WebFilter.dart';





class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//****************************************************************************

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  var isPortrait = true;

  List<Widget> _webList = new List<Widget>();
  bool isOpendeSavedList = false;
  bool appStarted = false;
  AnimationController rotationController;
  int actLoadedPages = 0;
  Icon _actIcon = new Icon(Icons.storage);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void dispose() {
    super.dispose();
    Global_timer.cancel();
    rotationController.stop();
  }

  @override
  void initState() {
    super.initState();
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    checkLoadingPagesAssert();

    Global_timer = new Timer.periodic(
        Duration(microseconds: 100), (Timer timer) => timerService());
    webFilter.setPageFilter();
  }

  void timerService() {
    bool isPortraitNow =
        MediaQuery.of(context).orientation == Orientation.portrait;
    if (isPortrait != isPortraitNow) {
      setState(() {
        Global_width = MediaQuery.of(context).size.width;
        Global_height = MediaQuery.of(context).size.height;
        isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
        Global_refreshPage = true;
      });
    }

    if (Global_refreshPage == true) {
      Global_refreshPage = false;
      if (Global_actPageToRefresh == ACT_PAGE.SAVED_PAGES) {
        setState(() {
          buildTableWithPages(true);
        });
      } else if (Global_actPageToRefresh == ACT_PAGE.LOADED_PAGES) {
        setState(() {
          buildTableWithPages(false);
        });
      }
    }
  }

  List<Widget> checkLoadingPagesAssert({String loadPageError}) {
    List<Widget> retVal = List<Widget>();
    if (Global_webList.length < 1) {
      retVal.add(new Center(
        child: Text("No pages to load.\r\n Go to settings ",
            style: TextStyle(fontSize: 18, color: GlobalTheme.textColor)),
      ));
    } else if (Global_webList.length == 1) {
      retVal.add(new Center(
        child: Text("LOADING  page ... ",
            style: TextStyle(fontSize: 18, color: GlobalTheme.textColor)),
      ));
    } else {
      retVal.add(new Center(
          child: Container(
        margin: EdgeInsets.only(top: 20, bottom: 10),
        child: Text(
          "LOADING " +
              actLoadedPages.toString() +
              "/" +
              Global_webList.length.toString() +
              " pages ... ",
          style: TextStyle(fontSize: 18, color: GlobalTheme.textColor2),
        ),
      )));
      retVal.add(Container(
        height: 30,
        decoration: BoxDecoration(
          color: GlobalTheme.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: GlobalTheme.textColor,
          ),
        ),
        child: Row(
          children: <Widget>[
            AnimatedContainer(
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    topLeft: Radius.circular(10)),
                border: Border.all(),
              ),
// Define how long the animation should take.
              duration: Duration(seconds: 1),
              // Provide an optional curve to make the animation feel smoother.
              curve: Curves.fastOutSlowIn,
              width: ((Global_width - 20) *
                      (actLoadedPages / Global_webList.length) +
                  1),
            ),
          ],
        ),
      ));
    }
    return retVal;
  }

  Widget pagesToTabAdds() {
    Ads newAds = Ads();
    dynamic baner = newAds.getBaner();
    return (Container(
      margin: EdgeInsets.only(top: 0, bottom: 10),
      color: GlobalTheme.tabsColorPrimary,
      child: baner,
    ));
  }

  buildTableWithPages(bool tryLoadSavedLinks) {
    isOpendeSavedList = tryLoadSavedLinks;
    List<WebsideInfo> websideInfoLoaded = new List<WebsideInfo>();
    if (tryLoadSavedLinks) {
      _actIcon = new Icon(Icons.storage);
      websideInfoLoaded = Global_savedWebsList;
    } else {
      _actIcon = new Icon(Icons.sd_storage);
      websideInfoLoaded = readedWebs;
    }

    List<Widget> wid = new List<Widget>();
    for (WebsideInfo iter in websideInfoLoaded) {
      if (webFilter.actSetFilter != "All") {
        if (!iter.DOMAIN.contains(webFilter.actSetFilter)) {
          continue;
        }
      }

      if (Global_Settings.isAdsOn()) {
        var randome = new Random();
        if (randome.nextInt(20) == 0) {
          wid.add(pagesToTabAdds());
        }
      }
      wid.add(PagesToTab(iter, this.context));
    }
    if (websideInfoLoaded.length == 0) {
      if (!tryLoadSavedLinks) {
        if (Global_webList.length == 0) {
          wid = setAddedPages();
        } else {
          wid = setErrorLoadPage();
        }
      } else {
        wid = setNoSavedLinksDesign();
      }
    }
    setState(() {
      _webList = wid;
    });

    if (!tryLoadSavedLinks) {
      WebsideInfo_loadedWeb_save();
    }

  }

  List<Widget> setAddedPages() {
    List<Widget> _ret = new List<Widget>();
    _ret.add(Container(
      height: Global_height * 0.3,
    ));
    _ret.add(Center(
      child: Text("You didn't add any webside \r\n Do to Settings",
          style: TextStyle(fontSize: 18, color: GlobalTheme.textColor2),
          textAlign: TextAlign.center),
    ));
    _ret.add(Center(
      child: Icon(
        Icons.settings,
        color: Colors.greenAccent,
        size: 50.0,
        semanticLabel: 'No added webside',
      ),
    ));
    return _ret;
  }

  List<Widget> setErrorLoadPage() {
    List<Widget> m_ret = new List<Widget>();
    m_ret.add(Container(
      height: Global_height * 0.3,
    ));
    m_ret.add(Center(
      child: Text(
          "Can't download content.\r\n Try reload or cheeck internet connection",
          style: new TextStyle(fontSize: 18, color: GlobalTheme.textColor2),
          textAlign: TextAlign.center),
    ));
    m_ret.add(Center(
      child: Icon(
        Icons.signal_wifi_off,
        color: Colors.redAccent,
        size: 50.0,
        semanticLabel: 'No internet',
      ),
    ));
    return m_ret;
  }

  List<Widget> setNoSavedLinksDesign() {
    List<Widget> m_ret = new List<Widget>();
    m_ret.add(Container(
      height: Global_height * 0.3,
    ));
    m_ret.add(Center(
      child: Text("Your saved list is empty.",
          style: new TextStyle(fontSize: 18, color: GlobalTheme.textColor2),
          textAlign: TextAlign.center),
    ));
    m_ret.add(Center(
      child: Icon(
        Icons.save,
        color: Colors.pink,
        size: 50.0,
        semanticLabel: 'No saved pages',
      ),
    ));
    return m_ret;
  }

  Future<List<WebsideInfo>> getPageAsync(WebPortal web) async {
    List<WebsideInfo> retval = await WebsideInfo_GetWebInfos(web);
    for (WebsideInfo webs in retval) {
      bool add = true;
      for (WebsideInfo loaded in readedWebs) {
        if (loaded.URL == webs.URL) add = false;
      }
      if (add) {
        readedWebs.add(webs);
      }
    }
    setState(() {
      actLoadedPages++;
      _webList = checkLoadingPagesAssert();
    });
    return retval;
  }

  void loadFromWebs(bool append) async {
    setState(() {
      actLoadedPages = 0;
      _webList = checkLoadingPagesAssert();
      if (append == false) {
        readedWebs.clear();
      }
    });
    Global_actPageToRefresh = ACT_PAGE.LOADED_PAGES;
    rotationController.repeat(period: Duration(milliseconds: 1000));
    List<Future> tasks = new List<Future>();
    for (WebPortal WEB in Global_webList) {
      tasks.add(getPageAsync(WEB));
    }

    await Future.wait(tasks);
    readedWebs.sort((a, b) {
      DateTime dataA = DateTime.parse(a.DATE);
      DateTime dataB = DateTime.parse(b.DATE);
      if (dataB.millisecondsSinceEpoch > dataA.millisecondsSinceEpoch) return 1;
      return 0;
    });



    Global_refreshPage = true;
    rotationController.reset();
  }

  //------------------------------
  Widget refresh() {
    return (RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(rotationController),
        child: GestureDetector(
            onTap: () async {
              setState(() {
                loadFromWebs(true);
              });
            },
            onLongPressEnd: (time)async{
                setState(() {
                  loadFromWebs(false);
                });
            },
            child: IconButton(
              iconSize: 30,
              padding: const EdgeInsets.all(0),
              icon: Icon(Icons.refresh),
              color: GlobalTheme.textColor,
            ))));
  }

  showPicker(BuildContext context) {
    Picker picker = Picker(
        adapter: PickerDataAdapter(data: webFilter.filterDataList),
        changeToFirst: true,
        textAlign: TextAlign.left,
        textStyle: const TextStyle(color: Colors.blue),
        selectedTextStyle: TextStyle(color: Colors.red),
        columnPadding: const EdgeInsets.all(8.0),
        backgroundColor: GlobalTheme.background,
        cancelText: "Cancel",
        headercolor: GlobalTheme.background,
        containerColor: GlobalTheme.background,
        cancelTextStyle: TextStyle(color: GlobalTheme.textColor),
        confirmTextStyle: TextStyle(color: GlobalTheme.tabs),
        onConfirm: (Picker picker, List value) {
          setState(() {
            webFilter.actSetFilter = picker.getSelectedValues()[0].toString();
            Global_refreshPage = true;
          });
        });
    picker.show(_scaffoldKey.currentState);
  }

  PreferredSizeWidget renderAppBar() {
    String userText = "Hello guest";
    if (Global_GoogleSign.googleUserIsSignIn() == true) {
      userText = Global_GoogleSign.getGoogleUser();
    }
    return (PreferredSize(
        preferredSize: Size.fromHeight(35.0),
        child: new AppBar(
          backgroundColor: GlobalTheme.navAccent,
          textTheme: GlobalTheme.textTheme,
          iconTheme: GlobalTheme.iconTheme,
          leading: refresh(),
          title: Row(children: <Widget>[
            Text(
              userText,
              style: TextStyle(fontSize: 12, color: GlobalTheme.textColor),
              textAlign: TextAlign.center,
            ),
            Container(
              margin:
                  const EdgeInsets.only(left: 5, right: 2, top: 5, bottom: 5),
              color: GlobalTheme.tabs,
              width: 1,
            ),
            FlatButton(
              padding:
                  const EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 0),
              color: Colors.transparent,
              child: Row(children: <Widget>[
                Text(
                  webFilter.actSetFilter,
                  style: TextStyle(color: GlobalTheme.textColor, fontSize: 12),
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: GlobalTheme.textColor,
                )
              ]),
              onPressed: () {
                showPicker(context);
              },
            ),
          ]),
          actions: <Widget>[
            new IconButton(
              iconSize: 30,
              padding: const EdgeInsets.all(0),
              icon: _actIcon,
              onPressed: () {
                if (Global_actPageToRefresh == ACT_PAGE.SAVED_PAGES) {
                  Global_actPageToRefresh = ACT_PAGE.LOADED_PAGES;
                } else {
                  Global_actPageToRefresh = ACT_PAGE.SAVED_PAGES;
                }

                Global_refreshPage = true;
              },
            ),
            new IconButton(
              iconSize: 30,
              padding: const EdgeInsets.all(0),
              icon: new Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).pushNamed('/settingScreen');
              },
            ),
          ],
        )));
  }

  //*******************************APPPPP****************************************
  @override
  Widget build(BuildContext context) {
    try {
      if (!appStarted) {
        WebsideInfo_loadedWeb_load();
        Global_width = MediaQuery.of(context).size.width;
        Global_height = MediaQuery.of(context).size.height;
        loadFromWebs(true);
        appStarted = true;
      }
    } catch (ex) {}

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: GlobalTheme.background,
      appBar: renderAppBar(),
      body: Center(
          child: ListView(
        padding: const EdgeInsets.all(8),
        children: _webList,
      )),
    );
  }
}
