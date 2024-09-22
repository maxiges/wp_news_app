import '../Class/WebsiteInfo.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Class/PageComments.dart';
import '../Utils/SaveLogs.dart';
import '../Utils/ColorsFunc.dart';
import '../Class/WebPortal.dart';
import 'dart:async';

Future<List<PageComments>> getArticleCommentsWordpress(WebsiteInfo web) async {
  List<PageComments> pageCommentList = [];
  try {
    web.domain = web.domain.replaceAll("http://", "");
    web.domain = web.domain.replaceAll("https://", "");
    String urlString =
        'https://${web.domain}/wp-json/wp/v2/comments?post=${web.articleID}';
    var url = Uri.parse(urlString);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> retJson = json.decode(response.body);

      for (dynamic items in retJson) {
        String author, avatar, content, id, parent;
        try {
          author = items["author_name"].toString();
        } catch (ex) {
          author = "N/A";
        }
        try {
          id = items["id"].toString();
        } catch (ex) {
          id = "";
        }
        try {
          parent = items["parent"].toString();
        } catch (ex) {
          parent = "";
        }
        try {
          avatar = items["author_avatar_urls"]["96"].toString();
        } catch (ex) {
          avatar = "N/A";
        }
        try {
          content = items["content"]["rendered"].toString();
        } catch (ex) {
          content = "N/A";
        }
        pageCommentList.add(PageComments(
            author: author,
            avatarImg: avatar,
            postData: content,
            id: id,
            parent: parent));
      }
    }
    return pageCommentList;
  } catch (ex) {
    saveLogs.error(ex.toString());
  }
  return pageCommentList;
}

List<String> ExtractImgsFromString( String contentString) {
  RegExp regExp79 = new RegExp( r'<img[^>]+src="([^">]+)"',
    caseSensitive: false,
    multiLine: true,
  );

  Iterable<RegExpMatch> elements =  regExp79.allMatches(contentString);

  if(!elements.isEmpty){
    List<String> ret = [];
    for (var m in regExp79.allMatches(contentString)) {
      ret.add(m[1].toString());

    }
    return ret;
  }
  return [];
}

Future<List<WebsiteInfo>> websiteInfoGetWebPagesWordpress(WebPortal web) async {
  List<WebsiteInfo> websCheckList = [];
  try {
    try {
      web.url = web.url.replaceAll("http://", "");
      web.url = web.url.replaceAll("https://", "");

      final response = await http
          .get(Uri.parse('https://${web.url}/wp-json/wp/v2/posts?_embed&per_page=${web.articlesRead}'));
      if (response.statusCode == 200) {
        List<dynamic> retJson = json.decode(response.body);
        for (dynamic items in retJson) {
          try {
            dynamic imaSrc = "";
            String _articleTittle = "N/A";
            String _articleDesc = "N/A";
            String _postComments = "N/A";
            String _id = "";
            List _contentImgList = [];
            try {
              imaSrc = items['_embedded']['wp:featuredmedia'][0]
                  ['media_details']['sizes']['medium']['source_url'];
            } catch (ex) {}
            try {
              _articleTittle = items['title']['rendered'];
            } catch (ex) {}
            try {
              _articleDesc = items['excerpt']['rendered'];
            } catch (ex) {}
            try {
              _postComments = items['_links']['replies'][0]['href'].toString();
            } catch (ex) {}
            try {
              _id = _id = items['id'].toString();
            } catch (ex) {}


            websCheckList.add(new WebsiteInfo(
              url: items['link'],
              tittle: _articleTittle,
              thumbnailUrlLink: imaSrc,
              articleDate: items['date'],
              providerColorAccent: Color_GetColorInString(web.getColor()),
              descriptionBrief: _articleDesc,
              articleID: _id,
              domain: web.url,
              portalType: web.portalType,
            ));
          } catch (ex) {}
        }
      }
    } catch (ex) {
      saveLogs.error(ex.toString());
    }
    websCheckList.sort((a, b) {
      if (DateTime.parse(a.articleDate)
              .isBefore(DateTime.parse(b.articleDate)) ==
          true)
        return 1;
      else
        return 0;
    });
  } catch (ex) {
    saveLogs.error(ex.toString());
  }
  return websCheckList;
}


Future<WebsiteInfo> websiteInfoGetAllWebInfoWordpress(WebsiteInfo web) async {
  WebsiteInfo websCheckList = WebsiteInfo(portalType: PortalType.Other);
  try {
    try {
      web.domain = web.domain.replaceAll("http://", "");
      web.domain = web.domain.replaceAll("https://", "");
      final response = await http.get(Uri.parse(
          'https://${web.domain}/wp-json/wp/v2/posts/${web.articleID}?_embed'));
      if (response.statusCode == 200) {
        dynamic retJson = json.decode(response.body);
        try {

          dynamic imaSrc = "";
          String _articleTittle = "N/A";
          String _articleDesc = "N/A";
          String _postComments = "N/A";
          String _id = "";
          String _webFullDes = "";
          List<String> _contentImgList = [];
          try {
            imaSrc = retJson['_embedded']['wp:featuredmedia'][0]
                ['media_details']['sizes']['medium']['source_url'];
          } catch (ex) {}
          try {
            _articleTittle = retJson['title']['rendered'];
          } catch (ex) {}
          try {
            _articleDesc = retJson['excerpt']['rendered'];
          } catch (ex) {}
          try {
            _postComments = retJson['_links']['replies'][0]['href'].toString();
          } catch (ex) {}
          try {
            _id = retJson['id'].toString();
          } catch (ex) {}

          try {
            _webFullDes = retJson['content'].toString();
          } catch (ex) {}

          try {
            _contentImgList = ExtractImgsFromString(retJson['content'].toString());
          } catch (ex) {}

          WebsiteInfoDetails webDetails =
              new WebsiteInfoDetails(fullArticle: _webFullDes);

          websCheckList = new WebsiteInfo(
            url: retJson['link'],
            tittle: _articleTittle,
            thumbnailUrlLink: imaSrc,
            articleDate: retJson['date'],
            providerColorAccent: Color_GetColorInString(web.getColor()),
            descriptionBrief: _articleDesc,
            articleID: _id,
            domain: web.domain,
            articleDetails: webDetails,
            portalType: web.portalType,
            imgsInArticle: _contentImgList,
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
