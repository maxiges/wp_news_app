import 'package:WP_news_APP/Decors/decors.dart';
import 'package:WP_news_APP/Utils/SaveLogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';
import '../Class/WebsiteInfo.dart';
import '../Globals.dart';
import '../Elements/PagesToTab.dart';
import '../Class/WebPortal.dart';
import 'dart:math';
import 'package:flutter_picker_plus/flutter_picker_plus.dart';
import '../Utils/WebFilter.dart';
import 'package:toast/toast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../Utils/WebPageAPI.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//****************************************************************************

enum FilterType { byDomain, byType }

class WebPortalDetails {
  WebPortal webPortal;
  String executeTime = "N/A";
  bool loaded;

  WebPortalDetails(this.webPortal, this.executeTime, this.loaded);
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  var isPortrait = true;
  List<Widget> _webList = [];
  bool isOpenSavedList = false;
  bool appStarted = false;
  int _actLoadedPages = 0;
  List<WebPortalDetails> _actLoadedWebs = [];
  bool _isLoading = false;
  Icon _actIcon = new Icon(Icons.storage);
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FilterType filterView = FilterType.byDomain;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  late AnimationController rotationController;
  late AnimationController refreshController;
  late Animation<double> _refreshIconSizeAnimation;

  void dispose() {
    super.dispose();
    Global_timer.cancel();
    rotationController.stop();
    rotationController.dispose();
    refreshController.stop();
    refreshController.dispose();
  }

