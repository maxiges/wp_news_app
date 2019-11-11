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
import "../Utils/Ads.dart";

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  @override
  _SettingPage createState() => _SettingPage();
}

class _SettingPage extends State<SettingPage>
    with SingleTickerProviderStateMixin {
  AnimationController animController;

  Ads settingAds = new Ads();

  double marginRightLeft = 5;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    settingAds.showBaner();
  }

  Future<bool> deletePage(WebPortal web) async {
    bool shouldUpdate = await YesNoDialog_ShowDialog(
        "Delete webside: \r\n" + web.url,
        Colors.red,
        context,
        Icon(
          Icons.file_download,
          color: Colors.blue,
          size: 36.0,
        ));

    if (shouldUpdate == true) {
      Global_webList.remove(web);
    }

    setState(() {
      websList();
    });
    return shouldUpdate;
  }

  void editPage(WebPortal web) async {
    bool istrue = await SettingAddPage_ShowDialog(web, this.context);
  }

  Widget websList() {
    List<Widget> webList = new List<Widget>();
    for (WebPortal WEB in Global_webList) {
      webList.add(Container(
          margin: EdgeInsets.only(
              top: 5, bottom: 5, left: marginRightLeft, right: marginRightLeft),
          height: 50,
          decoration: new BoxDecoration(
            color: GlobalTheme.tabsDayBackground,
          ),
          child: Align(
              alignment: Alignment.center,
              child: Center(
                  child: Container(
                      color: GlobalTheme.tabsColorPrimary,
                      //WEBSIDES
                      child: Row(children: <Widget>[
                        Container(
                          width: 50,
                          child: IconSlideAction(
                              caption: 'Edit',
                              color: Colors.greenAccent,
                              icon: Icons.edit,
                              onTap: () => editPage(WEB)),
                        ),
                        Container(
                            width: 50,
                            child: IconSlideAction(
                                caption: 'Detete',
                                color: Colors.redAccent,
                                icon: Icons.delete,
                                onTap: () => deletePage(WEB))),
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width - 150,
                          child: Center(
                            child: Text(
                              WEB.url,
                              style: TextStyle(
                                  color: GlobalTheme.textColor, fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: new BoxDecoration(
                            color: WEB.getColor(),
                            borderRadius:
                            new BorderRadius.all(Radius.circular(40)),
                          ),
                        ),
                      ]))))));
    }

    return (new Column(
      children: webList,
    ));
  }

  Widget signOutGoogle() {
    if (Global_GoogleSign.googleUserIsSignIn() == true) {
      return Center(
          child: Container(
            width: 300,
            margin: EdgeInsets.only(
                top: 30,
                bottom: 10,
                left: marginRightLeft,
                right: marginRightLeft),
            decoration: new BoxDecoration(
              color: Colors.redAccent,
              borderRadius: new BorderRadius.all(Radius.circular(30)),
            ),
            child: FlatButton(
              onPressed: () {
                Global_GoogleSign.signOutGoogle(context);
              },
              child: Row(
                // Repl
                mainAxisAlignment: MainAxisAlignment.center,
                // ace with a Row for horizontal icon + text
                children: <Widget>[
                  Icon(FontAwesomeIcons.google,
                      color: Color_getColorText(Colors.redAccent)),
                  Container(
                    width: 5,
                  ),
                  Flexible(
                      child: Text(
                        "Sign out " + Global_GoogleSign.getGoogleUser(),
                        style: TextStyle(
                            fontSize: 18,
                            color: Color_getColorText(Colors.redAccent)),
                      )),
                ],
              ),
            ),
          ));
    } else {
      return Center(
          child: Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
          ));
    }
  }

  Widget labelAddButtonPage() {
    return (new GestureDetector(
      onTap: () async {
        bool ischanget = await SettingAddPage_ShowDialog(
            new WebPortal("", ""), this.context);
        setState(() {
          websList();
        });
      },
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          width: 40,
          height: 40,
          decoration: new BoxDecoration(
            color: Colors.greenAccent,
            borderRadius: new BorderRadius.all(Radius.circular(50)),
          ),
          margin: EdgeInsets.all(0),
          child: IconButton(
            iconSize: 25,
            focusColor: Colors.red,
            hoverColor: Colors.orange,
            icon: Icon(Icons.add),
          ),
        ),
      ),
    ));
  }

  Widget label(String textString) {
    return (Container(
      margin: EdgeInsets.only(
          top: 10, bottom: 10, right: marginRightLeft, left: marginRightLeft),
      padding: EdgeInsets.only(top: 10, bottom: 10),
      width: MediaQuery
          .of(context)
          .size
          .width - 10,
      decoration: BoxDecoration(
        color: GlobalTheme.tabs,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        textString,
        style: TextStyle(
            fontSize: 20, color: Color_getColorText(GlobalTheme.tabs)),
        textAlign: TextAlign.center,
      ),
    ));
  }

  Widget darkLightModeUi() {
    return (Container(
      margin: EdgeInsets.only(
          top: 30, bottom: 10, left: marginRightLeft, right: marginRightLeft),
      decoration: new BoxDecoration(
        color: GlobalTheme.tabs,
        borderRadius: new BorderRadius.all(Radius.circular(5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("   Change to darkmode:",
              style: TextStyle(
                  color: Color_getColorText(GlobalTheme.tabs), fontSize: 20)),
          Switch(
            value: Global_Settings.isDarkTheme(),
            activeTrackColor: Colors.lightGreen,
            activeColor: Colors.green,
            onChanged: (value) {
              setState(() {
                Global_Settings.setTheme(value);
                if (value) {
                  setState(() {
                    GlobalTheme = GlobalThemeDart;
                  });
                } else {
                  setState(() {
                    GlobalTheme = GlobalThemeLight;
                  });
                }
              });
            },
          ),
        ],
      ),
    ));
  }

  Widget addsOnUi() {
    return (Container(
      margin: EdgeInsets.only(
          top: 30, bottom: 10, left: marginRightLeft, right: marginRightLeft),
      decoration: new BoxDecoration(
        color: GlobalTheme.tabs,
        borderRadius: new BorderRadius.all(Radius.circular(5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(" Ads ON (Don't off please support me)",
              style: TextStyle(
                  color: Color_getColorText(GlobalTheme.tabs), fontSize: 14)),
          Switch(
            value: Global_Settings.isAdsOn(),
            activeTrackColor: Colors.lightGreen,
            activeColor: Colors.green,
            onChanged: (value) {
              setState(() {
                Global_Settings.setAddsOn(value);
              });
            },
          ),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalTheme.background,
      appBar: AppBar(
        backgroundColor: GlobalTheme.navAccent,
        textTheme: GlobalTheme.textTheme,
        iconTheme: GlobalTheme.iconTheme,
        title: const Text(
          'Setting',
          style: TextStyle(fontSize: 20),
        ),
        leading: IconButton(
          iconSize: 30,
          padding: const EdgeInsets.all(0),
          onPressed: () async {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: <Widget>[
          IconButton(
            iconSize: 30,
            padding: const EdgeInsets.all(0),
            onPressed: () async {
              aboutInfoDialog(this.context);
            },
            icon: Icon(Icons.info_outline),
          ),
        ],
      ),
      body: ListView(children: <Widget>[
        Stack(children: [
          label("Webside"),
          Positioned(
            bottom: 0,
            right: 10,
            child: labelAddButtonPage(),
          ),
        ]),
        Container(
          height: 10,
        ),
        websList(),
        darkLightModeUi(),
        addsOnUi(),
        signOutGoogle(),
        Container(
          height: 120,
        ),
      ]),
    );
  }

  void dispose() {
    super.dispose();
    settingAds.dispose();
  }
}
