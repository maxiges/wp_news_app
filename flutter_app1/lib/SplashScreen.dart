import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';

import 'Class/WebPortal.dart';
import 'Class/WebsideInfo.dart';
import 'Globals.dart';
import 'package:package_info/package_info.dart';


class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);


  @override
  _SplashScreen createState() => _SplashScreen();
}


class _SplashScreen extends State<SplashScreen>
with SingleTickerProviderStateMixin {
  AnimationController animController;
  @override
  void initState() {
    super.initState();
    animController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    LoadFromStorage();
  }

  bool runApp = true;

  setVrtsionApp() async{
    Global_packageInfo = await PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {

    setVrtsionApp();


    Timer(Duration(seconds: 2), () {
      if(runApp || !Navigator.of(context).canPop()) {
        Navigator.of(context).pushNamed('/mainScreen');
        runApp = false;
      }

    });


    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: ListView(
            padding: const EdgeInsets.all(8),
            children:<Widget>[
              Center(
              child: Container(
                height:200.00 ,
                margin: new EdgeInsets.only(top: 100),
                child: Image(
                  image: AssetImage("images/my_logo.png"),
                )
              ),
              ),
                Container(
                height: 50,

                child: const Center(child: Text('Welcome in WordPress News Collector APP')),
              ),
            ],

          )),
    );


  }

}



