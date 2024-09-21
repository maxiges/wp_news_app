import 'dart:ffi';

import 'package:WP_news_APP/Decors/decors.dart';
import 'package:WP_news_APP/Utils/ColorsFunc.dart';
import 'package:WP_news_APP/Utils/WebFilter.dart';
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

class SettingPage extends StatefulWidget {
  SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPage createState() => _SettingPage();
}

class _SettingPage extends State<SettingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animController;

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      // Thumb icon when the switch is selected.
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  double marginRightLeft = 5;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
  }

  deletePage(WebPortal web) async {
    bool shouldUpdate = await yesNoDialogShowDialog(
        "Delete website: \r\n" + web.url,
        Colors.red,
        context,
        Icon(
          Icons.file_download,
          color: Colors.blue,
          size: 36.0,
        ));

    setState(() {
      websList();
    });

    if (shouldUpdate == true) {
      Global_webList.remove(web);
      webPortalSaveWebs(Global_webList);
    }
  }

  void editPage(WebPortal web) async {
    bool _isTrue = await settingAddPageShowDialog(web, this.context);
    if (_isTrue) {
      setState(() {}); //refresh widget
    }
  }

  Widget websList() {
    double _tabHeight = 50.0;

    List<Widget> webList = [];
    for (WebPortal _web in Global_webList) {
      Widget isInvalid = Icon(
        Icons.check_circle_outline,
        color: Colors.greenAccent,
        size: 20.0,
        semanticLabel: 'Valid website',
      );
      if (_web.isInvalid) {
        isInvalid = Icon(
          Icons.cancel_outlined,
          color: Colors.redAccent,
          weight: 30,
          size: 20.0,
          semanticLabel: 'Invalid website',
        );
      }

      webList.add(Container(
          key: Key(_web.url),
          margin: EdgeInsets.only(
              top: 5, bottom: 5, left: marginRightLeft, right: marginRightLeft),
          height: _tabHeight,
          decoration: Decors.tab2BoxDecor,
          child: Align(
              alignment: Alignment.center,
              child: Center(
                  child: Slidable(
                      key: const ValueKey(0),
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            label: 'Edit',
                            foregroundColor: Colors.greenAccent,
                            backgroundColor: GlobalTheme.tabsColorPrimary,
                            icon: Icons.edit,
                            onPressed: (value) {
                              editPage(_web);
                            },
                          ),
                          SlidableAction(
                            label: "Delete",
                            backgroundColor: GlobalTheme.tabsColorPrimary,
                            foregroundColor: Colors.redAccent,
                            icon: Icons.delete,
                            onPressed: (value) {
                              deletePage(_web);
                            },
                          ),
                        ],
                      ),

                      //WEBSITES
                      child: Row(children: <Widget>[
                        Container(
                            width: 40,
                            alignment: Alignment.center,
                            height: _tabHeight ,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  isInvalid,
                                  Text(
                                    _web.requestTime,
                                    style: TextStyle(
                                        color: GlobalTheme.textColor,
                                        fontSize: 9),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )),
                        Container(
                          width: MediaQuery.of(context).size.width - 90,
                          child: Center(
                            child: Text(
                              _web.url,
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
                            color: _web.getColor(),
                            borderRadius:
                                new BorderRadius.all(Radius.circular(40)),
                          ),
                        ),
                      ]))))));
    }

    return (new Container(
        child: ReorderableListView(
      onReorder: (int oldIndex, int newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        setState(() {
          final WebPortal item = Global_webList.removeAt(oldIndex);
          Global_webList.insert(newIndex, item);
          webFilter.setPageFilter();
          webPortalSaveWebs(Global_webList);
        });
      },
      children: webList,
      shrinkWrap: true,
    )));
  }

  Widget signOutGoogle() {
    if (Global_GoogleSign.googleUserIsSignIn() == true) {
      return Center(
          child: Container(
        width: 300,
        margin: EdgeInsets.only(
            top: 30, bottom: 10, left: marginRightLeft, right: marginRightLeft),
        decoration: new BoxDecoration(
          color: Colors.redAccent,
          borderRadius: new BorderRadius.all(Radius.circular(30)),
        ),
        child: TextButton(
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
                    fontSize: 18, color: Color_getColorText(Colors.redAccent)),
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

  Widget seeLogs() {
    return Center(
        child: Container(
      width: 300,
      margin: EdgeInsets.only(
          top: 30, bottom: 10, left: marginRightLeft, right: marginRightLeft),
      child: TextButton(
        style: Decors.primaryButtonStyle,
        onPressed: () {
          Navigator.of(context).pushNamed("/logScreen");
        },
        child: Row(
          // Repl
          mainAxisAlignment: MainAxisAlignment.center,
          // ace with a Row for horizontal icon + text
          children: <Widget>[
            Icon(FontAwesomeIcons.bookSkull,
                color: Decors.primaryButtonStyleTextColour),
            Container(
              width: 20,
            ),
            Flexible(
                child: Text(
              "Show error logs",
              style: TextStyle(
                  fontSize: 18, color: Decors.primaryButtonStyleTextColour),
            )),
          ],
        ),
      ),
    ));
  }

  Widget labelAddButtonPage() {
    bool isTrue;
    return (Align(
        alignment: Alignment.topRight,
        child: MaterialButton(
          onPressed: () async {
            isTrue = await settingAddPageShowDialog(
                new WebPortal("", "", null, 5), this.context);
            if (isTrue) {
              setState(() {});
            }
          },
          color: Colors.greenAccent,
          textColor: Colors.black,
          padding: EdgeInsets.all(16),
          child: Icon(Icons.add, size: 24),
          shape: CircleBorder(),
        )));
  }

  Widget label(String textString) {
    return (Container(
      margin: EdgeInsets.only(
          top: 10, bottom: 10, right: marginRightLeft, left: marginRightLeft),
      padding: EdgeInsets.only(top: 10, bottom: 10),
      width: MediaQuery.of(context).size.width - 40,
      decoration: Decors.tabBoxDecor,
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
      decoration: Decors.tabBoxDecor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("   Change to dark mode:",
              style: TextStyle(
                  color: Color_getColorText(GlobalTheme.tabs), fontSize: 20)),
          Switch(
            value: Global_Settings.isDarkTheme(),
            thumbIcon: thumbIcon,
            activeTrackColor: Colors.greenAccent,
            activeColor: Colors.white24,
            onChanged: (value) {
              setState(() {
                Global_Settings.setTheme(value);
                setState(() {
                  GlobalTheme = value ? GlobalThemeDark : GlobalThemeLight;
                });
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
      decoration: Decors.tabBoxDecor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(" Ads ON (Don't off please support me)",
              style: TextStyle(
                  color: Color_getColorText(GlobalTheme.tabs), fontSize: 14)),
          Switch(
            value: Global_Settings.isAdsOn(),
            thumbIcon: thumbIcon,
            activeTrackColor: Colors.greenAccent,
            activeColor: Colors.white24,
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
        iconTheme: GlobalTheme.iconTheme,
        titleTextStyle: TextStyle(fontSize: 20, color: GlobalTheme.textColor),
        title: const Text('Setting'),
        leading: IconButton(
          iconSize: 30,
          padding: const EdgeInsets.all(0),
          onPressed: () async {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
          color: GlobalTheme.textColor,
        ),
        actions: <Widget>[
          IconButton(
            iconSize: 30,
            padding: const EdgeInsets.all(0),
            onPressed: () async {
              aboutInfoDialog(this.context);
            },
            icon: Icon(Icons.info_outline),
            color: GlobalTheme.textColor,
          ),
        ],
      ),
      body: ListView(
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          children: <Widget>[
            Stack(children: [
              label("Website"),
              Positioned(
                bottom: 6,
                right: -10,
                child: labelAddButtonPage(),
              ),
            ]),
            Container(
              height: 10,
            ),
            websList(),
            darkLightModeUi(),
            addsOnUi(),
            seeLogs(),
            signOutGoogle(),
            Container(
              height: 120,
            ),
          ]),
    );
  }

  void dispose() {
    super.dispose();
  }
}
