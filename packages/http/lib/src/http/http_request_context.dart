/// 保存当前请求的上下文信息
abstract class HttpRequestContext {
  /// Return all attributes of this request.
  Map<String, dynamic> get attributes;

  void putAttribute(String name, value);

  dynamic getAttribute(String name);
}

class DefaultHttpRequestContext implements HttpRequestContext {

  @override
  final Map<String, dynamic> attributes;

  DefaultHttpRequestContext(Map<String, dynamic>? attributes) : attributes = attributes ?? {};

  static DefaultHttpRequestContext form(HttpRequestContext context) {
    return DefaultHttpRequestContext(context.attributes);
  }

  @override
  void putAttribute(String name, value) {
    attributes[name] = value;
  }

  @override
  getAttribute(String name) {
    return attributes[name];
  }
}
