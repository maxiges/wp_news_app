import 'dart:async';
import 'dart:io';
import 'dart:developer';
import 'dart:core';
import 'package:path_provider/path_provider.dart';

SaveLogs saveLogs = new SaveLogs();

class SaveLogs {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    File data = File('$path/logs.txt');
    if (!await data.exists()) {
      data.create();
    }
    return data;
  }

  void info(String data) async {
    log("[Info ]" + data + "\r\n");
  }

  error(String data) async {
    var stack = StackTrace.current;
    var stackString = "$stack";
    List<String> stackList = stackString.split('\n');
    log("[Error ⚠ ]" + "\r\n" + data + "\r\n" + stackString);
    this._write("[Error ⚠ ]" + "\r\n" + data + "\r\n" + stackList[1] + "\r\n");
  }

  _write(String data) async {
    try {
      final file = await _localFile;
      var now = new DateTime.now();
      data = now.toString() + "   :  " + data + "  \r\n";
      await file.writeAsString(data, mode: FileMode.append);
    } catch (ex) {
      log("[Error ERROR ⚠ ]" + "\r\n" + ex.toString() + "\r\n");
    }
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
