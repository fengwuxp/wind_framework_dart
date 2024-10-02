import 'dart:io';

import 'package:wind_http/src/client/client_http_response.dart';

class MessageBodyClientHttpResponseWrapper extends ClientHttpResponse {
  final ClientHttpResponse _delegate;

  MessageBodyClientHttpResponseWrapper(this._delegate);

  bool hasMessageBody() {
    final statusCode = this.statusCode;
    if (statusCode <= 100 || statusCode == HttpStatus.noContent || statusCode == HttpStatus.notModified) {
      return false;
    }
    final contentLength = headers[HttpHeaders.contentLengthHeader];
    return contentLength != null && int.parse(contentLength) > 0;
  }

  @override
  Map<String, String> get headers => _delegate.headers;

  @override
  int get statusCode => _delegate.statusCode;

  @override
  String get reasonPhrase => _delegate.reasonPhrase;

  @override
  Stream<List<int>> get body => _delegate.body;

  @override
  bool get ok => _delegate.ok;
}
