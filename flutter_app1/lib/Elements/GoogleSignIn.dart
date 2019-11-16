import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../Globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/SaveLogs.dart';

class GoogleSign {
  FirebaseUser _googleUser;
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _userSignIn = false;

  Future<bool> getActLoginStat() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _userSignIn = prefs.getBool("GoogleSign");
    return _userSignIn;
  }

  saveActLoginStat(bool stat) async {
    _userSignIn = stat;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("GoogleSign", stat);
  }

  Future<FirebaseUser> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (_googleUser != null) {
        final FirebaseUser user = await _auth.currentUser();
        return user;
      } else {
        AuthCredential authCredential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        AuthResult fire = (await _auth.signInWithCredential(authCredential));
        final FirebaseUser user = fire.user;
        return user;
      }
    } catch (ex) {
      saveLogs.write(ex);
      assert(ex);
    }
    return null;
  }

  Future<void> tryLogInbyGoogle(context) async {
    try {
      _googleUser = await signInWithGoogle();
      await LoadFromStorage();
      await saveActLoginStat(true);

      await Navigator.of(context).pushNamed('/mainScreen');
    } catch (ex) {
      saveLogs.write(ex);
      assert(ex);
      saveActLoginStat(false);
      Toast.show("Please sign in or login like guest", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Future<void> signOutGoogle(context) async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      await saveActLoginStat(false);
      _googleUser = null;
      while (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    } catch (ex) {
      saveLogs.write(ex);
      assert(ex);
    }
  }

  bool googleUserIsSignIn() {
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
