import 'dart:async';
import 'dart:io';

import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:wind_http/src/client/abstract_client_http_request.dart';
import 'package:wind_http/src/client/client_http_exception.dart';
import 'package:wind_http/src/client/client_http_response.dart';
import 'package:wind_http/src/http/converter/http_message_converter.dart';
import 'package:wind_http/src/http/enums/http_media_type.dart';
import 'package:wind_http/src/http/enums/http_method.dart';
import 'package:wind_http/src/http/streamed_client_http_response.dart';
import 'package:wind_utils/wind_utils.dart';

///  http client request
class DefaultClientHttpRequest extends AbstractClientHttpRequest {
  static const String _tag = "RestClientHttpRequest";

  static final _log = Logger(_tag);

  // 默认的 content-type
  final HttpMediaType defaultProduce;

  final List<HttpMessageConverter> httpMessageConverters;

  DefaultClientHttpRequest(super.url, super.method,
      {super.timeout,
      super.requestBody,
      super.headers,
      super.context,
      List<HttpMessageConverter>? httpMessageConverters,
      HttpMediaType? defaultProduce})
      : httpMessageConverters = httpMessageConverters ?? [],
        defaultProduce = defaultProduce ?? HttpMediaType.formData;

  @override
  Future<ClientHttpResponse> send() async {
    if (_log.isLoggable(Level.FINER)) {
      _log.finer("请求方法：$method 请求url:$url 请求头：$headers 请求体：$requestBody");
    }

    final request = Request(method, url);
    request.headers.addAll(headers);
    if (HttpMethod.supportRequestBody(method)) {
      await _writeRequestBody(request);
    }

    if (HttpMethod.supportRequestBody(method) && !StringUtils.hasText(request.headers[HttpHeaders.contentTypeHeader])) {
      request.headers[HttpHeaders.contentTypeHeader] = defaultProduce.mediaType;
    }

    return request
        .send()
        //TODO 超时处理
        // .timeout(Duration(milliseconds: timeout))
        .then((response) => StreamedClientHttpResponse(response))
        .onError((error, stackTrace) => Future.error(ClientHttpException(error.toString(), this, error), stackTrace));
  }

  Future<void> _writeRequestBody(Request request) async {
    final List<int> requestBytes = [];
    body.stream.listen(requestBytes.addAll);
    final contentType = ContentType.parse(headers[HttpHeaders.contentTypeHeader] as String);
    for (HttpMessageConverter messageConverter in httpMessageConverters) {
      if (messageConverter.canWrite(contentType)) {
        await messageConverter.write(requestBody, contentType, this);
      }
    }
    request.bodyBytes = requestBytes;
  }
}
