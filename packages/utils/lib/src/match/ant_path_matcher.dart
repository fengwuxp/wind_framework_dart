import 'package:wind_utils/src/match/path_matcher.dart';
import 'package:wind_utils/src/utils/string_utils.dart';

/// ant-style path matcher
/// 代码参考：https://github.com/spring-projects/spring-framework/blob/main/spring-core/src/main/java/org/springframework/util/AntPathMatcher.java
class AntPathMatcher implements PathMatcher {
  static const String defaultPathSeparator = '/';
  static const int cacheTurnoffThreshold = 65535;
  static const List<String> wildcardChars = ['*', '?', '{'];

  final Map<String, List<String>> tokenizedPatternCache = {};

  final String pathSeparator;
  final bool caseSensitive;
  final bool trimTokens;
  final bool cachePatterns;

  AntPathMatcher(
      {String? pathSeparator,
      this.caseSensitive = true,
      this.trimTokens = false,
      this.cachePatterns = false})
      : pathSeparator = pathSeparator ?? defaultPathSeparator;

  @override
  String extractPathWithinPattern(String pattern, String path) {
    List<String> patternParts = StringUtils.tokenizeToStringArray(
        pattern, pathSeparator,
        trimTokens: trimTokens, ignoreEmptyTokens: true);
    List<String> pathParts = StringUtils.tokenizeToStringArray(
        path, pathSeparator,
        trimTokens: trimTokens, ignoreEmptyTokens: true);
    StringBuffer builder = StringBuffer();
    bool pathStarted = false;

    for (int segment = 0; segment < patternParts.length; segment++) {
      String patternPart = patternParts[segment];
      if (patternPart.contains('*') || patternPart.contains('?')) {
        for (; segment < pathParts.length; segment++) {
          if (pathStarted ||
              (segment == 0 && !pattern.startsWith(pathSeparator))) {
            builder.write(pathSeparator);
          }
          builder.write(pathParts[segment]);
          pathStarted = true;
        }
      }
    }

    return builder.toString();
  }

  @override
  bool isPattern(String pattern) {
    return pattern.contains('*') ||
        pattern.contains('?') ||
        (pattern.contains('{') && pattern.contains('}'));
  }

  @override
  bool match(String pattern, String path) {
    return _doMatch(pattern, path, false);
  }

  @override
  bool matchStart(String pattern, String path) {
    return _doMatch(pattern, path, false);
  }

  @override
  Map<String, String> extractUriTemplateVariables(String pattern, String path) {
    final variables = <String, String>{};
    final result = _doMatch(pattern, path, true, variables);
    if (!result) {
      throw ArgumentError('Pattern "$pattern" does not match path "$path"');
    }
    return variables;
  }

