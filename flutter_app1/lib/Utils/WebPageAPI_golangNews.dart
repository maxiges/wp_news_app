import '../Class/WebsiteInfo.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Class/PageComments.dart';
import '../Utils/SaveLogs.dart';
import '../Utils/ColorsFunc.dart';
import '../Class/WebPortal.dart';
import 'dart:async';
import 'package:html/parser.dart' as htmlparser;
import 'dart:math';


List<String> golangImages= [
   "https://miro.medium.com/v2/resize:fit:1400/0*7vQ8eRc28yz9k__r.png",
  "https://bestarion.com/wp-content/uploads/2022/04/what-is-golang-1.png",
  "https://interestedvideos.com/wp-content/uploads/2023/02/golang-gMW2A.jpg",
  "https://play-lh.googleusercontent.com/edQ8_8or0qX3JymcLz5jrHskKXLGjj7b7lGYuBW-oUMmK75vspumKniy6gukdOuzbcNl",
  "https://granulate.io/wp-content/uploads/2021/02/Golang-Performance-510x300-1.png",
  "https://fingers-site-production.s3.eu-central-1.amazonaws.com/uploads/images/NYgf3QgEdUpHTR7YIYacJanBU3JEeDxmIKGOUKcD.jpg",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIl1_nQy_NO6_ycbHecjn_M8ZjAFBRsyx62w&usqp=CAU",
  "https://github.com/egonelbre/gophers/raw/master/.thumb/vector/adventure/hiking.png",
  "https://github.com/egonelbre/gophers/raw/master/.thumb/vector/arts/ballet.png",
  "https://github.com/egonelbre/gophers/raw/master/.thumb/vector/arts/upright.png",
  "https://github.com/egonelbre/gophers/raw/master/.thumb/vector/computer/gamer.png",
  "https://github.com/egonelbre/gophers/raw/master/.thumb/vector/dandy/umbrella.png",
  "https://github.com/egonelbre/gophers/raw/master/.thumb/vector/fairy-tale/sage.png",
  "https://github.com/egonelbre/gophers/raw/master/.thumb/vector/fairy-tale/witch-learning.png",
  "https://github.com/egonelbre/gophers/raw/master/.thumb/vector/projects/emacs-go.png",
  "https://github.com/egonelbre/gophers/raw/master/.thumb/vector/projects/network.png",
  "https://github.com/egonelbre/gophers/raw/master/.thumb/vector/projects/with-C-book.png",
  "https://github.com/egonelbre/gophers/raw/master/.thumb/vector/science/soldering.png",
  "https://github.com/egonelbre/gophers/raw/master/.thumb/vector/superhero/lifting-1TB.png",
  "https://github.com/egonelbre/gophers/raw/master/.thumb/vector/friends/crash-dummy.png",
  "https://github.com/egonelbre/gophers/raw/master/.thumb/vector/fairy-tale/witch-too-much-candy.png"
];

String GetGopherImage(){
  var intValue = Random().nextInt(golangImages.length);
  return golangImages[intValue];
}

WebsiteInfo _websiteInfoGetWebPagesGolangNewsExtractArticleArticle(
    WebPortal web, dynamic element, int elementNumber) {

  var e =
  element.getElementsByClassName("name")[0];


  String _href = e.attributes["href"];
  String _title = e.innerHtml;

  String  imaSrc = GetGopherImage();

  var date =
  element.getElementsByClassName("date")[0].innerHtml;
  String aStr = date.replaceAll(new RegExp(r'[^0-9]'),'');
  int aInt = int.parse(aStr);
  if (aInt <= 1){
    aInt = 0;
  }
  Duration _duration =  Duration(days: aInt);

  String _desc = _title;
  return new WebsiteInfo(
    url: _href,
    tittle: _title,
    thumbnailUrlLink: imaSrc,
    articleDate:DateTime.now().subtract(_duration).toString() ,
    providerColorAccent: Color_GetColorInString(web.getColor()),
    descriptionBrief: _desc,
    articleID: _href,
    domain: web.url,
    portalType: web.portalType,
  );
}

Future<List<WebsiteInfo>> websiteInfoGetWebPagesGolangNews(WebPortal web) async {
  List<WebsiteInfo> websCheckList = [];
  try {
    web.url = web.url.replaceAll("http://", "");
    web.url = web.url.replaceAll("https://", "");
    final response = await http.get(Uri.parse("https://" + web.url));
    if (response.statusCode == 200) {
      String stringBodyResponse = response.body.toString();
      var document = htmlparser.parse(stringBodyResponse);
      int i  = 0;
      document.getElementsByClassName("story").forEach((element) {
        i+=1;
        if (i> 5){
          return;
        }
        websCheckList.add(_websiteInfoGetWebPagesGolangNewsExtractArticleArticle(web,element,i));
      });
      return websCheckList;
    }
    return websCheckList;
  } catch (ex) {
    saveLogs.error(ex.toString());
  }
  return websCheckList;
}

Future<WebsiteInfo> websiteInfoGetAllWebInfoGolandNews(WebsiteInfo web) async {

  return web;
}
