import 'dart:async';

import 'package:wind_http/src/http/http_request_context.dart';
import 'package:wind_http/src/client/client_http_request.dart';
import 'package:wind_http/src/http/converter/http_message_converter.dart';

/// abstract http client
abstract class AbstractClientHttpRequest extends DefaultHttpRequestContext implements ClientHttpRequest {
  @override
  Uri url;

  @override
  final String method;

  @override
  final int timeout;

  final dynamic requestBody;

  @override
  final Map<String, String> headers;

  /// The controller for [sink], from which [BaseRequest] will read data for
  /// [finalize].
  final StreamController<List<int>> _controller;

  AbstractClientHttpRequest(this.url, this.method,
      {int? timeout,
      this.requestBody,
      Map<String, String>? headers,
      List<HttpMessageConverter>? httpMessageConverters,
      HttpRequestContext? context})
      : timeout = timeout ?? 10000,
        headers = headers ?? {},
        _controller = StreamController<List<int>>(sync: true),
        super(context?.attributes);

  @override
  void uri(Uri uri) {
    url = uri;
  }

  @override
  StreamController<List<int>> get body => _controller;
}
