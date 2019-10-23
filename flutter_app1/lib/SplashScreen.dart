import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';

import 'Class/WebPortal.dart';
import 'Class/WebsideInfo.dart';
import 'Globals.dart';
import 'package:package_info/package_info.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Elements/GoogleSignIn.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animController;
  Timer _timer;
  bool runApp = true;
  bool _tryLoadGoogleAcc = true;
  int caunt = 0;
  List<Widget> buttonlist;

  var _width;
  var _height;



  @override
  void initState() {
    super.initState();
    animController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _timerStart();
  }

  _timerStart() {
    setState(() {
      buttonlist = retButtons(true);
    });
    _timer = new Timer.periodic(
        Duration(seconds: 2), (Timer timer) => TimerService());
    animController.repeat(period: Duration(milliseconds: 1000));
  }

  _timerStop() {
    _timer.cancel();
    animController.stop();
    caunt = 0;
    setState(() {
      buttonlist = retButtons(false);
    });
    _tryLoadGoogleAcc = false;
  }

  TimerService() {
    if (_tryLoadGoogleAcc == true) {
      caunt++;
      if (caunt > 10) {
        _timerStop();
      }
    }
  }

  setVrtsionApp() async {
    Global_packageInfo = await PackageInfo.fromPlatform();
  }

  tryLoginAutomaticly() async {
    bool isSignIn = await Global_GoogleSign.getActLoginStat();
    if (isSignIn == true) {
      _tryLoadGoogleAcc = true;
      try {
        Global_GoogleSign.TryLogInbyGoogle(context);
      } catch (ex) {
        assert(ex);
        setState(() {
          _tryLoadGoogleAcc = false;
        });
      }
    } else {
      setState(() {
        _tryLoadGoogleAcc = false;
      });
    }
  }

  List<Widget> retButtons(bool load) {
    if (load == true) {
      return [
        Container(
          child: RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(animController),
            child: CircularProgressIndicator(value: 0.4),
          ),
        ),
      ];
    } else {
      return [
        Container(
          width: 300,
        child:FlatButton(
          onPressed: () {
            Global_GoogleSign.TryLogInbyGoogle(context);
            _timerStop();
          },
          color: Colors.blueAccent,
          child: Row(
            // Repl
            mainAxisAlignment: MainAxisAlignment.center,
            // ace with a Row for horizontal icon + text
            children: <Widget>[
              Icon(FontAwesomeIcons.google),
              Text("  Sign in by Google")
            ],
          ),
        ),
        ),
        Container(
          height: 20,
        ),
        Container(
    width: 300,
       child: FlatButton(
          onPressed: () async {
            _timerStart();
            _tryLoadGoogleAcc = true;
            if (Global_GoogleSign.GoogleUserIsSignIn() == true) {
              await Global_GoogleSign.SignOutGoogle(context);
            }
            await LoadFromStorage();
            _timerStop();
            await Navigator.of(context).pushNamed('/mainScreen');

          },
          color: Colors.orange,
          child: Row(
            // Replace with a
            mainAxisAlignment: MainAxisAlignment.center,
            // Row for horizontal icon + text
            children: <Widget>[
              Icon(Icons.person),
              Text("  Sign in like a guest")
            ],
          ),
        ),
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {

    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    buttonlist = retButtons(_tryLoadGoogleAcc);
    setVrtsionApp();
    if (runApp) {
      _timerStart();
      runApp = false;
      tryLoginAutomaticly();
    }
    double _imageSize = 200;
    double _imageTopMargin = 100;
    if(_height< 700)
      {
        _imageTopMargin = 10;
      }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Center(
            child: Container(
                height: _imageSize,
                margin: new EdgeInsets.only(top: _imageTopMargin),
                child: Image(
                  image: AssetImage("images/my_logo.png"),
                )),
          ),
          Container(
            height: 50,
            child: const Center(
                child: Text('Welcome in WordPress News Collector APP')),
          ),
          Column(
            children: buttonlist,
          )
        ],
      )),
    );
  }
}
