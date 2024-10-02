import 'package:qs_dart/qs_dart.dart';
import 'package:wind_http/src/rest/uri_template_handler.dart';

class DefaultUriTemplateHandler implements UriTemplateHandler {
  const DefaultUriTemplateHandler();

  @override
  Uri expand(String uriTemplate, {Map<String, dynamic>? queryParams, List<dynamic>? pathVariables}) {
    if (pathVariables != null && pathVariables.isNotEmpty) {
      uriTemplate = replacePathVariableValue(uriTemplate, pathVariables);
    }

    if (queryParams == null || queryParams.isEmpty) {
      return Uri.parse(uriTemplate);
    }

    // 加入查询参数
    var hasQueryString = uriTemplate.contains("?");
    if (hasQueryString) {
      var [url, queryString] = uriTemplate.split("?");
      var map = QS.decode(queryString);
      map.addAll(queryParams);
      queryParams = map;
      uriTemplate = url;
    }
    String queryString = QS.encode(queryParams, new EncodeOptions(listFormat: ListFormat.repeat));
    StringBuffer url = StringBuffer();
    if (uriTemplate.endsWith("&")) {
      // 以 & 结尾
      url.write(uriTemplate);
      url.write(queryString);
    } else {
      if (hasQueryString) {
        url.write(uriTemplate);
        url.write("&");
        url.write(queryString);
      } else {
        url.write(uriTemplate);
        url.write("?");
        url.write(queryString);
      }
    }
    return Uri.parse(url.toString());
  }
}
