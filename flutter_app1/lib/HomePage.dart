import 'package:WP_news_APP/Dialogs/ShowMoreInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'dart:async';

import 'Class/WebsideInfo.dart';
import 'SplashScreen.dart';
import 'Dialogs/YesNoAlert.dart';
import 'Setting_page.dart';
import 'Globals.dart';
import 'Elements/PagesToTab.dart';
import 'Class/WebPortal.dart';
import 'Elements/GoogleSignIn.dart';




class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//****************************************************************************

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  var isPortrait  = true;
  List<WebsideInfo> g_readedWebside = new List<WebsideInfo>();
  List<Widget> g_webList = new List<Widget>();
  bool isOpendeSavedList = false;
  bool appStarted = false;
  AnimationController rotationController;
  int actLoadedPages = 0;
  Icon _actIcon = new Icon(Icons.storage);


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
    CheckLoadingPagesAssert();

    Global_timer = new Timer.periodic(
        Duration(microseconds: 100), (Timer timer) => TimerService());
  }

  void TimerService() {
    bool isPortraitNow= MediaQuery.of(context).orientation == Orientation.portrait;
    if ( isPortrait != isPortraitNow )
    {
      setState(() {
      Global_width = MediaQuery.of(context).size.width;
      Global_height = MediaQuery.of(context).size.height;
      isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
      Global_RefreshPage = true;

    });

    }

    if (Global_RefreshPage == true) {
      Global_RefreshPage = false;
      if (Global_ACT_TO_REFRESH == ACT_PAGE.SAVED_PAGES) {
        setState(() {
          buildersss(true);
        });
      } else if (Global_ACT_TO_REFRESH == ACT_PAGE.LOADED_PAGES) {
        setState(() {
          buildersss(false);
        });
      }
    }



  }



  List<Widget> CheckLoadingPagesAssert({String loadPageError}) {
    List<Widget> retVal = List<Widget>();
    if (Global_webList.length < 1) {
      retVal.add(new Center(
        child: Text("No pages to load.\r\n Go to settings ",
            style: TextStyle(fontSize: 18)),
      ));
    } else if (Global_webList.length == 1) {
      retVal.add(new Center(
        child: Text("LOADING  page ... ", style: TextStyle(fontSize: 18)),
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
              style: TextStyle(fontSize: 18),
            ),
          )));
      retVal.add(Container(
        height: 30,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: Colors.white,
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



  buildersss(bool tryLoadSavedLinks) {
    isOpendeSavedList = tryLoadSavedLinks;
    List<WebsideInfo> m_WebsideInfo_load = new List<WebsideInfo>();
    if (tryLoadSavedLinks) {
      _actIcon = new Icon(Icons.storage);
      m_WebsideInfo_load = Global_savedWebside;
    } else {
      _actIcon = new Icon(Icons.sd_storage);
      m_WebsideInfo_load = g_readedWebside;
    }
    List<Widget> wid = new List<Widget>();
    for (WebsideInfo iter in m_WebsideInfo_load) {
      wid.add(PagesToTab(iter, this.context));
    }
    if (m_WebsideInfo_load.length == 0) {
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
      g_webList = wid;
    });
  }

  List<Widget> setAddedPages() {
    List<Widget> m_ret = new List<Widget>();
    m_ret.add(Container(
      height: Global_height * 0.3,
    ));
    m_ret.add(Center(
      child: Text("You didn't add any webside \r\n Do to Settings",
          style: new TextStyle(fontSize: 18), textAlign: TextAlign.center),
    ));
    m_ret.add(Center(
      child: Icon(
        Icons.settings,
        color: Colors.greenAccent,
        size: 50.0,
        semanticLabel: 'No added webside',
      ),
    ));
    return m_ret;
  }

  List<Widget> setErrorLoadPage() {
    List<Widget> m_ret = new List<Widget>();
    m_ret.add(Container(
      height: Global_height * 0.3,
    ));
    m_ret.add(Center(
      child: Text(
          "Can't download content.\r\n Try reload or cheeck internet connection",
          style: new TextStyle(fontSize: 18),
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
          style: new TextStyle(fontSize: 18), textAlign: TextAlign.center),
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

  Future<List<WebsideInfo>> getPageAsync(WebPortal WEB) async {
    List<WebsideInfo> retval = await GetWebsideInfos(WEB);
    for (WebsideInfo webs in retval) {
      g_readedWebside.add(webs);
    }
    setState(() {
      actLoadedPages++;
      g_webList = CheckLoadingPagesAssert();
    });
    return retval;
  }

  void loadFromWebside() async {
    setState(() {
      actLoadedPages = 0;
      g_webList = CheckLoadingPagesAssert();
      g_readedWebside.clear();
    });
    Global_ACT_TO_REFRESH = ACT_PAGE.LOADED_PAGES;
    rotationController.repeat(period: Duration(milliseconds: 1000));

    List<Future> tasks = new List<Future>();

    for (WebPortal WEB in Global_webList) {
      tasks.add(getPageAsync(WEB));
    }

    await Future.wait(tasks);
    g_readedWebside.sort((a, b) {
      DateTime dataA = DateTime.parse(a.DATE);
      DateTime dataB = DateTime.parse(b.DATE);
      if (dataB.millisecondsSinceEpoch > dataA.millisecondsSinceEpoch) return 1;
      return 0;
    });

    Global_RefreshPage = true;
    rotationController.reset();
  }

  //------------------------------
  Widget refresh() {
    return (RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(rotationController),
        child: IconButton(
          iconSize: 30,
          padding: const EdgeInsets.all(0),
          onPressed: () async {
            setState(() {
              loadFromWebside();
            });
          },
          icon: Icon(Icons.refresh),
        )));
  }

  PreferredSizeWidget renderAppBar() {
    String userText = "Hello guest";
    if (Global_GoogleSign.GoogleUserIsSignIn() == true) {
      userText = Global_GoogleSign.getGoogleUser();
    }
    return (PreferredSize(
        preferredSize: Size.fromHeight(30.0),
        child: new AppBar(
          leading: refresh(),
          backgroundColor: Colors.transparent,
          title: Center(
            child: Text(userText),
          ),
          actions: <Widget>[
            new IconButton(
              iconSize: 30,
              padding: const EdgeInsets.all(0),
              icon: _actIcon,
              onPressed: () {
                if (Global_ACT_TO_REFRESH == ACT_PAGE.SAVED_PAGES) {
                  Global_ACT_TO_REFRESH = ACT_PAGE.LOADED_PAGES;
                } else {
                  Global_ACT_TO_REFRESH = ACT_PAGE.SAVED_PAGES;
                }

                Global_RefreshPage = true;
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
        Global_width = MediaQuery.of(context).size.width;
        Global_height = MediaQuery.of(context).size.height;
        loadFromWebside();
        appStarted = true;
      }
    } catch (ex) {}

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: renderAppBar(),
      body: Center(
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: g_webList,
          )),
    );
  }
}
