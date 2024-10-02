import 'dart:async';

import 'package:wind_http/src/client/client_http_request.dart';
import 'package:wind_http/src/client/client_http_response.dart';

class DelegateClientHttpRequest implements ClientHttpRequest {
  final ClientHttpRequest delegate;

  DelegateClientHttpRequest(this.delegate);

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
  int get timeout => delegate.timeout;

  @override
  void uri(Uri uri) {
    delegate.uri(uri);
  }

  @override
  Uri get url => delegate.url;

  @override
  Future<ClientHttpResponse> send() {
    return delegate.send();
  }
}
