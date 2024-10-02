import 'dart:io';

import 'package:http/http.dart';
import 'package:wind_http/src/client/client_http_response.dart';
import 'package:wind_http/src/util/encoding_utils.dart';

/// 基于流的 http response
class StreamedClientHttpResponse extends ClientHttpResponse {

  final StreamedResponse _response;

  StreamedClientHttpResponse(this._response);

  @override
  Map<String, String> get headers => _response.headers;

  @override
  int get statusCode => this._response.statusCode;

  @override
  String get reasonPhrase => _response.reasonPhrase ?? "unknown error";

  @override
  Stream<List<int>> get body => _response.stream;

  Future<String> bodyAsString() {
    final contentType = ContentType.parse(this.headers[HttpHeaders.contentTypeHeader] as String);
    return getContentTypeEncoding(contentType).decodeStream(body);
  }
}