  @override
  void initState() {
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    rotationController.stop();

    refreshController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    refreshController.repeat(period: Duration(milliseconds: 300));
    refreshController.stop();
    checkLoadingPagesAssert();
    _refreshIconSizeAnimation =
        Tween<double>(begin: 35, end: 25).animate(refreshController)
          ..addListener(() {
            setState(() {
              // The state that has changed here is the animation object’s value.
            });
          });

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

  Widget loadedPagesView() {
    List<Widget> widgets = [];
    this._actLoadedWebs.forEach((element) {
      widgets.add(Container(
        padding: const EdgeInsets.all(5),
        child: // Stroked text as border.
            Text(
          '${element.webPortal.url}  ${element.executeTime}s - ' + (element.loaded ? "✅" : "❌"),
          style: TextStyle(fontSize: 11, color: GlobalTheme.textColor),
        ),
      ));
    });
    return Column(
      children: widgets,
    );
  }

  List<Widget> checkLoadingPagesAssert() {
    double _borderRSide = 0;
    if (_actLoadedPages == Global_webList.length) {
      _borderRSide = 10;
    }

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
              _actLoadedPages.toString() +
              "/" +
              Global_webList.length.toString() +
              " pages ... ",
          style: TextStyle(fontSize: 18, color: GlobalTheme.textColor2),
        ),
      )));
      retVal.add(Container(
        height: 30,
        decoration: BoxDecoration(
          color: Colors.greenAccent.withAlpha(40),
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
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(_borderRSide),
                  topRight: Radius.circular(_borderRSide),
                ),
                border: Border.all(),
              ),
// Define how long the animation should take.
              duration: Duration(seconds: 1),
              // Provide an optional curve to make the animation feel smoother.
              curve: Curves.fastOutSlowIn,
              width: ((Global_width - 22) *
                      (_actLoadedPages / Global_webList.length) +
                  1),
            ),
          ],
        ),
      ));
    }

    retVal.add(this.loadedPagesView());
    return retVal;
  }

  void showSnackBar(String content) {}

  buildTableWithPages(bool tryLoadSavedLinks) {
    isOpenSavedList = tryLoadSavedLinks;
    List<WebsiteInfo> websiteInfoLoaded = [];
    if (tryLoadSavedLinks) {
      _actIcon = new Icon(Icons.storage);
      websiteInfoLoaded = Global_savedWebsList;
    } else {
      _actIcon = new Icon(Icons.sd_storage);
      websiteInfoLoaded = readWebsData;
    }

    List<Widget> wid = [];
    for (WebsiteInfo iWeb in websiteInfoLoaded) {
      if (!webFilter.webFilterIsOK(iWeb)) {
        continue;
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
    Stopwatch stopwatch = new Stopwatch()..start();
    List<WebsiteInfo> _ret = await webPageFetchAPI.websiteInfoGetWebPages(web);
    for (WebsiteInfo webs in _ret) {
      bool add = true;
      for (WebsiteInfo loaded in readWebsData) {
        if (loaded.url == webs.url) {
          add = false;
          break;
        }
      }
      if (add) {
        readWebsData.add(webs);
      }
    }
    if( _ret.length <= 0){
      web.setIsInvalid();
    }
    setState(() {
      _actLoadedPages++;
      _actLoadedWebs.add(
          WebPortalDetails(web, '${stopwatch.elapsed.inMilliseconds / 1000}s',_ret.length>0));
      _webList = checkLoadingPagesAssert();
    });
    web.setQueryTime('${stopwatch.elapsed.inMilliseconds / 1000}s');
    stopwatch.stop();


    return _ret;
  }

  void loadFromWebs(bool append) async {
    try {
      if (_isLoading) {
        return;
      }
      setState(() {
        _actLoadedPages = 0;
        _actLoadedWebs = [];
        _webList = checkLoadingPagesAssert();
        if (append == false) {
          readWebsData.clear();
        }
        _isLoading = true;
      });
      Global_actPageToRefresh = ACT_PAGE.LOADED_PAGES;
      refreshController.reset();
      refreshController.forward();
      rotationController.repeat(period: Duration(milliseconds: 1000));
      rotationController.reset();
      rotationController.forward();

      List<Future> tasks = [];
      for (WebPortal _website in Global_webList) {
        tasks.add(getPageAsync(_website));
      }
      await Future.wait(tasks);
      reSortWebs();

      setState(() {
        _isLoading = false;
      });
    } catch (ex) {
      saveLogs.error(ex.toString());
      setState(() {
        _isLoading = false;
      });
    }
    rotationController.stop(canceled: true);
    refreshController.stop(canceled: true);
  }

  void reSortWebs() async {
    try {
      List<WebsiteInfo> rWeb = new List<WebsiteInfo>.from(readWebsData);
      setState(() {
        _webList = checkLoadingPagesAssert();
        readWebsData.clear();
      });

      rWeb.sort((a, b) {
        DateTime dataA = DateTime.parse(a.articleDate);
        DateTime dataB = DateTime.parse(b.articleDate);
        return dataB.compareTo(dataA);
      });
      readWebsData = rWeb;

      setState(() {
        Global_refreshPage = true;
      });
    } catch (ex) {
      saveLogs.errorMessage(ex.toString(), this.context);
    }
  }

  //----------------------------------------------------
  Widget refresh() {
    return (SizedBox(
        child: RotationTransition(
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
                )))));
  }

  void _refreshLongPress() {
    Toast.show("Refresh content",
        duration: Toast.lengthLong, gravity: Toast.bottom);
    setState(() {
      loadFromWebs(false);
    });
  }

  void _refreshDoubleTap() async {
    refreshController.reset();
    await refreshController.forward();
    reSortWebs();
    refreshController.stop();
  }

  showPicker(BuildContext context) {

    double height =  MediaQuery.of(context).size.width;
    Picker picker = Picker(
        adapter: PickerDataAdapter(
            data: filterView == FilterType.byDomain
                ? webFilter.getFilterDataList()
                : webFilter.getFilterDataListForType()),
        changeToFirst: true,
        columnPadding: const EdgeInsets.all(8.0),
        itemExtent: 50,
        textAlign: TextAlign.center,
        textStyle: const TextStyle(color: Colors.blue , fontSize: 25 ),
        selectedTextStyle: TextStyle(color: Colors.red),
        backgroundColor: GlobalTheme.background,
        cancelText: "Cancel",
        headerColor: GlobalTheme.background,
        containerColor: GlobalTheme.background,
        cancelTextStyle: TextStyle(color: GlobalTheme.textColor),
        confirmTextStyle: TextStyle(color: GlobalTheme.tabs),
        height: height/2,
        smooth: 5,
        onConfirm: (Picker picker, List value) {
          setState(() {
            if (filterView == FilterType.byType) {
              webFilter
                  .setFilterByType(picker.getSelectedValues()[0].toString());
            } else {
              webFilter
                  .setFilterByDomain(picker.getSelectedValues()[0].toString());
            }
            Global_refreshPage = true;
          });
        });
    picker.show(_scaffoldKey.currentState!);
  }

  PreferredSizeWidget renderAppBar(BuildContext context) {
    String userText = "Hello guest";
    if (Global_GoogleSign.googleUserIsSignIn() == true) {
      userText = Global_GoogleSign.getGoogleUser();
    }

    return (PreferredSize(
        preferredSize: Size.fromHeight(78.0),
        child: Column(children: [
          AppBar(
            backgroundColor: GlobalTheme.navAccent,
            iconTheme: GlobalTheme.iconTheme,
            leading: refresh(),
            title: Container(
              child: TextButton(
                style: ButtonStyle(
                  alignment: Alignment.center,
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 0)),
                  iconColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        filterView == FilterType.byDomain
                            ? webFilter.getFilterByDomain()
                            : webFilter.getFilterByType(),
                        style: TextStyle(
                            color: GlobalTheme.textColor, fontSize: 12),
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
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.all(0.0),
                child: IconButton(
                  iconSize: 30,
                  padding: const EdgeInsets.all(0),
                  icon: _actIcon,
                  color: GlobalTheme.textColor,
                  onPressed: () {
                    if (Global_actPageToRefresh == ACT_PAGE.SAVED_PAGES) {
                      Global_actPageToRefresh = ACT_PAGE.LOADED_PAGES;
                    } else {
                      Global_actPageToRefresh = ACT_PAGE.SAVED_PAGES;
                    }
                    Global_refreshPage = true;
                  },
                ),
              ),
              new IconButton(
                iconSize: 30,
                padding: const EdgeInsets.all(0),
                icon: new Icon(Icons.settings),
                color: GlobalTheme.textColor,
                onPressed: () {
                  Navigator.of(context).pushNamed('/settingScreen');
                },
              ),
            ],
          ),
          Transform.translate(
            offset: const Offset(0, -10),
            child: Container(
                child: Row(
              children: [
                Container(
                    height: 20,
                    width: 150,
                    child: Row(children: [
                      TextButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(0)),
                              shadowColor: MaterialStateProperty.all<Color>(
                                  GlobalTheme.basicButtonBackground),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  filterView == FilterType.byDomain
                                      ? Colors.blueAccent
                                      : Colors.grey),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(7),
                                    bottomLeft: Radius.circular(7)),
                              ))),
                          onPressed: () {
                            setState(() {
                              filterView = FilterType.byDomain;
                            });
                          },
                          child: Padding(
                              padding: EdgeInsets.only(bottom: 0),
                              child: Text(
                                'By domain',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              ))),
                      TextButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(0)),
                              shadowColor: MaterialStateProperty.all<Color>(
                                  GlobalTheme.basicButtonBackground),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  filterView == FilterType.byType
                                      ? Colors.blueAccent
                                      : Colors.grey),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(7),
                                    bottomRight: Radius.circular(7)),
                              ))),
                          onPressed: () {
                            setState(() {
                              filterView = FilterType.byType;
                            });
                          },
                          child: Padding(
                              padding: EdgeInsets.only(bottom: 0),
                              child: Text(
                                'By type',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              ))),
                    ])),
                Spacer(),
                Container(
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: GlobalTheme.navAccent,
                  ),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 2),
                  child: Text(userText,
                      style: new TextStyle(
                          fontSize: 14, color: GlobalTheme.textColor)),
                ),
              ],
            )),
          ),
        ])));
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
    ToastContext().init(context);
    try {
      if (!appStarted) {
        webInfoLoadedWebLoad();
        Global_width = MediaQuery.of(context).size.width;
        Global_height = MediaQuery.of(context).size.height;
        loadFromWebs(true);
        appStarted = true;
      }
    } catch (ex) {
      saveLogs.error(ex.toString());
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: GlobalTheme.background,
      appBar: renderAppBar(context),
      body: Center(
          child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: false,
              header: WaterDropHeader(),
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: ListView(
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                children: _webList,
              ))),
    );
  }
}
