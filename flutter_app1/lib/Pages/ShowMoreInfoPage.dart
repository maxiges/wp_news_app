import 'package:WP_news_APP/Globals.dart';
import 'package:WP_news_APP/Utils/SaveLogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Class/WebsiteInfo.dart';
import '../Class/PageComments.dart';
import '../Dialogs/DialogsPage.dart';
import '../Utils/WebPageAPI.dart';

class ShowMoreInfo extends StatefulWidget {
  ShowMoreInfo({Key key}) : super(key: key);

  @override
  _ShowMoreInfo createState() => _ShowMoreInfo();
}

class _ShowMoreInfo extends State<ShowMoreInfo>
    with SingleTickerProviderStateMixin {
  WebsiteInfo WebInfo;
  bool _init = true;

  double _width = 100.0, _height = 100.0;
  List<PageComments> _commentList = [];
  String commentsCounter = "...";
  bool _isSaved = false;
  String _saveText = "Save";
  IconData _saveRemoveIcon = Icons.save;

  bool _readMore = false;
  Text _PageText = new Text("Error");

  @override
  void initState() {
    super.initState();
  }

  _getInfoAboutComments(WebsiteInfo web) async {
    try {
      _commentList = await webPageFetchAPI.getPageComments(web);
      setState(() {
        commentsCounter = _commentList.length.toString();
      });
    } catch (ex) {
      setState(() {
        commentsCounter = "N/A";
      });
    }
  }

  _getMoreInfoAboutWebPage(WebsiteInfo web) async {
    try {
      WebsiteInfo ret = await webPageFetchAPI.websiteInfoGetAllWebInfo(web);
      setState(() {
        WebInfo = ret;
      });

      if (WebInfo.WEB_DETAILS.WEB_ALL_PAGE.length >
          WebInfo.DESCRIPTION.length) {
        setState(() {
          _readMore = true;
        });
      } else {
        setState(() {
          _readMore = false;
        });
      }
    } catch (ex) {
      saveLogs.error(ex);
      setState(() {
        _readMore = false;
      });
    }
  }

  Widget renderInfoTab(String Tab) {
    if (Tab == "" || Tab == null) {
      return (Container());
    } else {
      return (Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 10),
        color: WebInfo.getColor(),
        width: _width,
        child: Text(
          Tab,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: WebInfo.getColorText()),
        ),
      ));
    }
  }

  Widget renderCommentPage(PageComments comment, double margin) {
    double _widthComment = _width - 10;
    double _widthAvatar = 60;
    if (_width > 600) {
      _widthComment *= 0.9;
      _widthAvatar = 100;
    }

    dynamic ret = Icon(FontAwesomeIcons.chevronRight,
        size: 14, color: GlobalTheme.textColor);

    if (margin == 0) {
      ret = Container();
    }

    return (Container(
      width: _widthComment,
      padding: EdgeInsets.all(10),
      color: GlobalTheme.tabsColorPrimary,
      child: Row(
        children: <Widget>[
          Container(
            width: margin,
            child: ret,
          ),
          Container(
            margin: EdgeInsets.only(right: 10),
            width: _widthAvatar,
            child: Column(children: <Widget>[
              Center(
                child: Container(
                  child: Image.network(
                    comment.AVATARIMG,
                    fit: BoxFit.cover,
                    width: _widthAvatar * 0.4,
                    height: _widthAvatar * 0.4,
                  ),
                ),
              ),
              Container(
                child: SelectableText(
                  comment.AUTHOR,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: GlobalTheme.textColor),
                ),
              )
            ]),
          ),
          Container(
            child: Flexible(
              child: SelectableText(
                comment.POST,
                style: TextStyle(color: GlobalTheme.textColor),
              ),
            ),
          )
        ],
      ),
    ));
  }

  Widget _Top(WebsiteInfo webInfo, BuildContext context) {
    if (_width < 600) {
      return (Column(
        children: <Widget>[
          Center(
            child: Container(
              child: new ClipRRect(
                borderRadius: new BorderRadius.circular(8.0),
                child: Hero(
                  tag: webInfo.URL,
                  child: Image.network(
                    webInfo.IMAGEHREF,
                    fit: BoxFit.cover,
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: new EdgeInsets.only(bottom: 10, top: 5, left: 5, right: 5),
            child: Text(
              webInfo.TITTLE,
              style: TextStyle(fontSize: 20, color: GlobalTheme.textColor),
            ),
          ),
        ],
      ));
    } else {
      return (Row(
        children: <Widget>[
          Container(
            width: _width - 250,
            margin: new EdgeInsets.only(bottom: 10, top: 5, left: 5, right: 5),
            child: Text(
              webInfo.TITTLE,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, color: GlobalTheme.textColor),
            ),
          ),
          Center(
            child: Container(
              width: 220,
              margin:
                  new EdgeInsets.only(bottom: 10, top: 5, left: 5, right: 5),
              child: new ClipRRect(
                borderRadius: new BorderRadius.circular(8.0),
                child: Hero(
                  tag: webInfo.URL,
                  child: Image.network(
                    webInfo.IMAGEHREF,
                    fit: BoxFit.cover,
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
            ),
          ),
        ],
      ));
    }
  }

  List<Widget> getNextComment(String parent, double margin) {
    List<Widget> renderedList = [];
    if (parent == null || parent == "0") {
      renderedList.add(Container(
        height: 10,
      ));
      return renderedList;
    }

    _commentList.forEach((act) {
      if (act.PARENT == parent) {
        renderedList.add(renderCommentPage(act, margin));
        renderedList += getNextComment(act.ID, margin + 20);
      }
    });

    if (renderedList.length == 0) {
      renderedList.add(Container(
        height: 10,
      ));
    }
    return renderedList;
  }

  List<Widget> renderCommentsUi() {
    List<Widget> renderedList = [];
    _commentList.forEach((act) {
      if (act.PARENT == "" || act.PARENT == "0") {
        renderedList.add(renderCommentPage(act, 0.0));
        renderedList += getNextComment(act.ID, 20);
      }
    });

    if (renderedList.length == 0) {
      renderedList.add(Container());
    }

    return renderedList;
  }

  Widget showMoreInfoChild() {
    if (_readMore) {
      return Text("Read More ...");
    }
    if (WebInfo.WEB_DETAILS.WEB_ALL_PAGE == "N/A") {
      return Text("No internet connection");
    }
    if (WebInfo.WEB_DETAILS.WEB_ALL_PAGE == "") {
      return Text("Loading ...");
    }
    return Text("Hide ...");
  }

  void _onTapReadMoreFunc() {
    if (_readMore == true) {
      setState(() {
        _PageText = Text(
          WebInfo.WEB_DETAILS.WEB_ALL_PAGE,
          style: TextStyle(fontSize: 14, color: GlobalTheme.textColor),
        );
      });

      _readMore = false;
    } else {
      setState(() {
        _PageText = Text(
          WebInfo.DESCRIPTION + " ...",
          style: TextStyle(fontSize: 14, color: GlobalTheme.textColor),
        );
      });

      if (WebInfo.WEB_DETAILS.WEB_ALL_PAGE != "") {
        _readMore = true;
      }
    }
  }

  Widget showMoreInfoTable(WebsiteInfo webInfo, BuildContext context) {
    String _tabComments = "";
    if (_commentList.length > 0) {
      _tabComments = "Coments";
    }
    return Container(
        width: _width,
        margin: new EdgeInsets.all(0),
        child: ListView(children: <Widget>[
          _Top(webInfo, context),
          Container(
            margin: new EdgeInsets.only(bottom: 10, top: 5, left: 5, right: 5),
            child: _PageText,
          ),
          Container(
              margin:
                  new EdgeInsets.only(bottom: 10, top: 5, left: 70, right: 0),
              alignment: Alignment.centerRight,
              child: new GestureDetector(
                  onTap: () {
                    _onTapReadMoreFunc();
                  },
                  child: new Container(
                      width: 140.0,
                      height: 25.0,
                      padding: EdgeInsets.only(
                        top: 5.0,
                        right: 30,
                      ),
                      color: webInfo.getColor(),
                      child: new Column(
                        children: [
                          showMoreInfoChild(),
                        ],
                      )))),
          Align(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  commentsCounter,
                  style: TextStyle(fontSize: 20, color: GlobalTheme.textColor),
                ),
                Container(
                  width: 10,
                ),
                Icon(
                  Icons.forum,
                  color: webInfo.getColor(),
                  size: 30.0,
                  semanticLabel: 'Comments in post',
                ),
                Container(
                  width: 10,
                ),
              ],
            ),
          ),
          renderInfoTab(_tabComments),
          Column(
            children: renderCommentsUi(),
            //   _CommentList.map((item) => RenderCommentPage(item)).toList(),
          )
        ]));
  }

  checkThisPageIsSaved() {
    if (savedFileContainsThisWeb(WebInfo) >= 0) {
      setState(() {
        _isSaved = true;
        _saveText = "Remove";
        _saveRemoveIcon = Icons.delete;
      });
    } else {
      setState(() {
        _isSaved = false;
        _saveText = "Save";
        _saveRemoveIcon = Icons.save;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    if (_init) {
      WebInfo = ModalRoute.of(context).settings.arguments;
      _onTapReadMoreFunc(); //loadWebInfoPage
      _getInfoAboutComments(WebInfo);
      _getMoreInfoAboutWebPage(WebInfo);
      _init = false;
    }

    void pressButton(int press) async {
      if (press == 0) {
        Navigator.pop(context, true);
      } else if (press == 1) {
        bool ret =
            await dialogsPageSaveRemoveWebsite(_isSaved, context, WebInfo);
        if (ret) {
          checkThisPageIsSaved();
        }
      } else {
        WebInfo.launchURL();
      }
    }

    checkThisPageIsSaved();

    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: GlobalTheme.navAccent,
          selectedLabelStyle: TextStyle(
            color: GlobalTheme.textColor,
          ),
          unselectedLabelStyle: TextStyle(
            color: GlobalTheme.textColor,
          ),
          unselectedItemColor: GlobalTheme.textColor,
          selectedItemColor: GlobalTheme.textColor,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.arrow_left, color: Colors.green),
                label: 'Back'),
            BottomNavigationBarItem(
              icon: Icon(_saveRemoveIcon, color: Colors.deepPurple),
              label: _saveText,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pages, color: Colors.blueAccent),
              label: "See more",
            )
          ],
          onTap: (press) => pressButton(press),
        ),
        backgroundColor: GlobalTheme.background,
        body: showMoreInfoTable(WebInfo, context));
  }
}
