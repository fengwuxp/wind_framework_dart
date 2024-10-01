/// A utility interface for matching paths against patterns.
/// @doc https://github.com/spring-projects/spring-framework/blob/master/spring-core/src/main/java/org/springframework/util/PathMatcher.java
abstract class PathMatcher {
  /// Determines if the given [path] represents a pattern that can be matched
  /// by an implementation of this interface.
  ///
  /// If the return value is `false`, then the [match] method does not have to
  /// be used because direct equality comparisons on the static path strings
  /// will yield the same result.
  ///
  /// - [path]: the path String to check
  /// - Returns `true` if the given [path] represents a pattern.
  bool isPattern(String path);

  /// Matches the given [path] against the given [pattern],
  /// according to this PathMatcher's matching strategy.
  ///
  /// - [pattern]: the pattern to match against
  /// - [path]: the path String to test
  /// - Returns `true` if the supplied [path] matched; `false` if it didn't.
  bool match(String pattern, String path);

  /// Matches the given [path] against the corresponding part of the given
  /// [pattern], according to this PathMatcher's matching strategy.
  ///
  /// This determines whether the pattern at least matches as far as the given
  /// base path goes, assuming that a full path may then match as well.
  ///
  /// - [pattern]: the pattern to match against
  /// - [path]: the path String to test
  /// - Returns `true` if the supplied [path] matched; `false` if it didn't.
  bool matchStart(String pattern, String path);

  /// Given a pattern and a full path, extracts the URI template variables.
  /// URI template variables are expressed through curly brackets ('{' and '}').
  ///
  /// For example, for pattern "/hotels/{hotel}" and path "/hotels/1", this
  /// method will return a map containing "hotel" -> "1".
  ///
  /// - [pattern]: the path pattern
  /// - [path]: the full path to introspect
  /// - Returns the pattern-mapped part of the given [path] (never `null`).
  Map<String, String> extractUriTemplateVariables(String pattern, String path);

  /// Given a pattern and a full path, determines the pattern-mapped part.
  ///
  /// This method is supposed to find out which part of the path is matched
  /// dynamically through an actual pattern, stripping off a statically defined
  /// leading path from the given full path, returning only the actually
  /// pattern-matched part of the path.
  ///
  /// For example, for "myroot/*.html" as pattern and "myroot/myfile.html"
  /// as full path, this method should return "myfile.html". The detailed
  /// determination rules are specified in this PathMatcher's matching strategy.
  ///
  /// A simple implementation may return the given full path as-is in case
  /// of an actual pattern, and the empty String in case of the pattern not
  /// containing any dynamic parts (i.e., the [pattern] parameter being a
  /// static path that wouldn't qualify as an actual [isPattern] pattern).
  ///
  /// A sophisticated implementation will differentiate between the static
  /// parts and the dynamic parts of the given path pattern.
  ///
  /// - [pattern]: the pattern to match against
  /// - [path]: the full path to inspect
  /// - Returns the pattern-mapped part of the given [path].
  String extractPathWithinPattern(String pattern, String path);
}
