import 'package:WP_news_APP/Utils/SaveLogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';
import '../Class/WebsiteInfo.dart';
import '../Globals.dart';
import '../Elements/PagesToTab.dart';
import '../Class/WebPortal.dart';
import 'dart:math';
import 'package:flutter_picker/flutter_picker.dart';
import '../Utils/WebFilter.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:toast/toast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../Utils/WebPageAPI.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//****************************************************************************

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  var isPortrait = true;
  List<Widget> _webList = [];
  bool isOpenSavedList = false;
  bool appStarted = false;

  int actLoadedPages = 0;
  Icon _actIcon = new Icon(Icons.storage);
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  AnimationController rotationController;
  AnimationController refreshController;
  Animation<double> _refreshIconSizeAnimation;

  void dispose() {
    super.dispose();
    Global_timer.cancel();
    rotationController.stop();
    refreshController.stop();
  }

  @override
  void initState() {
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    rotationController.reset();

    refreshController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    refreshController.repeat(period: Duration(milliseconds: 300));
    checkLoadingPagesAssert();
    _refreshIconSizeAnimation =
        Tween<double>(begin: 30, end: 20).animate(refreshController)
          ..addListener(() {
            setState(() {
              // The state that has changed here is the animation object’s value.
            });
          });
    refreshController.reset();

    Global_timer = new Timer.periodic(
        Duration(microseconds: 100), (Timer timer) => timerService());
    webFilter.setPageFilter();
    super.initState();
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
    List<Widget> retVal = [];
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

  void showSnackBar(String content) {
    scaffoldState.currentState.showSnackBar(SnackBar(
      content: Text(content),
      duration: Duration(milliseconds: 1500),
    ));
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        showSnackBar('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        showSnackBar('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        showSnackBar('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        showSnackBar('Admob $adType failed to load. :(');
        break;
      case AdmobAdEvent.rewarded:
        showDialog(
          context: scaffoldState.currentContext,
          builder: (BuildContext context) {
            return WillPopScope(
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Reward callback fired. Thanks Andrew!'),
                    Text('Type: ${args['type']}'),
                    Text('Amount: ${args['amount']}'),
                  ],
                ),
              ),
              onWillPop: () async {
                scaffoldState.currentState.hideCurrentSnackBar();
                return true;
              },
            );
          },
        );
        break;
      default:
    }
  }

  buildTableWithPages(bool tryLoadSavedLinks) {
    isOpenSavedList = tryLoadSavedLinks;
    List<WebsiteInfo> websiteInfoLoaded = [];
    if (tryLoadSavedLinks) {
      _actIcon = new Icon(Icons.storage);
      websiteInfoLoaded = Global_savedWebsList;
    } else {
      _actIcon = new Icon(Icons.sd_storage);
      websiteInfoLoaded = readedWebs;
    }

    List<Widget> wid = [];
    for (WebsiteInfo iWeb in websiteInfoLoaded) {
      if (webFilter.actSetFilter != "All") {
        if (!iWeb.DOMAIN.contains(webFilter.actSetFilter)) {
          continue;
        }
      }

      if (Global_Settings.isAdsOn()) {
        var ran = new Random();
        if (ran.nextInt(20) == 0) {
          //todo add AD
        }
      }
      wid.add(PagesToTab(iWeb, this.context));
    }
    if (websiteInfoLoaded.length == 0) {
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
      webInfoLoadedWebSave();
    }
  }

  List<Widget> setAddedPages() {
    List<Widget> _ret = [];
    _ret.add(Container(
      height: Global_height * 0.3,
    ));
    _ret.add(Center(
      child: Text("You didn't add any website \r\n Do to Settings",
          style: TextStyle(fontSize: 18, color: GlobalTheme.textColor2),
          textAlign: TextAlign.center),
    ));
    _ret.add(Center(
      child: Icon(
        Icons.settings,
        color: Colors.greenAccent,
        size: 50.0,
        semanticLabel: 'No added website',
      ),
    ));
    return _ret;
  }

  List<Widget> setErrorLoadPage() {
    List<Widget> _ret = [];
    _ret.add(Container(
      height: Global_height * 0.3,
    ));
    _ret.add(Center(
      child: Text(
          "Can't download content.\r\n Try reload or cheeck internet connection",
          style: new TextStyle(fontSize: 18, color: GlobalTheme.textColor2),
          textAlign: TextAlign.center),
    ));
    _ret.add(Center(
      child: Icon(
        Icons.signal_wifi_off,
        color: Colors.redAccent,
        size: 50.0,
        semanticLabel: 'No internet',
      ),
    ));
    return _ret;
  }

  List<Widget> setNoSavedLinksDesign() {
    List<Widget> _ret = [];
    _ret.add(Container(
      height: Global_height * 0.3,
    ));
    _ret.add(Center(
      child: Text("Your saved list is empty.",
          style: new TextStyle(fontSize: 18, color: GlobalTheme.textColor2),
          textAlign: TextAlign.center),
    ));
    _ret.add(Center(
      child: Icon(
        Icons.save,
        color: Colors.pink,
        size: 50.0,
        semanticLabel: 'No saved pages',
      ),
    ));
    return _ret;
  }

  Future<List<WebsiteInfo>> getPageAsync(WebPortal web) async {
    List<WebsiteInfo> _ret = await webPageFetchAPI.websiteInfoGetWebPages(web);
    for (WebsiteInfo webs in _ret) {
      bool add = true;
      for (WebsiteInfo loaded in readedWebs) {
        if (loaded.URL == webs.URL) {
          add = false;
          break;
        }
      }
      if (add) {
        readedWebs.add(webs);
      }
    }
    setState(() {
      actLoadedPages++;
      _webList = checkLoadingPagesAssert();
    });
    return _ret;
  }

  void loadFromWebs(bool append) async {
    try {
      setState(() {
        actLoadedPages = 0;
        _webList = checkLoadingPagesAssert();
        if (append == false) {
          readedWebs.clear();
        }
      });
      Global_actPageToRefresh = ACT_PAGE.LOADED_PAGES;
      rotationController.repeat(period: Duration(milliseconds: 1000));
      List<Future> tasks = [];
      for (WebPortal WEB in Global_webList) {
        tasks.add(getPageAsync(WEB));
      }
      await Future.wait(tasks);
      reSortWebs();

      rotationController.reset();
    } catch (ex) {
      saveLogs.error(ex);
    }
  }

  void reSortWebs() async {
    try {
      List<WebsiteInfo> rWeb = new List<WebsiteInfo>.from(readedWebs);
      setState(() {
        _webList = checkLoadingPagesAssert();
        readedWebs.clear();
      });

      rWeb.sort((a, b) {
        DateTime dataA = DateTime.parse(a.DATE);
        DateTime dataB = DateTime.parse(b.DATE);
        return dataB.compareTo(dataA);
      });
      readedWebs = rWeb;

      setState(() {
        Global_refreshPage = true;
      });
    } catch (ex) {
      saveLogs.errorMessage(ex, this.context);
    }
  }

  //----------------------------------------------------
  Widget refresh() {
    return (RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(rotationController),
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTapCancel: () {
              setState(() {
                loadFromWebs(true);
              });
            },
            onLongPress: () async {
              _refreshLongPress();
            },
            onDoubleTap: () async {
              _refreshDoubleTap();
            },
            child: IconButton(
              iconSize: _refreshIconSizeAnimation.value,
              padding: const EdgeInsets.all(0),
              icon: Icon(Icons.refresh),
              color: GlobalTheme.textColor,
              onPressed: () {},
            ))));
  }

  void _refreshLongPress() {
    Toast.show("Refresh content", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    setState(() {
      loadFromWebs(false);
    });
  }

  void _refreshDoubleTap() {
    setState(() async {
      await refreshController.forward();
      reSortWebs();
      refreshController.reset();
    });
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

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      loadFromWebs(true);
    });
    _refreshController.refreshCompleted();
  }

  //*******************************APP****************************************
  @override
  Widget build(BuildContext context) {
    try {
      if (!appStarted) {
        webInfoLoadedWebLoad();
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
          child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: false,
              header: WaterDropHeader(),
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: _webList,
              ))),
    );
  }
}
