import 'package:WP_news_APP/Decors/decors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../Globals.dart';
import "../Utils/SaveLogs.dart";

class LogPage extends StatefulWidget {
  LogPage({Key? key}) : super(key: key);

  @override
  _LogPage createState() => _LogPage();
}

class _LogPage extends State<LogPage> with SingleTickerProviderStateMixin {
  List<LogElement>? _currLogs = [];
  Size? _systemSize;

  @override
  void initState() {
    super.initState();
    logData();
  }

  logData() async {
    _currLogs = await saveLogs.read();
    setState(() {
      this._currLogs = _currLogs;
    });
  }

  Widget getWidgetNoLogs() {
    return Container(
        child: Align(
      alignment: Alignment.center,
      child: Text(
        "NO LOGS",
        style: TextStyle(fontSize: 16, color: GlobalTheme.textColor),
      ),
    ));
  }

  Widget getWidgetLogs(LogElement logOBJ, BuildContext context) {
    const double _radius = 2.0;
    Color _typeBoxBorderColour = Colors.green;
    if (logOBJ.type == logLevelError) {
      _typeBoxBorderColour = Colors.red;
    }

    Widget _typeContainer = Positioned(
        top: 0,
        child: Align(
            alignment: Alignment.center,
            child: Transform.translate(
              offset: Offset(0, 0),
              child: Container(
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.all(Radius.circular(_radius)),
                  color: _typeBoxBorderColour,
                ),
                padding: new EdgeInsets.all(1),
                width: 65,
                child: Center(
                    child: Container(
                  decoration: new BoxDecoration(
                    borderRadius:
                        new BorderRadius.all(Radius.circular(_radius)),
                    color: GlobalTheme.tabsDayBackground,
                  ),
                  width: 65,
                  child: Center(
                    child: // Stroked text as border.
                        Text(
                      logOBJ.type,
                      style:
                          TextStyle(fontSize: 11, color: GlobalTheme.textColor),
                    ),
                  ),
                  // Solid text as fill.
                )),
              ),
            )));

    const double timeBoxSize = 100.0;

