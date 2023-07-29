import '../Class/WebsiteInfo.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Class/PageComments.dart';
import '../Utils/SaveLogs.dart';
import '../Utils/ColorsFunc.dart';
import '../Class/WebPortal.dart';
import 'dart:async';
import 'package:html/parser.dart' as htmlparser;

WebsiteInfo _websiteInfoGetWebPagesPrawoExtractArticleArticle(
    WebPortal web, dynamic element, int elementNumber) {
  var e =
      element.getElementsByClassName("title")[0].getElementsByTagName("a")[0];


  String _href = e.attributes["href"];
  String _title = e.attributes["title"];

  String  imaSrc = element.getElementsByTagName("picture")[0].getElementsByTagName("img")[0].attributes["src"];

  imaSrc = "https://prawo.pl"+imaSrc;
  String _desc = element.getElementsByClassName("desc")[0].nodes.toString();
  _desc = _desc.replaceAll("[", "");
  _desc = _desc.replaceAll("]", "");

  Duration _duration= Duration(hours: 12, minutes: elementNumber);
  if (element.innerHtml.contains("Najnowsze")){
    _duration= Duration(hours: 1, minutes: elementNumber);
  }


  return new WebsiteInfo(
    url: "https://prawo.pl" + _href,
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

Future<List<WebsiteInfo>> websiteInfoGetWebPagesPrawo(WebPortal web) async {
  List<WebsiteInfo> websCheckList = [];
  try {
    web.url = web.url.replaceAll("http://", "");
    web.url = web.url.replaceAll("https://", "");
    final response = await http.get(Uri.parse("https://" + web.url));
    if (response.statusCode == 200) {
      String stringBodyResponse = response.body.toString();
      var document = htmlparser.parse(stringBodyResponse);
      int i  = 0;
      document.getElementsByClassName("priority-news").forEach((element) {
        i+=1;
        websCheckList.add(_websiteInfoGetWebPagesPrawoExtractArticleArticle(web,element,i));
      });
      return websCheckList;
    }
    return websCheckList;
  } catch (ex) {
    saveLogs.error(ex.toString());
  }
  return websCheckList;
}

Future<WebsiteInfo> websiteInfoGetAllWebInfoPrawo(WebsiteInfo web) async {

  return web;
}
