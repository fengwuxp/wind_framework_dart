import 'package:qs_dart/qs_dart.dart';
import 'package:test/test.dart';
import 'package:wind_http/src/rest/default_url_template_handler.dart';
import 'package:wind_http/src/rest/uri_template_handler.dart';

void main() {
  /// grab shaped like example '1{abc}2ll3{efg}' string  ==> abc, efg
  RegExp grabUrlPathVariable = RegExp('{(.+?)}', dotAll: true);
  test("uri template test", () {
    const uriTemplate = "https://test.com/{a}/{b}";
    const queryParams = {'a': 1, 'b': 2};
    const pathVariables = ["m", "22"];

    expect(replacePathVariableValue(uriTemplate, pathVariables), "https://test.com/m/22");
    expect(replacePathVariableValue(uriTemplate, queryParams), "https://test.com/1/2");
  });

  test("query string parser", () {
    final result = QS.decode("a=1&b=2&c=3&c=4&d=true&h=&c&e&");
    expect(result, {
      'a': '1',
      'b': '2',
      'c': ['3', '4', ''],
      'd': 'true',
      'h': '',
      'e': ''
    });
    final queryParams = Map.from(result);
    queryParams["e"] = "";
    queryParams["c"].add("");
    expect(QS.encode(result), "a=1&b=2&c%5B0%5D=3&c%5B1%5D=4&c%5B2%5D=&c%5B3%5D=&d=true&h=&e=");
  });

  final handler = DefaultUriTemplateHandler();

  test("uri template test 2", () {
    const uriTemplate = "https://test.com/{a}/{b}?k=2&c=";
    const queryParams = {'a': 1, 'b': 2};
    const pathVariables = ["m", "22"];
    final url = handler.expand(uriTemplate, queryParams: queryParams, pathVariables: pathVariables);
    expect(url.toString(), "https://test.com/m/22&k=2&c=&a=1&b=2");
  });
}
