import '../Globals.dart';
import '../Utils/StringUtils.dart';

class PageComments {
  String author, postData, avatarImg, id, parent;

  PageComments(
      {this.author = "",
      this.postData = "",
      this.avatarImg = Global_NoImageAvater,
      this.id = "",
      this.parent = ""}) {
    this.postData = StringUtils_RemoveAllHTMLVal(this.postData, false);

    if (this.avatarImg.length < 5) {
      this.avatarImg = Global_NoImageAvater;
    }
  }
}
