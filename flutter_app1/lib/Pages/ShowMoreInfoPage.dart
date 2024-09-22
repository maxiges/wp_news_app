import 'package:WP_news_APP/Class/Time.dart';
import 'package:WP_news_APP/Decors/decors.dart';
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
  ShowMoreInfo({Key? key}) : super(key: key);

  @override
  _ShowMoreInfo createState() => _ShowMoreInfo();
}

class _ShowMoreInfo extends State<ShowMoreInfo>
    with SingleTickerProviderStateMixin {
  late WebsiteInfo articleInfo;
  bool _init = true;

  double _width = 100.0, _height = 100.0;
  List<PageComments> _commentList = [];
  String commentsCounter = "...";
  bool _isSaved = false;
  String _saveText = "Save";
  IconData _saveRemoveIcon = Icons.save;

  bool _readMore = false;
  Text _pageText = new Text("Error");

  Widget _pageComponentFullPage = new Text("No images");

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
        articleInfo = ret;
      });

      if (articleInfo.articleDetails != null &&
          articleInfo.articleDetails!.fullArticle.length >
              articleInfo.descriptionBrief.length) {
        setState(() {
          _readMore = true;
        });
      } else {
        setState(() {
          _readMore = false;
        });
      }
    } catch (ex) {
      saveLogs.error(ex.toString());
      setState(() {
        _readMore = false;
      });
    }
  }

  Widget renderInfoTab(String tab) {
    if (tab == "") {
      return (Container());
    } else {
      return (Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 10),
        color: articleInfo.getColor(),
        width: _width,
        child: Text(
          tab,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: articleInfo.getColorText()),
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
                    comment.avatarImg,
                    fit: BoxFit.cover,
                    width: _widthAvatar * 0.4,
                    height: _widthAvatar * 0.4,
                  ),
                ),
              ),
              Container(
                child: SelectableText(
                  comment.author,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: GlobalTheme.textColor),
                ),
              )
            ]),
          ),
          Container(
            child: Flexible(
              child: SelectableText(
                comment.postData,
                style: TextStyle(color: GlobalTheme.textColor),
              ),
            ),
          )
        ],
      ),
    ));
  }

  Widget _top(WebsiteInfo webInfo, BuildContext context) {
    if (_width < 600) {
      return _topSmallScreen(webInfo, context);
    } else {
      return _topBigScreen(webInfo, context);
    }
  }

  Widget _topSmallScreen(WebsiteInfo webInfo, BuildContext context) {
    return (Column(
      children: <Widget>[
        Center(
          child: Container(
            child: new ClipRRect(
              borderRadius: new BorderRadius.circular(8.0),
              child: Hero(
                tag: webInfo.url,
                child: Image.network(
                  webInfo.thumbnailUrlLink,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                ),
              ),
            ),
          ),
        ),
        Container(
            child: Align(
                alignment: Alignment.bottomRight,
                child: Transform.translate(
                    offset: Offset(-0, -25),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      decoration: new BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(Radius.circular(4)),
                          border: Border.all(color: webInfo.getColor()),
                          color: GlobalTheme.navAccent,
                          boxShadow: Decors.boxShadow),
                      child: Text(
                        Time.timeStringToLocalTimeString(webInfo.articleDate),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 11, color: GlobalTheme.textColor),
                      ),
                    )))),
        Container(
          margin: new EdgeInsets.only(bottom: 10, top: 5, left: 5, right: 5),
          child: Text(
            webInfo.tittle,
            style: TextStyle(fontSize: 20, color: GlobalTheme.textColor),
          ),
        ),
      ],
    ));
  }

  Widget _topBigScreen(WebsiteInfo webInfo, BuildContext context) {
    return Column(children: [
      Row(
        children: <Widget>[
          Container(
            width: _width - 240,
            margin: new EdgeInsets.only(bottom: 10, top: 5, left: 5, right: 5),
            child: Text(
              webInfo.tittle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, color: GlobalTheme.textColor),
            ),
          ),
          Container(
            width: 200,
            margin: new EdgeInsets.only(bottom: 10, top: 5, left: 5, right: 5),
            child: new ClipRRect(
              borderRadius: new BorderRadius.circular(8.0),
              child: Hero(
                tag: webInfo.url,
                child: Image.network(
                  webInfo.thumbnailUrlLink,
                  fit: BoxFit.cover,
                  width: 200,
                  height: 200,
                ),
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: Transform.translate(
                  offset: Offset(-120, 80),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                    decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.all(Radius.circular(4)),
                        border: Border.all(color: webInfo.getColor()),
                        color: GlobalTheme.navAccent,
                        boxShadow: Decors.boxShadow),
                    child: Text(
                      Time.timeStringToLocalTimeString(webInfo.articleDate),
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 11, color: GlobalTheme.textColor),
                    ),
                  ))),
        ],
      )
    ]);
  }

  List<Widget> getNextComment(String parent, double margin) {
    List<Widget> renderedList = [];
    if (parent == "0") {
      renderedList.add(Container(
        height: 10,
      ));
      return renderedList;
    }

    _commentList.forEach((act) {
      if (act.parent == parent) {
        renderedList.add(renderCommentPage(act, margin));
        renderedList += getNextComment(act.id, margin + 20);
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
      if (act.parent == "" || act.parent == "0") {
        renderedList.add(renderCommentPage(act, 0.0));
        renderedList += getNextComment(act.id, 20);
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
    if (articleInfo.articleDetails!.fullArticle == "N/A") {
      return Text(
        "No internet connection",
        style: TextStyle(fontSize: 11),
      );
    }
    if (articleInfo.articleDetails!.fullArticle == "") {
      return Text("Loading ...");
    }
    return Text("Hide ...");
  }

  void _onTapReadMoreFunc() {
    if (_readMore == true) {
      _pageComponentFullPage = Text("");
      if (articleInfo.imgsInArticle.length > 0) {
        List<Widget> widgets = [];
        articleInfo.imgsInArticle.forEach((imgURL) {
          widgets.add(Container(
            // To see the difference between the image's original size and the fram
            child: Image.network(imgURL, fit: BoxFit.fitWidth),
          ));
        });
        _pageComponentFullPage = Container(
          height: MediaQuery.of(context).size.height * 0.5 ,
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              shrinkWrap: true,
          children: widgets,
        ));
      }

      setState(() {
        _pageText = Text(
          articleInfo.articleDetails!.fullArticle,
          style: TextStyle(fontSize: 14, color: GlobalTheme.textColor),
        );
        _pageComponentFullPage = _pageComponentFullPage;
      });

      _readMore = false;
    } else {
      setState(() {
        _pageText = Text(
          articleInfo.descriptionBrief + " ...",
          style: TextStyle(fontSize: 14, color: GlobalTheme.textColor),
        );

        _pageComponentFullPage = Text("No images");
      });

      if (articleInfo.articleDetails!.fullArticle != "") {
        _readMore = true;
      }
    }
  }

  Widget showMoreInfoTable(WebsiteInfo webInfo, BuildContext context) {
    String _tabComments = "";
    if (_commentList.length > 0) {
      _tabComments = "Comments";
    }
    return Container(
        width: _width,
        margin: new EdgeInsets.all(0),
        child: ListView(
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            children: <Widget>[
              _top(webInfo, context),
              Container(
                margin:
                    new EdgeInsets.only(bottom: 10, top: 5, left: 5, right: 5),
                child: ListBody(
                  children: <Widget>[
                    Container(
                      child: _pageText,
                    ),
                    Container(
                      child: _pageComponentFullPage,
                    ),
                    Container(
                      margin: new EdgeInsets.only(
                          bottom: 20, top: 5, left: 5, right: 5),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: new EdgeInsets.only(
                      bottom: 10, top: 5, left: 70, right: 10),
                  alignment: Alignment.centerRight,
                  child: new GestureDetector(
                      onTap: () {
                        _onTapReadMoreFunc();
                      },
                      child: new Container(
                          width: 140.0,
                          height: 35.0,
                          decoration: new BoxDecoration(
                              color: webInfo.getColor(),
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(5)),
                              boxShadow: Decors.boxShadow),
                          padding: EdgeInsets.only(top: 8.0, right: 0),
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
                      style:
                          TextStyle(fontSize: 20, color: GlobalTheme.textColor),
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
    if (savedFileContainsThisWeb(articleInfo) >= 0) {
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
      articleInfo = ModalRoute.of(context)!.settings.arguments as WebsiteInfo;

      _onTapReadMoreFunc(); //loadWebInfoPage
      _getInfoAboutComments(articleInfo);
      _getMoreInfoAboutWebPage(articleInfo);
      _init = false;
    }

    void pressButton(int press) async {
      if (press == 0) {
        Navigator.pop(context, true);
      } else if (press == 1) {
        bool ret =
            await dialogsPageSaveRemoveWebsite(_isSaved, context, articleInfo);
        if (ret) {
          checkThisPageIsSaved();
        }
      } else {
        articleInfo.launchURL();
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
        body: showMoreInfoTable(articleInfo, context));
  }
}