  bool _doMatch(String pattern, String path, bool fullMatch,
      [Map<String, String>? uriTemplateVariables]) {
    if (path.startsWith(pathSeparator) != pattern.startsWith(pathSeparator)) {
      return false;
    }

    List<String> pattDirs = _tokenizePattern(pattern);
    if (fullMatch && caseSensitive && !_isPotentialMatch(path, pattDirs)) {
      return false;
    }

    List<String> pathDirs = _tokenizePath(path);
    int pattIdxStart = 0;
    int pattIdxEnd = pattDirs.length - 1;
    int pathIdxStart = 0;
    int pathIdxEnd = pathDirs.length - 1;

    // Match all elements up to the first **
    while (pattIdxStart <= pattIdxEnd && pathIdxStart <= pathIdxEnd) {
      String pattDir = pattDirs[pattIdxStart];
      if ("**" == pattDir) {
        break;
      }
      if (!_matchStrings(
          pattDir, pathDirs[pathIdxStart], uriTemplateVariables)) {
        return false;
      }
      pattIdxStart++;
      pathIdxStart++;
    }

    if (pathIdxStart > pathIdxEnd) {
      // Path is exhausted, only match if rest of pattern is * or **'s
      if (pattIdxStart > pattIdxEnd) {
        return (pattern.endsWith(pathSeparator) ==
            path.endsWith(pathSeparator));
      }
      if (!fullMatch) {
        return true;
      }
      if (pattIdxStart == pattIdxEnd &&
          pattDirs[pattIdxStart] == "*" &&
          path.endsWith(pathSeparator)) {
        return true;
      }
      for (int i = pattIdxStart; i <= pattIdxEnd; i++) {
        if (pattDirs[i] != "**") {
          return false;
        }
      }
      return true;
    } else if (pattIdxStart > pattIdxEnd) {
      // String not exhausted, but pattern is. Failure.
      return false;
    } else if (!fullMatch && "**" == pattDirs[pattIdxStart]) {
      // Path start definitely matches due to "**" part in pattern.
      return true;
    }

    // up to last '**'
    while (pattIdxStart <= pattIdxEnd && pathIdxStart <= pathIdxEnd) {
      String pattDir = pattDirs[pattIdxEnd];
      if (pattDir == "**") {
        break;
      }
      if (!_matchStrings(pattDir, pathDirs[pathIdxEnd], uriTemplateVariables)) {
        return false;
      }
      pattIdxEnd--;
      pathIdxEnd--;
    }
    if (pathIdxStart > pathIdxEnd) {
      // String is exhausted
      for (int i = pattIdxStart; i <= pattIdxEnd; i++) {
        if (pattDirs[i] != "**") {
          return false;
        }
      }
      return true;
    }

    while (pattIdxStart != pattIdxEnd && pathIdxStart <= pathIdxEnd) {
      int patIdxTmp = -1;
      for (int i = pattIdxStart + 1; i <= pattIdxEnd; i++) {
        if (pattDirs[i] == "**") {
          patIdxTmp = i;
          break;
        }
      }
      if (patIdxTmp == pattIdxStart + 1) {
        // '**/**' situation, so skip one
        pattIdxStart++;
        continue;
      }
      // Find the pattern between padIdxStart & padIdxTmp in str between
      // strIdxStart & strIdxEnd
      int patLength = (patIdxTmp - pattIdxStart - 1);
      int strLength = (pathIdxEnd - pathIdxStart + 1);
      int foundIdx = -1;

      strLoop:
      for (int i = 0; i <= strLength - patLength; i++) {
        for (int j = 0; j < patLength; j++) {
          String subPat = pattDirs[pattIdxStart + j + 1];
          String subStr = pathDirs[pathIdxStart + i + j];
          if (!_matchStrings(subPat, subStr, uriTemplateVariables)) {
            continue strLoop;
          }
        }
        foundIdx = pathIdxStart + i;
        break;
      }

      if (foundIdx == -1) {
        return false;
      }

      pattIdxStart = patIdxTmp;
      pathIdxStart = foundIdx + patLength;
    }

    for (int i = pattIdxStart; i <= pattIdxEnd; i++) {
      if (pattDirs[i] != "**") {
        return false;
      }
    }

    return true;
  }

  List<String> _tokenizePattern(String pattern) {
    List<String> tokenized = [];
    if (cachePatterns) {
      tokenized = tokenizedPatternCache[pattern] ?? [];
    }
    if (tokenized.isEmpty) {
      tokenized = _tokenizePath(pattern);
      if (cachePatterns &&
          tokenizedPatternCache.length >= cacheTurnoffThreshold) {
        // Try to adapt to the runtime situation that we're encountering:
        // There are obviously too many different patterns coming in here...
        // So let's turn off the cache since the patterns are unlikely to be reoccurring.
        _deactivatePatternCache();
        return tokenized;
      }
      if (cachePatterns) {
        tokenizedPatternCache[pattern] = tokenized;
      }
    }
    return tokenized;
  }

  List<String> _tokenizePath(String path) {
    return StringUtils.tokenizeToStringArray(path, pathSeparator,
        trimTokens: trimTokens, ignoreEmptyTokens: true);
  }

  _isPotentialMatch(String path, List<String> pattDirs) {
    if (!trimTokens) {
      int pos = 0;
      for (String pattDir in pattDirs) {
        int skipped = _skipSeparator(path, pos, pathSeparator);
        pos += skipped;
        skipped = _skipSegment(path, pos, pattDir);
        if (skipped < pattDir.length) {
          return (skipped > 0 ||
              (pattDir.isNotEmpty && _isWildcardChar(pattDir[0])));
        }
        pos += skipped;
      }
    }
    return true;
  }

