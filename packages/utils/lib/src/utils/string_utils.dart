final class StringUtils {
  /// 判断字符串是否存在内容
  static bool hasText(String? str) {
    if (str == null) {
      return false;
    }
    return str.trim().isNotEmpty;
  }

  /// -[source]  要拆分的源字符串。
  /// -[delimiter]  用于拆分的分隔符。
  /// -[trimTokens]  指示是否去除每个子字符串的空白字符，默认为 true。
  /// -[ignoreEmptyTokens] 指示是否忽略空字符串，默认为 true。
  static List<String> tokenizeToStringArray(String source, String delimiter,
      {bool trimTokens = true, bool ignoreEmptyTokens = true}) {
    // 如果源字符串为空，返回空列表
    if (source.isEmpty) {
      return [];
    }

    // 按照指定的分隔符拆分字符串
    List<String> result = source.split(delimiter);
    // 处理空白和空字符串
    if (trimTokens) {
      result = result.map((token) => token.trim()).toList();
    }
    // 如果需要，过滤掉空字符串
    if (ignoreEmptyTokens) {
      result = result.where((token) => token.isNotEmpty).toList();
    }
    return result;
  }
}
