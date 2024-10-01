import 'package:test/test.dart';
import 'package:wind_utils/wind_utils.dart';

void main() {
  final matcher = AntPathMatcher();

  group('AntPathMatcher Tests', () {
    test('match - exact and wildcard matching', () {
      expect(matcher.match('/foo/*/bar', '/foo/test/bar'), isTrue);
      expect(matcher.match('/foo/{id}', '/foo/123'), isTrue);
      expect(matcher.match('/foo/*/bar', '/foo/bar/baz'), isFalse);
      expect(matcher.match('/foo/**', '/foo/test/bar'), isTrue);
      expect(matcher.match('/foo/**', '/foo/test/bar/more'), isTrue);
      // SPR-8687
      expect(matcher.match("/group/{groupName}/members", "/group/sales/members"), isTrue);
      expect(matcher.match("/group/{groupName}/members", "/group/  sales/members"), isTrue);
      expect(matcher.match("/group/{groupName}/members", "/Group/  Sales/Members"), isFalse);
      expect(matcher.match("/{var:.*}", "/x\ny"), isTrue);
    });

    // SPR-13286
    test('test caseInsensitive', () {
      final pathMatcher = AntPathMatcher(caseSensitive: false);
      expect(pathMatcher.match("/group/{groupName}/members", "/group/sales/members"), isTrue);
      expect(pathMatcher.match("/group/{groupName}/members", "/Group/Sales/Members"), isTrue);
      expect(pathMatcher.match("/Group/{groupName}/Members", "/group/Sales/members"), isTrue);
    });

    test('matchStart - start matching', () {
      expect(matcher.matchStart('/foo/*', '/foo/test/bar'), isFalse);
      expect(matcher.matchStart('/foo/**', '/foo/test/bar'), isTrue);
      expect(matcher.matchStart('/foo/{id}', '/foo/123'), isTrue);
      expect(matcher.matchStart('/foo/*/bar', '/foo/test/bar'), isTrue);
      expect(matcher.matchStart('/foo/bar', '/foo/test/bar'), isFalse);

      expect(matcher.matchStart("/**", "/testing/testing"), isTrue);
      expect(matcher.matchStart("/*/**", "/testing/testing"), isTrue);
      expect(matcher.matchStart("/**/*", "/testing/testing"), isTrue);
      expect(matcher.matchStart("test*/**", "test/"), isTrue);
      expect(matcher.matchStart("test*/**", "test/t"), isTrue);
      expect(matcher.matchStart("/bla/**/bla", "/bla/testing/testing/bla"), isTrue);
      expect(matcher.matchStart("/bla/**/bla", "/bla/testing/testing/bla/bla"), isTrue);
      expect(matcher.matchStart("/**/test", "/bla/bla/test"), isTrue);
      expect(matcher.matchStart("/bla/**/**/bla", "/bla/bla/bla/bla/bla/bla"), isTrue);
      expect(matcher.matchStart("/bla*bla/test", "/blaXXXbla/test"), isTrue);
      expect(matcher.matchStart("/*bla/test", "/XXXbla/test"), isTrue);
      expect(matcher.matchStart("/bla*bla/test", "/blaXXXbl/test"), isFalse);
      expect(matcher.matchStart("/*bla/test", "XXXblab/test"), isFalse);
      expect(matcher.matchStart("/*bla/test", "XXXbl/test"), isFalse);

      expect(matcher.matchStart("/????", "/bala/bla"), isFalse);
      expect(matcher.matchStart("/**/*bla", "/bla/bla/bla/bbb"), isTrue);

      expect(matcher.matchStart("/*bla*/**/bla/**", "/XXXblaXXXX/testing/testing/bla/testing/testing/"), isTrue);
      expect(matcher.matchStart("/*bla*/**/bla/*", "/XXXblaXXXX/testing/testing/bla/testing"), isTrue);
      expect(matcher.matchStart("/*bla*/**/bla/**", "/XXXblaXXXX/testing/testing/bla/testing/testing"), isTrue);
      expect(matcher.matchStart("/*bla*/**/bla/**", "/XXXblaXXXX/testing/testing/bla/testing/testing.jpg"), isTrue);

      expect(matcher.matchStart("*bla*/**/bla/**", "XXXblaXXXX/testing/testing/bla/testing/testing/"), isTrue);
      expect(matcher.matchStart("*bla*/**/bla/*", "XXXblaXXXX/testing/testing/bla/testing"), isTrue);
      expect(matcher.matchStart("*bla*/**/bla/**", "XXXblaXXXX/testing/testing/bla/testing/testing"), isTrue);
      expect(matcher.matchStart("*bla*/**/bla/*", "XXXblaXXXX/testing/testing/bla/testing/testing"), isTrue);

      expect(matcher.matchStart("/x/x/**/bla", "/x/x/x/"), isTrue);

      expect(matcher.matchStart("", ""), isTrue);
    });

    test('Extract URI template variables', () {
      expect(matcher.extractUriTemplateVariables('/foo/{id}', '/foo/123'), equals({'id': '123'}));
      expect(matcher.extractUriTemplateVariables('/users/{userId}/posts/{postId}', '/users/123/posts/456'),
          equals({'userId': '123', 'postId': '456'}));
      expect(matcher.extractUriTemplateVariables('/users/{userId}', '/users/456'), equals({'userId': '456'}));
      expect(
          matcher.extractUriTemplateVariables(
              "{symbolicName:[\\w\\.]+}-{version:[\\w\\.]+}.jar", "com.example-1.0.0.jar"),
          equals({'symbolicName': 'com.example', 'version': '1.0.0'}));
    });

    test('Case sensitivity', () {
      final caseInsensitiveMatcher = AntPathMatcher(caseSensitive: false);
      expect(caseInsensitiveMatcher.match('/FOO/BAR', '/foo/bar'), isTrue);
      expect(caseInsensitiveMatcher.match('/FOO/*', '/foo/bar'), isTrue);
    });

    test('test extractPathWithinPattern', () {
      expect(matcher.extractPathWithinPattern("/docs/commit.html", "/docs/commit.html"), "");

      expect(matcher.extractPathWithinPattern("/docs/*", "/docs/cvs/commit"), "cvs/commit");
      expect(matcher.extractPathWithinPattern("/docs/cvs/*.html", "/docs/cvs/commit.html"), "commit.html");
      expect(matcher.extractPathWithinPattern("/docs/**", "/docs/cvs/commit"), "cvs/commit");
      expect(matcher.extractPathWithinPattern("/docs/**/*.html", "/docs/cvs/commit.html"), "cvs/commit.html");
      expect(matcher.extractPathWithinPattern("/docs/**/*.html", "/docs/commit.html"), "commit.html");
      expect(matcher.extractPathWithinPattern("/*.html", "/commit.html"), "commit.html");
      expect(matcher.extractPathWithinPattern("/*.html", "/docs/commit.html"), "docs/commit.html");
      expect(matcher.extractPathWithinPattern("*.html", "/commit.html"), "/commit.html");
      expect(matcher.extractPathWithinPattern("*.html", "/docs/commit.html"), "/docs/commit.html");
      expect(matcher.extractPathWithinPattern("**/*.*", "/docs/commit.html"), "/docs/commit.html");
      expect(matcher.extractPathWithinPattern("*", "/docs/commit.html"), "/docs/commit.html");
      // SPR-10515
      expect(matcher.extractPathWithinPattern("**/commit.html", "/docs/cvs/other/commit.html"),
          "/docs/cvs/other/commit.html");
      expect(matcher.extractPathWithinPattern("/docs/**/commit.html", "/docs/cvs/other/commit.html"),
          "cvs/other/commit.html");
      expect(matcher.extractPathWithinPattern("/docs/**/**/**/**", "/docs/cvs/other/commit.html"),
          "cvs/other/commit.html");

      expect(matcher.extractPathWithinPattern("/d?cs/*", "/docs/cvs/commit"), "docs/cvs/commit");
      expect(matcher.extractPathWithinPattern("/docs/c?s/*.html", "/docs/cvs/commit.html"), "cvs/commit.html");
      expect(matcher.extractPathWithinPattern("/d?cs/**", "/docs/cvs/commit"), "docs/cvs/commit");
      expect(matcher.extractPathWithinPattern("/d?cs/**/*.html", "/docs/cvs/commit.html"), "docs/cvs/commit.html");
    });
  });
}
