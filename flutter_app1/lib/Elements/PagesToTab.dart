import 'package:flutter/cupertino.dart';

import '../main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';

import '../Globals.dart';
import '../Class/WebsideInfo.dart';
import '../Dialogs/YesNoAlert.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../Dialogs/ShowMoreInfo.dart';
import '../main.dart';

class PagesToTab extends StatefulWidget {
  WebsideInfo p_webInfo;
  BuildContext context;

  PagesToTab(WebsideInfo p_webInfo, BuildContext context) {
    this.p_webInfo = p_webInfo;
    this.context = context;
  }

  @override
  _PagesToTab createState() => _PagesToTab();
}

class _PagesToTab extends State<PagesToTab>
    with SingleTickerProviderStateMixin {
  AnimationController animationControl;

  double _width ;
  double rowWidth ;
  double rowheight = 100;

  @override
  void initState() {
    super.initState();
    animationControl = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
  }



  Widget GetPageDescrWidget() {

    if (rowWidth < 500) {
      return (Align(
        alignment: Alignment.center,
        child: Text(
          widget.p_webInfo.TITTLE,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ));
    } else {
      String description = widget.p_webInfo.DESCRIPTION;
      if (widget.p_webInfo.DESCRIPTION.length * 12 * 12 > (rowWidth / 2) * 90) {
        description =
            description.substring(0, (((rowWidth / 2) * 90 / 12) / 12).toInt());
        description = description.substring(0, description.lastIndexOf(" "));
        description += " ... ";
      }
      return (Align(
          alignment: Alignment.center,
          child: Row(
            children: <Widget>[
              Container(
                width: rowWidth / 2 - 6,
                child: Text(
                  widget.p_webInfo.TITTLE,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              Container(
                width: 1,
                margin: EdgeInsets.only(right: 4, left: 4),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: rowheight * 0.8,
                    color: widget.p_webInfo.getColor(),
                  ),
                ),
              ),
              Container(
                width: rowWidth / 2 - 6,
                child: Text(
                  description,
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
              )
            ],
          )));
    }
  }

  @override
  Widget buildSavedContainer(isSaved) {
    Widget retVal = Center();
    if (isSaved) {
      retVal = Center(
          child: Container(
              width: 1.5,
              height: 1.5,
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Transform.translate(
                      offset: Offset(-33, -90),
                      child: Transform.scale(
                          scale: 18,
                          child: Container(
                            decoration: new BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment(0.5, 0.5),
                                  // 10% of the width, so there are ten blinds.
                                  colors: [
                                    const Color(0xFFAAAAFF),
                                    const Color(0xFF7070FF)
                                  ],
                                  // whitish to gray
                                  tileMode: TileMode
                                      .clamp, // repeats the gradient over the canvas
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Icon(
                              Icons.file_download,
                              color: Colors.black,
                              size: 1,
                            ),
                          ))))));
    }
    return retVal;
  }

  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    rowWidth= _width - 100 - 20;

    animationControl.forward();
    String orderFunct = "Save for later ?";
    Color yesColor = Colors.greenAccent;
    bool isSaved = false;
    double moveleft = 0;

    if (savedFileContainsThisWebside(widget.p_webInfo) >= 0) {
      isSaved = true;
    }
    var now = new DateTime.now();
    var postData =
        DateTime.parse(widget.p_webInfo.DATE.substring(0, 10).toString());

    var m_timeVal = widget.p_webInfo.DATE.substring(0, 10);
    if (now.year == postData.year &&
        now.month == postData.month &&
        now.day == postData.day) {
      m_timeVal = "TODAY";
    }

    //   ShowMoreInfo(p_webInfo,context);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0, 50), end: Offset.zero).animate(
          CurvedAnimation(parent: animationControl, curve: Curves.easeIn)),
      child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child:
//PAGE
              Container(
                  margin: new EdgeInsets.only(bottom: 10),
                  child: new GestureDetector(
                    onTap: () {
                      launchURL(widget.p_webInfo.URL);
                    },
                    onLongPressStart: (pessDetails) {},
                    onLongPressEnd: (pressDetails) {},
                    onLongPress: () async {
                      if (isSaved) {
                        orderFunct = "Delete from saved ?";
                        yesColor = Colors.redAccent;
                      }
                      bool shouldUpdate = await ShowDialog(
                          orderFunct,
                          yesColor,
                          context,
                          Icon(
                            Icons.file_download,
                            color: Colors.blue,
                            size: 36.0,
                          ));
                      if (shouldUpdate) {
                        int find =
                            savedFileContainsThisWebside(widget.p_webInfo);
                        if (find < 0) {
                          Global_savedWebside.add(widget.p_webInfo);
                        } else {
                          Global_savedWebside.removeAt(find);
                        }
                        Global_RefreshPage = true;
                        //buildersss(isOpendeSavedList);
                        save_WebsideArch(Global_savedWebside);
                      }
                    },
                    child: Container(
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.all(Radius.circular(10)),
                        color: Color.fromARGB(255, 50, 50, 50),
                      ),
                      child: Container(
                        margin: new EdgeInsets.all(5),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //fires when was imf
                                    Container(
                                      width: 80,
                                      child: Column(children: [
                                        Container(
                                          margin: new EdgeInsets.all(5),
                                          child: new ClipRRect(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      8.0),
                                              child: Hero(
                                                tag: widget.p_webInfo.HREF,
                                                child: Image.network(
                                                  widget.p_webInfo.HREF,
                                                  fit: BoxFit.cover,
                                                  width: 75,
                                                  height: 75,
                                                ),
                                              )),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            decoration: new BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      Radius.circular(10)),
                                              color:
                                                  widget.p_webInfo.getColor(),
                                            ),
                                            padding: new EdgeInsets.all(1),
                                            width: 60,
                                            child: Center(
                                                child: Container(
                                              decoration: new BoxDecoration(
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        Radius.circular(10)),
                                                color: Colors.black,
                                              ),
                                              width: 60,
                                              child: Center(
                                                child: // Stroked text as border.
                                                    Text(
                                                  m_timeVal,
                                                  style: TextStyle(
                                                    fontSize: 9,
                                                  ),
                                                ),
                                              ),
                                              // Solid text as fill.
                                            )),
                                          ),
                                        ),
                                        buildSavedContainer(isSaved),
                                      ]),
                                    ),
                                    //sec when was text
                                    Container(
                                        width: rowWidth,
                                        height: rowheight,
                                        child: GetPageDescrWidget()),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    ),
                  )),
          actions: <Widget>[
            IconSlideAction(
                caption: 'Read more',
                color: widget.p_webInfo.getColor(),
                icon: Icons.more_horiz,
                onTap: () => Navigator.of(context)
                    .pushNamed('/moreInfo', arguments: widget.p_webInfo)),
          ]),
    );
  }
}
