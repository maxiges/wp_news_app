import 'dart:async';
import 'dart:io';

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

  Future<File> info(String data) async {
    print("[Info ]" + data + "\r\n");
  }

  error(String data) async {
    print("[Error ⚠ ]" + data + "\r\n");
    this._write("[Error ⚠ ]" + data + "\r\n");
  }

  _write(String data) async {
    try {
      final file = await _localFile;
      var now = new DateTime.now();
      data = now.toString() + "   :  " + data + "  \r\n";
      await file.writeAsString(data, mode: FileMode.append);
    } catch (ex) {
      print("[Error ERROR ⚠ ]" + ex.toString() + "\r\n");
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
