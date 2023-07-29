import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import '../Decors/decors.dart';
import '../Globals.dart';
import 'package:package_info/package_info.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/foundation.dart';
import '../Utils/SaveLogs.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animController;
  Timer? _timer;
  bool runApp = true;
  bool _tryLoadGoogleAcc = true;
  int counter = 0;
  late List<Widget> buttonList;

  var _width;
  var _height;

  @override
  void initState() {
    super.initState();
    animController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _timerStart();
    setVersionApp();
  }

  @override
  dispose() {
    _timerStop();
    animController.dispose();
    super.dispose();
  }

  _timerStart() {
    setState(() {
      buttonList = retButtons(true);
    });
    try {
      if (_timer != null) {
        _timer?.cancel();
        animController.stop();
      }
    } catch (ex) {
      saveLogs.error(ex.toString());
    }
    _timer = new Timer.periodic(
        Duration(seconds: 2), (Timer timer) => timerService());
    animController.repeat(period: Duration(seconds: 1));
  }

  _timerStop() {
    counter = 0;
    _tryLoadGoogleAcc = false;
    if (_timer != null) {
      _timer?.cancel();
    }
    animController.stop();
  }

  timerService() {
    if (_tryLoadGoogleAcc == true) {
      counter++;
      if (counter > 10) {
        _timerStop();
      }
    }
  }

  setVersionApp() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      Global_packageInfo = info;
    });
  }

  tryLoginAutomatically() async {
    bool isSignIn = await Global_GoogleSign.getActLoginStat();
    if (isSignIn == true) {
      _tryLoadGoogleAcc = true;
      try {
        Global_GoogleSign.tryLogInbyGoogle(context);
      } catch (ex) {
        saveLogs.error(ex.toString());
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
            child: CircularProgressIndicator(value: 0.4 , color: Colors.greenAccent,)
          ),
        ),
      ];
    } else {
      return buildLoginButtons();
    }
  }

  List<Widget> buildLoginButtons() {
    if (!isLargeWideScreen()) {
      return [
        Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(0),
          child: TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
            ),
            onPressed: () {
              Global_GoogleSign.tryLogInbyGoogle(context);
              _timerStop();
            },
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 50,
                    color: Colors.blueAccent,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "by Google",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: 50,
                  margin: EdgeInsets.only(left: 0, right: 50),
                  child: Icon(FontAwesomeIcons.google, color: Colors.white),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 20,
        ),
        Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
            ),
            onPressed: () async {
              _timerStart();
              _tryLoadGoogleAcc = true;
              if (Global_GoogleSign.googleUserIsSignIn() == true) {
                await Global_GoogleSign.signOutGoogle(context);
              }
              await loadFromStorage();
              _timerStop();
              await Navigator.of(context).pushReplacementNamed('/mainScreen');
            },
            child: Row(
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.only(left: 50, right: 0),
                  child: Icon(Icons.person, color: Colors.white),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    color: Colors.orange,
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    color: Colors.orange,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "like a guest",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ];
    } else {
      //--------------ELSE  largeScreen--------------------
      return [
        Container(
          width: 300,
          child: TextButton(
            onPressed: () {
              Global_GoogleSign.tryLogInbyGoogle(context);
              _timerStop();
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
              iconColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
            ),
            child: Row(
              // Repl
              mainAxisAlignment: MainAxisAlignment.center,
              // ace with a Row for horizontal icon + text
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.google,
                  color: Colors.white,
                ),
                Text("  by Google",
                    style: TextStyle(color: Colors.white, fontSize: 20))
              ],
            ),
          ),
        ),
        Container(
          height: 20,
        ),
        Container(
          width: 300,
          child: TextButton(
            onPressed: () async {
              _timerStart();
              _tryLoadGoogleAcc = true;
              if (Global_GoogleSign.googleUserIsSignIn() == true) {
                await Global_GoogleSign.signOutGoogle(context);
              }
              await loadFromStorage();
              _timerStop();
              await Navigator.of(context).pushReplacementNamed('/mainScreen');
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
              iconColor: MaterialStateProperty.all<Color>(Colors.orange),
            ),
            child: Row(
              // Replace with a
              mainAxisAlignment: MainAxisAlignment.center,
              // Row for horizontal icon + text
              children: <Widget>[
                Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                Text("  like a guest",
                    style: TextStyle(color: Colors.white, fontSize: 20))
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
    buttonList = retButtons(_tryLoadGoogleAcc);

    if (runApp) {
      _timerStart();
      runApp = false;
      tryLoginAutomatically();
    }
    double _imageSize = 200;
    double _imageTopMargin = 100;
    if (_height < 700) {
      _imageTopMargin = 10;
      _imageSize = 150;
    }

    Widget _kinderGardenBut = Container();
    if (!kReleaseMode) {
      _kinderGardenBut = Container(
        child: TextButton(
          style: Decors.basicButtonStyle,
          onPressed: () {
            Navigator.of(context).pushNamed('/kinderGarden');
          },
          child: Text("Press go to KinderGarden "),
        ),
      );
    }

    return Scaffold(
      backgroundColor: GlobalTheme.background,
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
                children: <Widget>[
                  Center(
                    child: Container(
                        height: _imageSize,
                        margin: new EdgeInsets.only(top: _imageTopMargin),
                        child: Image(
                          image: AssetImage("assets/icon.png"),
                        )),
                  ),
                  Container(
                    height: 50,
                    child: const Center(
                        child: Text(
                      'Sign In',
                      style: TextStyle(fontSize: 30, color: Colors.blueAccent),
                    )),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: buttonList,
                      )),
                ],
              ),
            ),
            Container(child: _kinderGardenBut),
            Align(
                child: Container(
              child: Text(
                "Ver:" + Global_packageInfo.version,
                style: TextStyle(color: Colors.orange),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
