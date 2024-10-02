import 'dart:async';

import 'package:wind_http/src/client/client_http_request.dart';
import 'package:wind_http/src/client/client_http_request_interceptor.dart';
import 'package:wind_http/src/client/client_http_response.dart';

/// 支持 [ClientHttpRequestInterceptor] 执行的 [ClientHttpRequest]
class InterceptingClientHttpRequest implements ClientHttpRequest {
  final ClientHttpRequest delegate;

  final Iterator<ClientHttpRequestInterceptor> iterator;

  InterceptingClientHttpRequest(this.delegate, this.iterator);

  @override
  Map<String, dynamic> get attributes => delegate.attributes;

  @override
  StreamSink<List<int>> get body => delegate.body;

  @override
  getAttribute(String name) {
    return delegate.getAttribute(name);
  }

  @override
  Map<String, String> get headers => delegate.headers;

  @override
  String get method => delegate.method;

  @override
  void putAttribute(String name, value) {
    delegate.putAttribute(name, value);
  }

  @override
  Future<ClientHttpResponse> send() {
    return _intercept(delegate);
  }

  Future<ClientHttpResponse> _intercept(ClientHttpRequest request) {
    if (iterator.moveNext()) {
      return iterator.current.intercept(this, (request) {
        // 调用下一个 拦截器
        return _intercept(request);
      });
    } else {
      // 发送请求
      return request.send();
    }
  }

  @override
  int get timeout => delegate.timeout;

  @override
  void uri(Uri uri) {
    delegate.uri(uri);
  }

  @override
// TODO: implement url
  Uri get url => delegate.url;
}
