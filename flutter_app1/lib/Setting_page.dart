import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';

import 'package:flutter_slidable/flutter_slidable.dart';

import 'Globals.dart';
import 'Class/WebsideInfo.dart';
import 'Dialogs/YesNoAlert.dart';
import 'Dialogs/Setting_add_Page.dart';
import 'Class/WebPortal.dart';
import 'Dialogs/AbautInfo.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Elements/GoogleSignIn.dart';

class Setting_page extends StatefulWidget {
  Setting_page({Key key}) : super(key: key);

  @override
  _Setting_page createState() => _Setting_page();
}

class _Setting_page extends State<Setting_page>
    with SingleTickerProviderStateMixin {
  AnimationController animController;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
  }

  Future<bool> deletePage(WebPortal Webside) async {
    bool shouldUpdate = await ShowDialog(
        "Delete webside: \r\n" + Webside.url,
        Colors.red,
        context,
        Icon(
          Icons.file_download,
          color: Colors.blue,
          size: 36.0,
        ));

    if (shouldUpdate == true) {
      Global_webList.remove(Webside);
    }

    setState(() {
      websideList();
    });
    return shouldUpdate;
  }

  void editPage(WebPortal WEB) async {
    bool istrue = await AddEditPageDialogPage(WEB, this.context);
    setState(() {});
  }

  Widget websideList() {
    List<Widget> websides = new List<Widget>();
    for (WebPortal WEB in Global_webList) {
      websides.add(Container(
          margin: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
          height: 50,
          decoration: new BoxDecoration(
            color: Colors.black26,
          ),
          child: Align(
              alignment: Alignment.center,
              child: Center(
                  child: Container(

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
                  width: MediaQuery.of(context).size.width - 150,
                  child: Center(
                    child: Text(WEB.url),
                  ),
                ),
                Container(
                  width: 30,
                  height: 30,
                  decoration: new BoxDecoration(
                    color: WEB.getColor(),
                    borderRadius: new BorderRadius.all(Radius.circular(40)),
                  ),
                ),
              ]))))));
    }

    return (new Column(
      children: websides,
    ));
  }

  Widget signOutGoogle() {
    if (Global_GoogleSign.GoogleUserIsSignIn() == true) {
      return Center(
          child: Container(
        margin: EdgeInsets.only(top: 30, bottom: 10, left: 10, right: 10),
        child: FlatButton(
          onPressed: () {
            Global_GoogleSign.SignOutGoogle(context);
          },
          color: Colors.redAccent,
          child: Row(
            // Repl
            mainAxisAlignment: MainAxisAlignment.center,
            // ace with a Row for horizontal icon + text
            children: <Widget>[
              Icon(FontAwesomeIcons.google),
              Text(
                "  Sign out " + Global_GoogleSign.getGoogleUser(),
                style: TextStyle(fontSize: 18),
              )
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

  Widget label(String textString) {
    return (Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 5),
      padding: EdgeInsets.only(top: 5, bottom: 5),
      height: 30,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        textString,
        style: TextStyle(fontSize: 15),
        textAlign: TextAlign.center,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
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
        label("Webside"),
        websideList(),
        signOutGoogle(),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool ischanget =
              await AddEditPageDialogPage(new WebPortal("", ""), this.context);

          setState(() {
            websideList();
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
