final _replaceSymbolRegExp = RegExp('Symbol|\\("|"\\)');

/// 解析 Symbol的name
String parseSymbolName(Symbol symbol) {
  return symbol.toString().replaceAll(_replaceSymbolRegExp, "");
}
