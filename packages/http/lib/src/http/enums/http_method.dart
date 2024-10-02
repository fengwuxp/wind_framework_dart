import 'package:built_value/json_object.dart';

/// http request method const variable
enum HttpMethod {
  get("GET"),
  post("POST"),
  put("PUT"),
  patch("PATCH"),
  delete("DELETE"),
  trace("TRACE"),
  head("HEAD"),
  options("OPTIONS"),
  connect("CONNECT");

  const HttpMethod(this.method);

  final String method;

  /// 根据字符串转换为 HttpMethod 枚举
  static HttpMethod valueOf(String method) {
    return HttpMethod.values.firstWhere((e) => e.method == method);
  }

  static bool supportRequestBody(String httpMethod) {
    HttpMethod method = HttpMethod.valueOf(httpMethod);
    return method == HttpMethod.post ||
        method == HttpMethod.put ||
        method == HttpMethod.patch;
  }

}
