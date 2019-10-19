import 'package:WP_news_APP/Globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import '../Class/WebsideInfo.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


class ShowMoreInfo extends StatefulWidget {
  ShowMoreInfo({Key key}) : super(key: key);

  @override
  _ShowMoreInfo createState() => _ShowMoreInfo();
}

class _ShowMoreInfo extends State<ShowMoreInfo>
    with SingleTickerProviderStateMixin {

   WebsideInfo WebInfo;
   bool _init = true;
  @override
  void initState() {
    super.initState();




  }

  String Comments = "...";
  _getMoreInfo(WebsideInfo web) async {
    try {
      final response =
      await http.get(
          "https://" + web.DOMAIN + "/wp-json/wp/v2/comments?post=" + web.ID);
      if (response.statusCode == 200) {
        List<dynamic> retJson = json.decode(response.body);

        setState(() {
          Comments = retJson.length.toString();
        });


        for (dynamic items in retJson) {
          try {

          }
          catch (ex) {}
        }
      }
    }
    catch(ex)
    {
      setState(() {
        Comments = "N/A";
      });
    }


  }



  Widget ShowMoreInfo_Fun(WebsideInfo p_webInfo, BuildContext context) {


    return Container(
        width: Global_width,
        margin: new EdgeInsets.all(0),
        child: ListView(children: <Widget>[
          Center(
            child: Container(
              margin: new EdgeInsets.all(5),
              child: new ClipRRect(
                borderRadius: new BorderRadius.circular(8.0),
                child: Hero(
                  tag: p_webInfo.HREF,
                  child: Image.network(
                    p_webInfo.HREF,
                    fit: BoxFit.cover,
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: new EdgeInsets.only(bottom: 10 , top: 5 , left: 5 , right: 5),
            child: Text(
              p_webInfo.TITTLE,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            margin: new EdgeInsets.only(bottom: 10 , top: 5 , left: 5 , right: 5),
            child: Text(
              p_webInfo.DESCRIPTION,
              style: TextStyle(fontSize: 14),
            ),
          ),

          Align(

         child: Row(
mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(Comments, style: TextStyle(fontSize: 20),),
              Container(width: 10,),
              Icon(
                Icons.forum,
                color: p_webInfo.getColor(),
                size: 30.0,
                semanticLabel: 'Comments in post',
              ),
Container(width: 10,),
            ],

          ),

          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: new EdgeInsets.only(top: 20, left: 5, right: 5),
                  child: FlatButton(
                    color: Colors.greenAccent,
                    child: new Text(
                      "Hide",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: new EdgeInsets.only(top: 20, left: 5, right: 5),
                  child: FlatButton(
                      color: Colors.blueAccent,
                      child: new Text(
                        "Read more",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () => launchURL(p_webInfo.URL)),
                ),
              ),
            ],
          ),




        ]));
  }

  @override
  Widget build(BuildContext context) {
    WebInfo = ModalRoute.of(context).settings.arguments;
    if(_init){
      _getMoreInfo(WebInfo);
      _init = false;
    }

    return Scaffold(
        backgroundColor: Colors.black,
        body: ShowMoreInfo_Fun(WebInfo, context));
  }
}
