import '../Class/WebsiteInfo.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Class/PageComments.dart';
import '../Utils/SaveLogs.dart';
import '../Utils/ColorsFunc.dart';
import '../Class/WebPortal.dart';
import 'dart:async';


WebsiteInfo _websiteInfoGetWebPagesDywanikAddArticle( WebPortal web ,dynamic data2){
  dynamic imaSrc = "";
  String _articleTittle = "N/A";
  String _articleDesc = "N/A";
  String _id = "";

  try {
    imaSrc = data2['cover']['url'];
  } catch (ex) {}
  try {
    _articleTittle = data2["title"];
  } catch (ex) {}
  try {
    _articleDesc = data2["description"];
  } catch (ex) {}
  try {
    _id = _id = data2['id'].toString();
  } catch (ex) {}

  return new WebsiteInfo(
    url: "https://dywanik.pl/news/" + data2["slug"],
    tittle: _articleTittle,
    thumbnailUrlLink: imaSrc,
    articleDate: data2['published_at'],
    providerColorAccent: Color_GetColorInString(web.getColor()),
    descriptionBrief: _articleDesc,
    articleID: _id,
    domain: web.url,
    portalType: web.portalType,
  );
}

Future<List<WebsiteInfo>> websiteInfoGetWebPagesDywanik(WebPortal web) async {
  List<WebsiteInfo> websCheckList = [];
  try {
    web.url = web.url.replaceAll("http://", "");
    web.url = web.url.replaceAll("https://", "");
    final response = await http.get(Uri.parse("https://" + web.url));
    if (response.statusCode == 200) {
      String stringBodyResponse = response.body.toString();
      int indexOfFirst = stringBodyResponse.indexOf("{\"props\"");
      if (indexOfFirst < 0) {
        return websCheckList;
      }
      String jsBody = stringBodyResponse.substring(indexOfFirst);
      int lastIndexOf = jsBody.lastIndexOf("}");
      jsBody = jsBody.substring(0, lastIndexOf + 1);
      Map<String, dynamic> map = jsonDecode(jsBody);

      dynamic obj = map["props"]["pageProps"]["dehydratedState"]["queries"][0];
      dynamic data = obj["state"]["data"];
      for (int i = 0; i < 3; i++) {
        dynamic data2;
        try {
          switch (i) {
            case 0:
              {
                data2 = data["main"];
                break;
              }
            case 1:
              {
                data2 = data["secondary"];
                break;
              }
            case 2:
              {
                data2 = data["third"];
                break;
              }
          }
          if (data2 == null) {
            data2 = data[i];
          }
          websCheckList.add(
              _websiteInfoGetWebPagesDywanikAddArticle(web, data2)
          );
        } catch (ex) {}
      }
        obj = map["props"]["pageProps"]["dehydratedState"]["queries"];
      obj = obj[obj.length -1];
        data = obj["state"]["data"]["pages"][0]["data"];
        for (int i = 0; i < 3; i++) {
          dynamic data2;
          try {
            if (data2 == null) {
              data2 = data[i];
            }
            websCheckList.add(
                _websiteInfoGetWebPagesDywanikAddArticle(web, data2)
            );
          } catch (ex) {}
        }

    }
    return websCheckList;
  } catch (ex) {
    saveLogs.error(ex.toString());
  }
  return websCheckList;
}

Future<WebsiteInfo> websiteInfoGetAllWebInfoDywanikPL(WebsiteInfo web) async {
  WebsiteInfo websCheckList = WebsiteInfo(portalType: PortalType.Other);
  try {
    try {
      web.url = web.url.replaceAll("http://", "");
      web.url = web.url.replaceAll("https://", "");
      final response = await http.get(Uri.parse("https://" + web.url));
      if (response.statusCode == 200) {
        String stringBodyResponse = response.body.toString();
        int indexOfFirst = stringBodyResponse.indexOf("{\"props\"");
        if (indexOfFirst < 0) {
          return websCheckList;
        }
        String jsbody = stringBodyResponse.substring(indexOfFirst);
        int lastIndexOf = jsbody.lastIndexOf("}");
        jsbody = jsbody.substring(0, lastIndexOf + 1);
        Map<String, dynamic> map = jsonDecode(jsbody);
        try {
          dynamic obj = map["props"]["pageProps"]["dehydratedState"]["queries"]
              [0]["state"];
          dynamic imaSrc = "";
          String _articleTittle = "N/A";
          String _articleDesc = "N/A";
          String _id = "";
          try {
            imaSrc = obj["data"]["cover"]["url"].toString();
          } catch (ex) {}
          try {
            _articleTittle = obj["data"]["title"];
          } catch (ex) {}
          try {
            _articleDesc = obj["data"]["description"];
          } catch (ex) {}
          try {
            _id = obj["data"]['id'].toString();
          } catch (ex) {}

          try {} catch (ex) {}

          WebsiteInfoDetails webDetails =
              new WebsiteInfoDetails(fullArticle: "N/A");

          websCheckList = new WebsiteInfo(
            url: "https://" + web.url,
            tittle: _articleTittle,
            thumbnailUrlLink: imaSrc,
            articleDate: obj["data"]["published_at"],
            providerColorAccent: Color_GetColorInString(web.getColor()),
            descriptionBrief: _articleDesc,
            articleID: _id,
            domain: web.domain,
            articleDetails: webDetails,
            portalType: web.portalType,
          );

          return websCheckList;
        } catch (ex) {}
      }
    } catch (ex) {
      saveLogs.error(ex.toString());
    }
  } catch (ex) {
    saveLogs.error(ex.toString());
  }
  return websCheckList;
}
