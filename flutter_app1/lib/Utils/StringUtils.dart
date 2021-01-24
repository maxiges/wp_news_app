String StringUtils_RemoveAllHTMLVal(String str, bool addNewLine) {
  str = str.replaceAll("\u0105", "ą");
  str = str.replaceAll("\u0107", "ć");
  str = str.replaceAll("\u0119", "ę");
  str = str.replaceAll("\u0142", "ł");
  str = str.replaceAll("\u0144", "ń");
  str = str.replaceAll("\u00f3", "ó");
  str = str.replaceAll("\u015b", "ś");
  str = str.replaceAll("\u017a", "ź");
  str = str.replaceAll("\u017c", "ż");
  str = str.replaceAll("\r", "");
  str = str.replaceAll("\n", "");
  str = str.replaceAll("&#8211;", "–");
  str = str.replaceAll("&#8217;", "’");
  str = str.replaceAll("&#8230;", "…");
  str = str.replaceAll("&#8222;", "„");
  str = str.replaceAll("&#8221;", "”");
  str = str.replaceAll("&#8220;", "“");
  str = str.replaceAll("[&hellip;]", " ");

  str = str.replaceAll("&lt;", "<");
  str = str.replaceAll("&gt;", ">");
  str = str.replaceAll("&le;", "<=");
  str = str.replaceAll("&ge;", ">=");
  str = str.replaceAll("&nbsp;", " ");

  str = str.replaceAll("{rendered:", "");
  str = str.replaceAll(", protected: false}", "");

  if (addNewLine) {
    str = str.replaceAll("<li>", "  • ");
    str = str.replaceAll("<h1>", "\r\n");
    str = str.replaceAll("<h2>", "\r\n");
    str = str.replaceAll("<h3>", "\r\n");
  }

  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  if (addNewLine) {
    str = str.replaceAll(exp, '\r\n');
    while (str.indexOf("\r\n\r\n\r\n") > 0) {
      str = str.replaceAll("\r\n\r\n\r\n", '\r\n\r\n');
    }
  } else {
    str = str.replaceAll(exp, '');
  }

  return str;
}
