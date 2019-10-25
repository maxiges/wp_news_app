import '../Globals.dart';

class PageComments {
  String AUTHOR, POST, AVATARIMG, ID, PARENT;

  PageComments(
      {this.AUTHOR = "",
      this.POST = "",
      this.AVATARIMG = Global_NoImageAvater,
      this.ID = "",
      this.PARENT = ""}) {
    this.POST = RemoveAllHTMLVal(this.POST);

    if (this.AVATARIMG.length < 5) {
      this.AVATARIMG = Global_NoImageAvater;
    }
  }
}
