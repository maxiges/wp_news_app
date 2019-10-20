import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';

import 'Class/WebPortal.dart';
import 'Class/WebsideInfo.dart';
import 'Globals.dart';
import 'package:package_info/package_info.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';

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
  }

  bool runApp = true;

  setVrtsionApp() async {
    Global_packageInfo = await PackageInfo.fromPlatform();
  }

  static FirebaseAuth _auth = FirebaseAuth.instance;
  static GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<FirebaseUser> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      AuthCredential authCredential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      AuthResult fire = (await _auth.signInWithCredential(authCredential));

      final FirebaseUser user = fire.user;
      assert(user.email != null);
      assert(user.displayName != null);

      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      return user;
    } catch (ex) {
      assert(ex);
    }
  }

  @override
  Widget build(BuildContext context) {
    setVrtsionApp();

    Timer(Duration(seconds: 2), () {
      if (runApp || !Navigator.of(context).canPop()) {
        //   Navigator.of(context).pushNamed('/mainScreen');
        runApp = false;
      }
    });

    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
          Center(
          child: Container(
              height: 200.00,
              margin: new EdgeInsets.only(top: 100),
              child: Image(
                image: AssetImage("images/my_logo.png"),
              )),
        ),
        Container(
          height: 50,
          child: const Center(
              child: Text('Welcome in WordPress News Collector APP')),
        ),

            FlatButton(
              onPressed: () async {
                try {
                  Global_googleUser = await signInWithGoogle();
                  await LoadFromStorage();
                  await Navigator.of(context).pushNamed('/mainScreen');
                } catch (ex) {
                  assert(ex);
                  Toast.show("Please sign in or login like guest", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                }
              },
              color: Colors.blueAccent,

              child: Row( // Repl
                mainAxisAlignment: MainAxisAlignment.center,// ace with a Row for horizontal icon + text
                children: <Widget>[
                  Icon(Icons.lock),
                  Text("Sign in by Google")
                ],
              ),
            ),

Container(height: 20,),
            FlatButton(
              onPressed: () async {
                Global_googleUser = null;
                await LoadFromStorage();
                await Navigator.of(context).pushNamed('/mainScreen');
              },
              color: Colors.orange,

              child: Row( // Replace with a
                mainAxisAlignment: MainAxisAlignment.center,// Row for horizontal icon + text
                children: <Widget>[
                  Icon(Icons.person),
                  Text("Sign in like a guest")
                ],
              ),
            ),


          ],
        )),);
  }
}