  int _skipSegment(String path, int pos, String prefix) {
    int skipped = 0;
    for (int i = 0; i < prefix.length; i++) {
      String c = prefix[i];
      if (_isWildcardChar(c)) {
        return skipped;
      }
      int currPos = pos + skipped;
      if (currPos >= path.length) {
        return 0;
      }
      if (c == path[currPos]) {
        skipped++;
      }
    }
    return skipped;
  }

  _skipSeparator(String path, int pos, String separator) {
    int skipped = 0;
    while (path.startsWith(separator, pos + skipped)) {
      skipped += separator.length;
    }
    return skipped;
  }

  bool _isWildcardChar(String c) {
    return wildcardChars.contains(c);
  }

  _deactivatePatternCache() {
    tokenizedPatternCache.clear();
  }

  bool _matchStrings(
      String pattern, String str, Map<String, String>? uriTemplateVariables) {
    if (pattern.isEmpty) {
      return str.isEmpty;
    }

    final matcher = _AntPathStringMatcher(pattern, caseSensitive: caseSensitive);
    return matcher.matchStrings(str, uriTemplateVariables);
  }
}

class _AntPathStringMatcher {
  static final RegExp globPattern = RegExp(r'\?|[*]|{([^/]+?)}');

  static const String defaultVariablePattern = '(.*)';

  final String rawPattern;
  final bool caseSensitive;
  bool exactMatch;

  RegExp? pattern;
  final List<String> variableNames = [];

  _AntPathStringMatcher(String pattern, {this.caseSensitive = true})
      : rawPattern = pattern,
        exactMatch = false {
    StringBuffer patternBuilder = StringBuffer();
    int end = 0;
    // 使用 globPattern 匹配模式
    Iterable<RegExpMatch> matches = globPattern.allMatches(pattern);
    for (final match in matches) {
      String matchedString = match.group(0)!;
      patternBuilder.write(_quote(pattern, end, match.start));
      if (matchedString == '?') {
        patternBuilder.write('.');
      } else if (matchedString == '*') {
        patternBuilder.write('.*');
      } else if (matchedString.startsWith('{') && matchedString.endsWith('}')) {
        int colonIdx = matchedString.indexOf(':');
        if (colonIdx == -1) {
          patternBuilder.write(defaultVariablePattern);
          variableNames.add(match.group(1)!);
        } else {
          String variablePattern =
              matchedString.substring(colonIdx + 1, matchedString.length - 1);
          patternBuilder.write('($variablePattern)');
          String variableName = matchedString.substring(1, colonIdx);
          variableNames.add(variableName);
        }
      }
      end = match.end;
    }

    // 如果没有找到任何 glob 模式，说明是精确匹配
    if (end == 0) {
      exactMatch = true;
    } else {
      patternBuilder.write(_quote(pattern, end, pattern.length));
      String finalPattern = patternBuilder.toString();
      this.pattern =
          RegExp(finalPattern, caseSensitive: caseSensitive, dotAll: true);
    }
  }

  String _quote(String s, int start, int end) {
    if (start == end) {
      return '';
    }
    return RegExp.escape(s.substring(start, end));
  }

  bool matchStrings(String str, [Map<String, String>? uriTemplateVariables]) {
    if (exactMatch) {
      return caseSensitive
          ? rawPattern == str
          : rawPattern.toLowerCase() == str.toLowerCase();
    } else if (pattern != null) {
      RegExpMatch? matcher = pattern!.firstMatch(str);
      if (matcher != null) {
        if (uriTemplateVariables != null) {
          if (variableNames.length != matcher.groupCount) {
            throw ArgumentError(
                'The number of capturing groups in the pattern segment '
                '${pattern.toString()} does not match the number of URI template variables it defines.');
          }
          for (int i = 1; i <= matcher.groupCount; i++) {
            String name = variableNames[i - 1];
            if (name.startsWith('*')) {
              throw ArgumentError(
                  'Capturing patterns ($name) are not supported by the AntPathMatcher.');
            }
            String? value = matcher.group(i);
            uriTemplateVariables[name] = value!;
          }
        }
        return true;
      }
    }
    return false;
  }
}
