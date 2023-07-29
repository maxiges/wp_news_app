import 'package:WP_news_APP/Utils/WebPageAPI_golangNews.dart';
import 'package:WP_news_APP/Utils/WebPageAPI_prawoPL.dart';
import 'package:WP_news_APP/Utils/WebPageAPI_wordpress.dart';
import '../Class/WebsiteInfo.dart';
import '../Class/PageComments.dart';
import '../Class/WebPortal.dart';
import 'dart:async';
import 'WebPageAPI_dywanik.dart';

WebPageFetchAPI webPageFetchAPI = WebPageFetchAPI();

class WebPageFetchAPI {
  Future<List<PageComments>> getPageComments(WebsiteInfo web) async {
    if (web.portalType == PortalType.DywanikPL) {
      List<PageComments> pageCommentList = [];
      return pageCommentList;
    }
    return getArticleCommentsWordpress(web);
  }

  Future<List<WebsiteInfo>> websiteInfoGetWebPages(WebPortal web) async {
    if (web.portalType == PortalType.DywanikPL) {
      return websiteInfoGetWebPagesDywanik(web);
    }else if (web.portalType == PortalType.PrawoPL) {
      return websiteInfoGetWebPagesPrawo(web);
    }else if (web.portalType == PortalType.GolangNews) {
      return websiteInfoGetWebPagesGolangNews(web);
    }
    return websiteInfoGetWebPagesWordpress(web);
  }

  Future<WebsiteInfo> websiteInfoGetAllWebInfo(WebsiteInfo web) async {
    if (web.portalType == PortalType.DywanikPL) {
      return websiteInfoGetAllWebInfoDywanikPL(web);
    }else if (web.portalType == PortalType.PrawoPL) {
      return websiteInfoGetAllWebInfoPrawo(web);
    }else if (web.portalType == PortalType.GolangNews) {
      return websiteInfoGetAllWebInfoGolandNews(web);
    }
    return websiteInfoGetAllWebInfoWordpress(web);
  }
}
