import 'package:wind_utils/wind_utils.dart';

List<_HttpHeader> _converterHeaders(List<List<String>> headers) {
  return List.of(headers.map((items) {
    return _HttpHeader(items.first, items[1]);
  }));
}

// use match interceptor is execute
abstract class MappedInterceptor {
  final List<String> _includePatterns;
  final List<String> _excludePatterns;

  final List<String> _includeMethods;
  final List<String> _excludeMethods;

  /// HttpHeader {
  ///    name: string;
  ///    value: string
  ///}
  final List<_HttpHeader> _includeHeaders;
  final List<_HttpHeader> _excludeHeaders;

  final PathMatcher _pathMatcher = AntPathMatcher();

  MappedInterceptor(
      {List<String> includePatterns = const [],
      List<String> excludePatterns = const [],
      List<String> includeMethods = const [],
      List<String> excludeMethods = const [],
      List<List<String>> includeHeaders = const [],
      List<List<String>> excludeHeaders = const []})
      : _includePatterns = includePatterns,
        _excludePatterns = excludePatterns,
        _includeMethods = includeMethods,
        _excludeMethods = excludeMethods,
        _includeHeaders = _converterHeaders(includeHeaders),
        _excludeHeaders = _converterHeaders(excludeHeaders);

// Determine a match for the given lookup path.
// @param req
// @return {@code true} if the interceptor applies to the given request path or http methods or http headers
  bool matches(String url, String httpMethod, {headers = const {}}) {
    if (!matchesUrl(url)) {
      return false;
    }
    if (!matchesMethod(httpMethod)) {
      return false;
    }
    if (!matchesHeaders(headers)) {
      return false;
    }

    return true;
  }

  /// Determine a match for the given lookup path.
  /// @param [lookupPath] the current request path
  /// @param [pathMatcher] a path matcher for path pattern matching
  /// @return {@code true} if the interceptor applies to the given request path
  bool matchesUrl(String lookupPath, [PathMatcher? pathMatcher]) {
    var pathMatcherToUse = _pathMatcher;
    if (pathMatcher != null) {
      pathMatcherToUse = pathMatcher;
    }
    var excludePatterns = _excludePatterns;
    var includePatterns = _includePatterns;
    return _doMatch<String>(lookupPath.split("?")[0], includePatterns, excludePatterns, (pattern, path) {
      return pathMatcherToUse.match(pattern, path);
    });
  }

  /// Determine a match for the given http method
  /// [httpMethod] [HttpMethod]
  bool matchesMethod(String httpMethod) {
    return _doMatch<String>(httpMethod, _includeMethods, _excludeMethods, (pattern, matchSource) {
      return pattern == matchSource;
    });
  }

  ///  Determine a match for the given request headers
  ///  [headers]
  bool matchesHeaders(Map<String, String> headers) {
    return _doMatch<_HttpHeader>(headers, _includeHeaders, _excludeHeaders, (header, matchSource) {
      var name = header.name;
      return matchSource[name] == header.value;
    });
  }

  bool _doMatch<T>(matchSource, List includes, List excludes, bool Function(T pattern, dynamic matchSource) predicate) {
    if (excludes.isNotEmpty && excludes.any((pattern) => predicate(pattern, matchSource))) {
      return false;
    }
    return includes.isNotEmpty && includes.any((pattern) => predicate(pattern, matchSource));
  }
}

class _HttpHeader {
  final String name;
  final String value;

  _HttpHeader(this.name, this.value);
}
