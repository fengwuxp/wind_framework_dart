/// 首字母转小写
String initialLowercase(String methodName) {
  if (methodName.isEmpty) return methodName;
  return methodName[0].toLowerCase() + methodName.substring(1);
}

final _toHumpRegExp = RegExp("\\_(.+?)", dotAll: true);

/// 下划线转驼峰
String toHumpResolver(String methodName) {
  return methodName.replaceAllMapped(_toHumpRegExp, (Match match) {
    String? text = match.group(0);
    if (text == null) {
      return '';
    }
    return text.substring(1, text.length).toUpperCase();
  });
}

final _toLineResolver = RegExp("([A-Z])", dotAll: true);

/// 驼峰转下划线
String toLineResolver(String methodName) {
  return methodName.replaceAllMapped(_toLineResolver, (Match match) {
    String? text = match.group(0);
    if (text == null) {
      return '';
    }
    return "_${text.toLowerCase()}";
  });
}
