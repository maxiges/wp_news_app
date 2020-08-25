String StringUtils_RemoveAllHTMLVal(String str) {
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

  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

  str = str.replaceAll(exp, '');

  return str;
}
