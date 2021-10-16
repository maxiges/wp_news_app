import '../Class/WebsiteInfo.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Class/PageComments.dart';
import '../Utils/SaveLogs.dart';
import '../Utils/ColorsFunc.dart';
import '../Class/WebPortal.dart';
import 'dart:async';

WebPageFetchAPI webPageFetchAPI = WebPageFetchAPI();

class WebPageFetchAPI {
  Future<List<PageComments>> getPageComments(WebsiteInfo web) async {
    List<PageComments> pageCommentList = [];

    try {
      String url =
          "https://" + web.domain + "/wp-json/wp/v2/comments?post=" + web.articleID;
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> retJson = json.decode(response.body);

        for (dynamic items in retJson) {
          String author, avatar, content, id, parent;
          try {
            author = items["author_name"].toString();
          } catch (ex) {
            author = "N/A";
            assert(ex);
          }
          try {
            id = items["id"].toString();
          } catch (ex) {
            id = "";
            assert(ex);
          }
          try {
            parent = items["parent"].toString();
          } catch (ex) {
            parent = "";
            assert(ex);
          }
          try {
            avatar = items["author_avatar_urls"]["96"].toString();
          } catch (ex) {
            avatar = "N/A";
            assert(ex);
          }
          try {
            content = items["content"]["rendered"].toString();
          } catch (ex) {
            content = "N/A";
            assert(ex);
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
      saveLogs.error(ex);
    }

    return pageCommentList;
  }

  Future<List<WebsiteInfo>> websiteInfoGetWebPages(WebPortal web) async {
    List<WebsiteInfo> websCheckList = [];
    try {
      try {
        final response = await http
            .get("https://" + web.url + "/wp-json/wp/v2/posts?_embed");
        if (response.statusCode == 200) {
          List<dynamic> retJson = json.decode(response.body);
          for (dynamic items in retJson) {
            try {
              dynamic imaSrc = "";
              String _articleTittle = "N/A";
              String _articleDesc = "N/A";
              String _postComments = "N/A";
              String _id = "";

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
                _postComments =
                    items['_links']['replies'][0]['href'].toString();
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
                  domain: web.url));
            } catch (ex) {}
          }
        }
      } catch (ex) {
        saveLogs.error(ex);
      }
      websCheckList.sort((a, b) {
        if (DateTime.parse(a.articleDate).isBefore(DateTime.parse(b.articleDate)) == true)
          return 1;
        else
          return 0;
      });
    } catch (ex) {
      saveLogs.error(ex);
    }
    return websCheckList;
  }

  Future<WebsiteInfo> websiteInfoGetAllWebInfo(WebsiteInfo web) async {
    WebsiteInfo websCheckList = WebsiteInfo();
    try {
      try {
        final response = await http.get("https://" +
            web.domain +
            "/wp-json/wp/v2/posts/" +
            web.articleID +
            "?_embed");
        if (response.statusCode == 200) {
          dynamic retJson = json.decode(response.body);
          try {
            dynamic imaSrc = "";
            String _articleTittle = "N/A";
            String _articleDesc = "N/A";
            String _postComments = "N/A";
            String _id = "";
            String _webFullDes = "";
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
              _postComments =
                  retJson['_links']['replies'][0]['href'].toString();
            } catch (ex) {}
            try {
              _id = retJson['id'].toString();
            } catch (ex) {}

            try {
              _webFullDes = retJson['content'].toString();
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
                articleDetails: webDetails);

            return websCheckList;
          } catch (ex) {}
        }
      } catch (ex) {
        saveLogs.error(ex);
      }
    } catch (ex) {
      saveLogs.error(ex);
    }
    return websCheckList;
  }
//class
}
