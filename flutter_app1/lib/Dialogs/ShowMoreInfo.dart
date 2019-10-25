import 'package:WP_news_APP/Globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import '../Class/WebsideInfo.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Class/PageComments.dart';
import 'DialogsPage.dart';

class ShowMoreInfo extends StatefulWidget {
  ShowMoreInfo({Key key}) : super(key: key);

  @override
  _ShowMoreInfo createState() => _ShowMoreInfo();
}

class _ShowMoreInfo extends State<ShowMoreInfo>
    with SingleTickerProviderStateMixin {
  WebsideInfo WebInfo;
  bool _init = true;

  double _width = 100.0, _height = 100.0;
  List<PageComments> _CommentList = new List<PageComments>();
  String commentsCaunter = "...";
  bool _isSaved = false;
  String _saveText = "Save";
  IconData _saveREmoveIcon = Icons.save;

  @override
  void initState() {
    super.initState();
  }

  _getMoreInfo(WebsideInfo web) async {
    try {
      String url =
          "https://" + web.DOMAIN + "/wp-json/wp/v2/comments?post=" + web.ID;
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> retJson = json.decode(response.body);
        setState(() {
          commentsCaunter = retJson.length.toString();
        });
        _CommentList = new List<PageComments>();
        for (dynamic items in retJson) {
          String author;
          String Avatar;
          String Content;
          String Id;
          String Parent;
          try {
            author = items["author_name"].toString();
          } catch (ex) {
            author = "N/A";
            assert(ex);
          }
          try {
            Id = items["id"].toString();
          } catch (ex) {
            Id = "";
            assert(ex);
          }
          try {
            Parent = items["parent"].toString();
          } catch (ex) {
            Parent = "";
            assert(ex);
          }
          try {
            Avatar = items["author_avatar_urls"]["96"].toString();
          } catch (ex) {
            Avatar = "N/A";
            assert(ex);
          }
          try {
            Content = items["content"]["rendered"].toString();
          } catch (ex) {
            Content = "N/A";
            assert(ex);
          }
          _CommentList.add(PageComments(
              AUTHOR: author,
              AVATARIMG: Avatar,
              POST: Content,
              ID: Id,
              PARENT: Parent));
        }
      }
    } catch (ex) {
      setState(() {
        commentsCaunter = "N/A";
      });
    }
  }

  Widget RenderTab(String Tab) {
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

  Widget RenderCommentPage(PageComments comment, double margin) {
    double _width_comment = _width - 10;
    double _width_Avatar = 60;
    if (_width > 600) {
      _width_comment *= 0.9;
      _width_Avatar = 100;
    }

    dynamic ret = Icon(
      FontAwesomeIcons.chevronRight,
      size: 14,
    );

    if (margin == 0) {
      ret = Container();
    }

    return (Container(
      width: _width_comment,
      padding: EdgeInsets.all(10),
      color: Color.fromARGB(255, 30, 30, 30),
      child: Row(
        children: <Widget>[
          Container(
            width: margin,
            child: ret,
          ),
          Container(
            margin: EdgeInsets.only(right: 10),
            width: _width_Avatar,
            child: Column(children: <Widget>[
              Center(
                child: Container(
                  child: Image.network(
                    comment.AVATARIMG,
                    fit: BoxFit.cover,
                    width: _width_Avatar * 0.4,
                    height: _width_Avatar * 0.4,
                  ),
                ),
              ),
              Container(
                child: SelectableText(
                  comment.AUTHOR,
                  textAlign: TextAlign.center,
                ),
              )
            ]),
          ),
          Container(
            child: Flexible(
              child: Text(comment.POST),
            ),
          )
        ],
      ),
    ));
  }

  Widget _Top(WebsideInfo p_webInfo, BuildContext context) {
    if (_width < 600) {
      return (Column(
        children: <Widget>[
          Center(
            child: Container(
              child: new ClipRRect(
                borderRadius: new BorderRadius.circular(8.0),
                child: Hero(
                  tag: p_webInfo.URL,
                  child: Image.network(
                    p_webInfo.IMAGEHREF,
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
              p_webInfo.TITTLE,
              style: TextStyle(fontSize: 20),
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
              p_webInfo.TITTLE,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
              ),
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
                  tag: p_webInfo.URL,
                  child: Image.network(
                    p_webInfo.IMAGEHREF,
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

  List<Widget> GetNextComment(String parent, double margin) {
    List<Widget> ListRendered = new List<Widget>();
    if (parent == null || parent == "0") {
      ListRendered.add(Container(
        height: 10,
      ));
      return ListRendered;
    }

    _CommentList.forEach((Act) {
      if (Act.PARENT == parent) {
        ListRendered.add(RenderCommentPage(Act, margin));
        ListRendered += GetNextComment(Act.ID, margin + 20);
      }
    });

    if (ListRendered.length == 0) {
      ListRendered.add(Container(
        height: 10,
      ));
    }
    return ListRendered;
  }

  List<Widget> RenderComentsUi() {
    List<Widget> ListRendered = new List<Widget>();
    _CommentList.forEach((Act) {
      if (Act.PARENT == "" || Act.PARENT == "0") {
        ListRendered.add(RenderCommentPage(Act, 0.0));
        ListRendered += GetNextComment(Act.ID, 20);
      }
    });

    if (ListRendered.length == 0) {
      ListRendered.add(Container());
    }

    return ListRendered;
  }

  Widget ShowMoreInfo_Fun(WebsideInfo p_webInfo, BuildContext context) {
    String _TabComments = "";
    if (_CommentList.length > 0) {
      _TabComments = "Coments";
    }
    return Container(
        width: _width,
        margin: new EdgeInsets.all(0),
        child: ListView(children: <Widget>[
          _Top(p_webInfo, context),
          Container(
            margin: new EdgeInsets.only(bottom: 10, top: 5, left: 5, right: 5),
            child: Text(
              p_webInfo.DESCRIPTION + " ...",
              style: TextStyle(fontSize: 14),
            ),
          ),
          Align(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  commentsCaunter,
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  width: 10,
                ),
                Icon(
                  Icons.forum,
                  color: p_webInfo.getColor(),
                  size: 30.0,
                  semanticLabel: 'Comments in post',
                ),
                Container(
                  width: 10,
                ),
              ],
            ),
          ),
          RenderTab(_TabComments),
          Column(
            children: RenderComentsUi(),
            //   _CommentList.map((item) => RenderCommentPage(item)).toList(),
          )
        ]));
  }

  cheeckThisPageIsSaved() {
    if (savedFileContainsThisWebside(WebInfo) >= 0) {
      setState(() {
        _isSaved = true;
        _saveText = "Remove";
        _saveREmoveIcon = Icons.delete;
      });
    } else {
      setState(() {
        _isSaved = false;
        _saveText = "Save";
        _saveREmoveIcon = Icons.save;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    WebInfo = ModalRoute.of(context).settings.arguments;
    if (_init) {
      _getMoreInfo(WebInfo);
      _init = false;
    }

    void pressButton(int press) async {
      if (press == 0) {
        Navigator.pop(context, true);
      } else if (press == 1) {
        bool ret = await DialogSaveRemoveWebside(_isSaved, context, WebInfo);
        if (ret) {
          cheeckThisPageIsSaved();
        }
      } else {
        launchURL(WebInfo.URL);
      }
    }

    cheeckThisPageIsSaved();

    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.arrow_left, color: Colors.greenAccent),
              title: new Text('Back'),
            ),
            BottomNavigationBarItem(
              icon: Icon(_saveREmoveIcon, color: Colors.deepPurple),
              title: new Text(_saveText),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pages, color: Colors.blueAccent),
              title: new Text('See more'),
            ),
          ],
          onTap: (press) => pressButton(press),
        ),
        backgroundColor: Colors.black,
        body: ShowMoreInfo_Fun(WebInfo, context));
  }
}
