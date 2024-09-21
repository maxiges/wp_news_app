import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../Globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/SaveLogs.dart';
import 'dart:convert' show json;

import "package:http/http.dart" as http;

GoogleSignIn _googleSignIn = GoogleSignIn();

class GoogleSign {
  late GoogleSignInAccount _currentUser;
  User? _googleUser;
  bool _userSignIn = false;
  late FirebaseAuth _auth;

  GoogleSign() {
    _auth = FirebaseAuth.instance;
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    final String namedContact = _pickFirstNamedContact(data);
  }

  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return "";
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Future<bool> getActLoginStat() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _userSignIn = false;
    bool? isSignIn = prefs.getBool("GoogleSign");
    if (isSignIn != null) {
      _userSignIn = isSignIn;
    }

    return _userSignIn;
  }

  saveActLoginStat(bool stat) async {
    _userSignIn = stat;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("GoogleSign", stat);
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      if (_googleUser != null) {
        return _googleUser;
      } else {
        AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final User? user =
            (await _auth.signInWithCredential(authCredential)).user;

        return user;
      }
    } catch (ex) {
      print("------------");
      print(ex.toString());
      saveLogs.error(ex.toString());
    }
    return null;
  }

  Future<void> tryLogInbyGoogle(context) async {
    try {
      _googleUser = (await signInWithGoogle())!;
      await loadFromStorage();
      await saveActLoginStat(true);

      await Navigator.of(context).pushReplacementNamed('/mainScreen');
    } catch (ex) {
      saveLogs.error(ex.toString());
      saveActLoginStat(false);
      Toast.show("Please sign in or login like guest",
          duration: Toast.lengthLong, gravity: Toast.bottom);
    }
  }

  Future<void> signOutGoogle(context) async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      await saveActLoginStat(false);

      while (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      Navigator.of(context).popAndPushNamed("/splashScreen");
    } catch (ex) {
      saveLogs.error(ex.toString());
    }
  }

  bool googleUserIsSignIn() {
    if (_googleUser != null) return true;
    return false;
  }

  String getGoogleUser() {
    String? email =
        _googleUser?.email!.substring(0, _googleUser?.email!.indexOf("@"));
    if (email == null) {
      return "";
    }
    return email;
  }

  String getGoogleUserEmail() {
    String? email = _googleUser?.email;
    if (email == null) {
      return "";
    }
    return email;
  }
}
