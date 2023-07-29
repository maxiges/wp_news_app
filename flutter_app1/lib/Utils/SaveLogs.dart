import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'dart:core';
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';
import 'package:WP_news_APP/Class/Time.dart';

SaveLogs saveLogs = new SaveLogs();

const logLevelInfo = "INFO";
const logLevelError = "ERROR";

class LogElement {
  late final String shortError;
  late final String longError;
  late final String stack;
  late final String type;
  late final String time;

  List<String> getStack(int size) {
    var stack = StackTrace.current;
    var stackString = "$stack";
    List<String> stackList = stackString.split('\n');

    List<String> returnList = [];

    for (String element in stackList) {
      if (returnList.length > size) {
        break;
      }
      if (element.trim().length < 2) {
        continue;
      }
      if (element.trim().indexOf("LogElement") > 0) {
        continue;
      }
      if (element.trim().indexOf("SaveLogs") > 0) {
        continue;
      }
      returnList.add(element.trim());
    }

    return returnList;
  }

  String toString() {
    return "[" + type + "] " + time + " " + shortError + "\r\n" + stack;
  }

  String _getShortName(String message) {
    int maxShortLength = message.length;
    if (maxShortLength > 100) {
      maxShortLength = 100;
    }
    int indexOf = message.lastIndexOf(";");
    if (indexOf > 0 && indexOf < maxShortLength) {
      maxShortLength = indexOf;
    }
    indexOf = message.lastIndexOf("\n");
    if (indexOf > 0 && indexOf < maxShortLength) {
      maxShortLength = indexOf;
    }
    indexOf = message.lastIndexOf("\t");
    if (indexOf > 0 && indexOf < maxShortLength) {
      maxShortLength = indexOf;
    }
    return message.substring(0, maxShortLength);
  }

  LogElement(String message) {
    List<String> stackList = getStack(8);
    this.shortError = this._getShortName(message);
    this.longError = message;
    this.stack = stackList.join("\r\n");
    this.type = logLevelError;
    this.time = Time.timeNowToLocalTimeString();
  }

  LogElement.info(String message) {
    List<String> stackList = getStack(3);
    this.shortError = this._getShortName(message);
    this.longError = message;
    this.stack = stackList.join("\r\n");
    this.type = logLevelInfo;
    this.time = Time.timeNowToLocalTimeString();
  }

  LogElement.fromJson(Map<String, dynamic> json) {
    this.fromJson(json);
  }

  fromJson(Map<String, dynamic> json) {
    try {
      shortError = json['shortError'];
      longError = json['longError'];
      type = json['type'];
      time = json['time'];
      stack = json['stack'];
    } catch (ex) {
      saveLogs.error(ex.toString());
    }
  }

  Map<String, dynamic> toJson() => {
        'shortError': shortError,
        'longError': longError,
        'stack': stack,
        'type': type,
        'time': time,
      };
}

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
    LogElement logObj = LogElement.info(data);
    log(logObj.toString());
  }

  error(String data) async {
    LogElement logObj = LogElement(data);
    log(logObj.toString());
    this._write(logObj);
  }

  errorMessage(String data, dynamic context) async {
    Toast.show("Error:⚠", duration: Toast.lengthLong, gravity: Toast.bottom);
    this.error(data);
  }

  _checkFileIsNotToBig() async {
    const int maxLogs = 20;
    final file = await _localFile;
    final List<String> lines = await file.readAsLines();
    if (lines.length > maxLogs) {
      lines.removeRange(0, (lines.length - (maxLogs / 2)).round());
      await file.writeAsString(lines.join('\r\n'));
    }
  }

  _write(LogElement logObj) async {
    try {
      final file = await _localFile;
      String jsonString = jsonEncode(logObj.toJson()) + "\r\n";
      await file.writeAsString(jsonString, mode: FileMode.append);
      this._checkFileIsNotToBig();
    } catch (ex) {
      LogElement logObj = LogElement(ex.toString());
      log(logObj.toString());
    }
  }

  Future<List<LogElement>?> read() async {
    try {
      final file = await _localFile;
      // Read the file.
      List<String> contents = await file.readAsLines(encoding: utf8);
      List<LogElement> list = [];
      contents.forEach((element) {
        try {
          Map<String, dynamic> userMap = jsonDecode(element);
          list.add(LogElement.fromJson(userMap));
        } catch (ex) {
          list.add(LogElement("DECODE LOG ERROR"));
        }
      });
      return list;
    } catch (ex) {
      LogElement logObj = LogElement(ex.toString());
      log(logObj.toString());
    }
    return null;
  }

  delete() async {
    try {
      final file = await _localFile;
      if (await file.exists() == true) {
        file.deleteSync();
      }
      file.create();
    } catch (e) {}
  }
}
