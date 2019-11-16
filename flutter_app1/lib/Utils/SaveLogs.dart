import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

SaveLogs saveLogs = new SaveLogs();

class SaveLogs {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/logs.txt');
  }

  Future<File> write(String data) async {
    final file = await _localFile;
    var now = new DateTime.now();
    data = now.toString() + "   :  " + data + "  \r\n";
    // Write the file.
    return file.writeAsString(data, mode: FileMode.append);
  }

  Future<String> read() async {
    try {
      final file = await _localFile;

      // Read the file.
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      return new DateTime.now().toString() +
          "Read log file error" +
          e.toString();
    }
  }

  logIsExist() async {
    final file = await _localFile;
    if (await file.exists() == false) {
      file.create();
    }
  }

  delete() async {
    try {
      final file = await _localFile;
      if (await file.exists() == true) {
        file.deleteSync();
      }

      file.create();
      file.writeAsString("New file log dir:" + file.path);
    } catch (e) {
      assert(e);
    }
  }
}
