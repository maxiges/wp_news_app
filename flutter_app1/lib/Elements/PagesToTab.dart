import 'package:WP_news_APP/Globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../Class/WebsiteInfo.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../Dialogs/DialogsPage.dart';

class PagesToTab extends StatefulWidget {
  late WebsiteInfo pageInfo;
  late BuildContext context;

  PagesToTab(WebsiteInfo webInfo, BuildContext context) {
    this.pageInfo = webInfo;
    this.context = context;
  }

  @override
  _PagesToTab createState() => _PagesToTab();
}

class _PagesToTab extends State<PagesToTab>
    with SingleTickerProviderStateMixin {
  late AnimationController animationControl;

  late double _width;
  late double _rowWidth;
  double _rowheight = 90;

  @override
  void initState() {
    super.initState();
    animationControl = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
  }
  @override
  void dispose() {
    animationControl.stop();
    animationControl.dispose();
    super.dispose();
  }


  // main screen
  Widget getPageDescWidget(bool showAllDescription) {

    // small screen - phone
    if (!isLargeWideScreen()) {
      return (Align(
        alignment: Alignment.center,
        child: Text(
          widget.pageInfo.tittle,
          style: TextStyle(color: GlobalTheme.textColor, fontSize: 16),
        ),
      ));
    }


    // large wide screen - tablet
      String description = widget.pageInfo.descriptionBrief;
      if (!showAllDescription) {
        if (widget.pageInfo.descriptionBrief.length * 14 * 14 >
            (_rowWidth / 2) * _rowheight) {
          description =
              description.substring(0, ((_rowWidth / 2) * _rowheight / 14) ~/ 14);
          description = description.substring(0, description.lastIndexOf(" "));
          description += " ... ";
        }
      }

      return (Align(
          alignment: Alignment.center,
          child: Row(
            children: <Widget>[
              Container(
                width: (_rowWidth / 2) - 50,
                child: Text(
                  widget.pageInfo.tittle,
                  style: TextStyle(color: GlobalTheme.textColor, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: 2,
                margin: EdgeInsets.only(right: 10, left: 4),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: _rowheight * 0.8,
                    color: widget.pageInfo.getColor(),
                  ),
                ),
              ),
              Container(
                width: (_rowWidth / 2) + 30,
                child: Text(
                  description,
                  style: TextStyle(color: GlobalTheme.textColor2, fontSize: 14),
                ),
              )
            ],
          )));

  }

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
                      offset: Offset(30, -35),
                      child: Transform.scale(
                          scale: 18,
                          child: Container(
                            decoration: new BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment(0.5, 0.5),
                                  // 10% of the width, so there are ten blinds.
                                  colors: [
                                    const Color(0xFF69F0AE),
                                    const Color(0xFF24AF6E)
                                  ],
                                  // whitish to gray
                                  tileMode: TileMode
                                      .clamp, // repeats the gradient over the canvas
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0.2))),
                            child: Icon(
                              Icons.file_download,
                              color: Colors.black54,
                              size: 1,
                            ),
                          ))))));
    }
    return retVal;
  }

  void openMoreDetails() {
    Navigator.of(context).pushNamed('/moreInfo', arguments: widget.pageInfo);
  }

  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _rowWidth = _width - 100 - 20;
    animationControl.forward();
    bool isSaved = false;
    if (savedFileContainsThisWeb(widget.pageInfo) >= 0) {
      isSaved = true;
    }
    var now = new DateTime.now();
    var postData =
        DateTime.parse(widget.pageInfo.articleDate.substring(0, 10).toString());

    var timeVal = widget.pageInfo.articleDate.substring(0, 10);
    if (now.year == postData.year &&
        now.month == postData.month &&
        now.day == postData.day) {
      timeVal = "TODAY";
    }

    const radius = 5.0;

    Widget _imageContainer = Container(
      margin: new EdgeInsets.all(5),
      child: new ClipRRect(
          borderRadius: new BorderRadius.circular(radius),
          child: Hero(
            tag: widget.pageInfo.url,
            child: Image.network(
              widget.pageInfo.thumbnailUrlLink,
              fit: BoxFit.cover,
              width: 75,
              height: 75,
            ),
          )),
    );
    Widget _timeContainer = Positioned(
        top: 75,
        right: 7,
        child: Align(
            alignment: Alignment.center,
            child: Transform.translate(
              offset: Offset(0, 0),
              child: Container(
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.all(Radius.circular(radius)),
                  color: widget.pageInfo.getColor(),
                ),
                padding: new EdgeInsets.all(1),
                width: 65,
                child: Center(
                    child: Container(
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(Radius.circular(radius)),
                    color: GlobalTheme.tabsDayBackground,
                  ),
                  width: 65,
                  child: Center(
                    child: // Stroked text as border.
                        Text(
                      timeVal,
                      style:
                          TextStyle(fontSize: 11, color: GlobalTheme.textColor),
                    ),
                  ),
                  // Solid text as fill.
                )),
              ),
            )));

    return SlideTransition(
        position: Tween<Offset>(begin: Offset(0, 50), end: Offset.zero).animate(
            CurvedAnimation(parent: animationControl, curve: Curves.easeIn)),
        child: Slidable(
          key: const ValueKey(0),
          child:
//PAGE
              Container(
                  margin: new EdgeInsets.only(bottom: 4),
                  child: new GestureDetector(
                    onDoubleTap: () {
                      widget.pageInfo.launchURL();
                    },
                    onTap: () {
                      openMoreDetails();
                    },
                    onLongPressStart: (pessDetails) {},
                    onLongPressEnd: (pressDetails) {},
                    onLongPress: () async {
                      await dialogsPageSaveRemoveWebsite(
                          isSaved, context, widget.pageInfo);
                    },
                    child: Container(
                      decoration: new BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(Radius.circular(radius)),
                          color: GlobalTheme.tabsColorPrimary),
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
                                      height: _rowheight+5,
                                      margin:
                                          new EdgeInsets.fromLTRB(0, 2, 0, 2),
                                      child: Stack(
                                          alignment:
                                              AlignmentDirectional.center,
                                          children: [
                                            _imageContainer,
                                            _timeContainer,
                                            buildSavedContainer(isSaved),
                                          ]),
                                    ),
                                    Container(
                                        width: _rowWidth,
                                        height: _rowheight,
                                        child: getPageDescWidget(false)),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    ),
                  )),
          startActionPane: ActionPane(
            // A motion is a widget used to control how the pane animates.
            motion: const ScrollMotion(),
            // A pane can dismiss the Slidable.
            children: [
              SlidableAction(
                  label: 'Read more',
                  foregroundColor: widget.pageInfo.getColor(),
                  backgroundColor: Colors.transparent,
                  icon: Icons.more_horiz,
                  onPressed: (BuildContext context) => openMoreDetails()),
            ],
          ),
        ));
  }
}
