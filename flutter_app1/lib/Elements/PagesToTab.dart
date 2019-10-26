import 'package:WP_news_APP/Globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../Class/WebsideInfo.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../Dialogs/DialogsPage.dart';

class PagesToTab extends StatefulWidget {
  WebsideInfo p_webInfo;
  BuildContext context;

  PagesToTab(WebsideInfo webInfo, BuildContext context) {
    this.p_webInfo = webInfo;
    this.context = context;
  }

  @override
  _PagesToTab createState() => _PagesToTab();
}

class _PagesToTab extends State<PagesToTab>
    with SingleTickerProviderStateMixin {
  AnimationController animationControl;

  double _width;
  double _rowWidth;
  double _rowheight = 100;

  @override
  void initState() {
    super.initState();
    animationControl = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
  }

  Widget getPageDescWidget() {
    if (_rowWidth < 500) {
      return (Align(
        alignment: Alignment.center,
        child: Text(
          widget.p_webInfo.TITTLE,
          style: TextStyle(color: GlobalTheme.textColor, fontSize: 16),
        ),
      ));
    } else {
      String description = widget.p_webInfo.DESCRIPTION;
      if (widget.p_webInfo.DESCRIPTION.length * 12 * 12 > (_rowWidth / 2) * 90) {
        description =
            description.substring(0, (((_rowWidth / 2) * 90 / 12) / 12).toInt());
        description = description.substring(0, description.lastIndexOf(" "));
        description += " ... ";
      }
      return (Align(
          alignment: Alignment.center,
          child: Row(
            children: <Widget>[
              Container(
                width: _rowWidth / 2 - 6,
                child: Text(
                  widget.p_webInfo.TITTLE,
                  style: TextStyle( color: GlobalTheme.textColor , fontSize: 16),
                ),
              ),
              Container(
                width: 1,
                margin: EdgeInsets.only(right: 4, left: 4),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: _rowheight * 0.8,
                    color: widget.p_webInfo.getColor(),
                  ),
                ),
              ),
              Container(
                width: _rowWidth / 2 - 6,
                child: Text(
                  description,
                  style: TextStyle(color: GlobalTheme.textColor2, fontSize: 14),
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
    _rowWidth = _width - 100 - 20;
    animationControl.forward();
    bool isSaved = false;
      if (savedFileContainsThisWebside(widget.p_webInfo) >= 0) {
      isSaved = true;
    }
    var now = new DateTime.now();
    var postData =
        DateTime.parse(widget.p_webInfo.DATE.substring(0, 10).toString());

    var timeVal = widget.p_webInfo.DATE.substring(0, 10);
    if (now.year == postData.year &&
        now.month == postData.month &&
        now.day == postData.day) {
      timeVal = "TODAY";
    }
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
                      widget.p_webInfo.launchURL();
                    },
                    onLongPressStart: (pessDetails) {},
                    onLongPressEnd: (pressDetails) {},
                    onLongPress: () async {
                      await DialogsPage_saveRemoveWebside(
                          isSaved, context, widget.p_webInfo);
                    },
                    child: Container(
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.all(Radius.circular(10)),
                        color: GlobalTheme.tabsColorPrimary
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
                                                tag: widget.p_webInfo.URL,
                                                child: Image.network(
                                                  widget.p_webInfo.IMAGEHREF,
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
                                                color: GlobalTheme.tabsDayBackground,
                                              ),
                                              width: 60,
                                              child: Center(
                                                child: // Stroked text as border.
                                                    Text(
                                                  timeVal,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: GlobalTheme.textColor
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
                                        width: _rowWidth,
                                        height: _rowheight,
                                        child: getPageDescWidget()),
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