    Widget _timeContainer = Positioned(
        bottom: 5,
        child: Align(
            alignment: Alignment.center,
            child: Transform.translate(
              offset: Offset(0, 0),
              child: Container(
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.all(Radius.circular(_radius)),
                ),
                padding: new EdgeInsets.all(1),
                width: timeBoxSize,
                child: Center(
                    child: Container(
                  decoration: new BoxDecoration(
                    borderRadius:
                        new BorderRadius.all(Radius.circular(_radius)),
                  ),
                  width: timeBoxSize,
                  child: Center(
                    child: // Stroked text as border.
                        Text(
                      logOBJ.time,
                      style:
                          TextStyle(fontSize: 11, color: GlobalTheme.textColor),
                    ),
                  ),
                  // Solid text as fill.
                )),
              ),
            )));

    const double leftBoxSize = 100.0;
    double rightBoxSize = 300.00;
    if (this._systemSize != null) {
      rightBoxSize = this._systemSize!.width - leftBoxSize - 28;
    }

    const double minBoxHeight = 60.0;

    return Container(
        margin: new EdgeInsets.fromLTRB(5, 0, 5, 5),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.all(Radius.circular(_radius)),
          color: GlobalTheme.tabsColorPrimary,
        ),
        child: new GestureDetector(
            onDoubleTap: () {
              this.showDetails(logOBJ, context);
            },
            child: Row(
              children: [
                Container(
                  width: leftBoxSize,
                  height: minBoxHeight,
                  margin: new EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child:
                      Stack(alignment: AlignmentDirectional.center, children: [
                    _typeContainer,
                    _timeContainer,
                  ]),
                ),
                Container(
                  width: rightBoxSize,
                  height: minBoxHeight,
                  margin: new EdgeInsets.fromLTRB(8, 2, 2, 8),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      logOBJ.shortError,
                      style:
                          TextStyle(fontSize: 11, color: GlobalTheme.textColor),
                    ),
                  ),
                )
              ],
            )));
  }

  List<Widget> getLogsTabs(BuildContext context) {
    List<Widget> list = [];
    if (this._currLogs == null || this._currLogs?.length == 0) {
      list.add(this.getWidgetNoLogs());
    } else {
      this._currLogs?.forEach((element) {
        list.add(this.getWidgetLogs(element, context));
      });
    }

    return list;
  }

  showDetails(LogElement logOBJ, BuildContext context) async {
    StateSetter _setState;
    double _radius = 2;
    double _timeBoxSize = 120;
    Widget _timeContainer = Align(
        alignment: Alignment.center,
        child: Transform.translate(
          offset: Offset(0, 0),
          child: Container(
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.all(Radius.circular(_radius)),
            ),
            padding: new EdgeInsets.all(1),
            width: _timeBoxSize,
            child: Center(
                child: Container(
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.all(Radius.circular(_radius)),
              ),
              width: _timeBoxSize,
              child: Center(
                child: // Stroked text as border.
                    Text(
                  logOBJ.time,
                  style: TextStyle(fontSize: 11, color: GlobalTheme.textColor),
                ),
              ),
              // Solid text as fill.
            )),
          ),
        ));
    Color _typeBoxBorderColour = Colors.green;
    if (logOBJ.type == logLevelError) {
      _typeBoxBorderColour = Colors.red;
    }

    Widget _typeContainer = Align(
        alignment: Alignment.center,
        child: Transform.translate(
          offset: Offset(0, 0),
          child: Container(
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.all(Radius.circular(_radius)),
              color: _typeBoxBorderColour,
            ),
            padding: new EdgeInsets.all(1),
            width: 65,
            child: Center(
                child: Container(
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.all(Radius.circular(_radius)),
                color: GlobalTheme.tabsDayBackground,
              ),
              width: 65,
              child: Center(
                child: // Stroked text as border.
                    Text(
                  logOBJ.type,
                  style: TextStyle(fontSize: 11, color: GlobalTheme.textColor),
                ),
              ),
              // Solid text as fill.
            )),
          ),
        ));

    Widget _scrollContainer =
        ListView(padding: EdgeInsets.fromLTRB(2, 5, 2, 5), children: [
      Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _typeContainer,
            _timeContainer,
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: SelectableText(logOBJ.longError,
            style: new TextStyle(fontSize: 14, color: GlobalTheme.textColor),
            textAlign: TextAlign.left),
      ),
      Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Text("Stack trace:",
            style: new TextStyle(fontSize: 14, color: GlobalTheme.textColor),
            textAlign: TextAlign.left),
      ),
      Container(
        child: SelectableText(logOBJ.stack,
            style: new TextStyle(fontSize: 11, color: GlobalTheme.textColor),
            textAlign: TextAlign.left),
      ),
    ]);
    await showDialog(
        context: context,
        builder: (context) {
          return (new AlertDialog(
              backgroundColor: GlobalTheme.background.withAlpha(200),
              shadowColor: GlobalTheme.background.withAlpha(200),
              insetPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                _setState = setState;
                return Container(
                  width: this._systemSize!.width - 20,
                  height: this._systemSize!.height - 20,
                  padding: EdgeInsets.all(1),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(Radius.circular(20)),
                    color: GlobalTheme.background,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: this._systemSize!.width - 30,
                        height: this._systemSize!.height - 130,
                        child: _scrollContainer,
                      ),
                      Container(
                        width: this._systemSize!.width - 30,
                        child: TextButton(
                          style: Decors.basicButtonStyle,
                          child: new Text(
                            "CLOSE",
                            style: GlobalTheme.textStyle,
                          ),
                          onPressed: () => Navigator.pop(context, true),
                        ),
                      )
                    ],
                  ),
                );
              })));
        });
  }

  @override
  Widget build(BuildContext context) {
    this._systemSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: GlobalTheme.background,
        appBar: AppBar(
          backgroundColor: GlobalTheme.navAccent,
          iconTheme: GlobalTheme.iconTheme,
          titleTextStyle: TextStyle(fontSize: 20, color: GlobalTheme.textColor),
          title: const Text(
            "Logs",
          ),
          leading: IconButton(
            iconSize: 30,
            padding: const EdgeInsets.all(0),
            onPressed: () async {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back),
            color: GlobalTheme.textColor,
          ),
          actions: <Widget>[
            IconButton(
              iconSize: 30,
              color: GlobalTheme.textColor,
              padding: const EdgeInsets.all(0),
              onPressed: () async {
                saveLogs.delete();
                logData();
              },
              icon: Icon(Icons.delete),
            ),
            IconButton(
              iconSize: 30,
              color: GlobalTheme.textColor,
              padding: const EdgeInsets.all(0),
              onPressed: () async {
                logData();
              },
              icon: Icon(Icons.all_inclusive),
            ),
          ],
        ),
        body: ListView(
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          children: this.getLogsTabs(context),
        ));
  }

  void dispose() {
    super.dispose();
  }
}
