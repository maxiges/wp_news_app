import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';
import '../Globals.dart';

import 'package:shared_preferences/shared_preferences.dart';

class GoogleSign {
  FirebaseUser _googleUser;
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _UserSigin = false;

  Future<bool> getActLoginStat() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _UserSigin = prefs.getBool("GoogleSign");
    return _UserSigin;
  }

  saveActLoginStat(bool stat) async {
    _UserSigin = stat;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("GoogleSign", stat);
  }

  Future<FirebaseUser> signInWithGoogle() async {
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

      return user;
    } catch (ex) {
      assert(ex);
    }
  }

  Future<void> TryLogInbyGoogle(context) async {
    try {
      _googleUser = await signInWithGoogle();
      await LoadFromStorage();
      await saveActLoginStat(true);

      await Navigator.of(context).pushNamed('/mainScreen');
    } catch (ex) {
      assert(ex);
      saveActLoginStat(false);
      Toast.show("Please sign in or login like guest", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Future<void> SignOutGoogle(context) async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      await saveActLoginStat(false);
      _googleUser = null;
      while (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    } catch (ex) {
      assert(ex);
    }
  }

  bool GoogleUserIsSignIn() {
    if (_googleUser != null) return true;
    return false;
  }

  String getGoogleUser() {
    return _googleUser.email.substring(0, _googleUser.email.indexOf("@"));
  }

  String getGoogleUserEmail() {
    return _googleUser.email;
  }
}
