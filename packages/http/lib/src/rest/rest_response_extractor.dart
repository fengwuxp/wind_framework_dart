import 'dart:io';

import 'package:built_value/serializer.dart';
import 'package:wind_http/src/client/client_http_response.dart';
import 'package:wind_http/src/client/message_body_client_http_response_wrapper.dart';
import 'package:wind_http/src/http/converter/http_message_converter.dart';
import 'package:wind_http/src/http/response_entity.dart';
import 'package:wind_http/src/http/response_extractor.dart';
import 'package:wind_utils/wind_utils.dart';

// http 响应数据提取
class HttpMessageConverterExtractor<T> implements ResponseExtractor<T> {
  List<HttpMessageConverter> _messageConverters;

  Type? _responseType;

  FullType _specifiedType;

  HttpMessageConverterExtractor._(this._messageConverters, this._responseType, this._specifiedType);

  factory HttpMessageConverterExtractor(List<HttpMessageConverter> messageConverters,
      {Type? responseType, FullType specifiedType = FullType.unspecified}) {
    return HttpMessageConverterExtractor._(messageConverters, responseType, specifiedType);
  }

  @override
  Future<T?> extractData(ClientHttpResponse response,
      {Type? serializeType, FullType specifiedType = FullType.unspecified}) async {
    final responseWrapper = MessageBodyClientHttpResponseWrapper(response);
    if (!responseWrapper.hasMessageBody()) {
      return Future.value();
    }

    final contentType = ContentType.parse(response.headers[HttpHeaders.contentTypeHeader] as String);
    for (HttpMessageConverter messageConverter in this._messageConverters) {
      final serializeType0 = this._responseType ?? serializeType;
      if (messageConverter.canRead(contentType, serializeType: serializeType0)) {
        return messageConverter.read<T>(response, contentType,
            serializeType: serializeType0, specifiedType: this._specifiedType);
      }
    }
    return Future.error(Exception("not match http message converter can read contentType = $contentType"));
  }
}

class ResponseEntityResponseExtractor<T> implements ResponseExtractor<ResponseEntity<T>> {
  final HttpMessageConverterExtractor<T> _delegate;

  ResponseEntityResponseExtractor(List<HttpMessageConverter> messageConverters, Type? responseType,
      [FullType specifiedType = FullType.unspecified])
      : _delegate =
            HttpMessageConverterExtractor(messageConverters, responseType: responseType, specifiedType: specifiedType);

  factory([List<HttpMessageConverter>? messageConverters, Type? responseType]) {
    return ResponseEntityResponseExtractor(messageConverters ?? [], responseType);
  }

  @override
  Future<ResponseEntity<T>> extractData(ClientHttpResponse response,
      {Type? serializeType, FullType specifiedType = FullType.unspecified}) async {
    T? body = await this._delegate.extractData(response);
    return ResponseEntity<T>(response.statusCode, response.headers, body as T, response.reasonPhrase);
  }
}

class HeadResponseExtractor implements ResponseExtractor<Map<String, String>> {
  const HeadResponseExtractor();

  /// Extract data from the given {@code ClientHttpResponse} and return it.
  @override
  Future<Map<String, String>> extractData(ClientHttpResponse response,
      {Type? serializeType, FullType specifiedType = FullType.unspecified}) {
    return Future.value(response.headers);
  }
}

class OptionsForAllowResponseExtractor implements ResponseExtractor<Set<String>> {
  final HeadResponseExtractor _headResponseExtractor = HeadResponseExtractor();

  factory() {
    return OptionsForAllowResponseExtractor();
  }

  @override
  Future<Set<String>> extractData(ClientHttpResponse response,
      {Type? serializeType, FullType specifiedType = FullType.unspecified}) async {
    final headers = await _headResponseExtractor.extractData(response, serializeType: serializeType);
    // "Access-Control-Allow-Methods"
    final header = headers["Access-Control-Allow-Methods"] as String;
    if (!StringUtils.hasText(header)) {
      return Future.value(Set.identity());
    }
    return Future.value(Set.from(header.split(",")));
  }
}

class NoneResponseExtractor implements ResponseExtractor<ClientHttpResponse> {
  @override
  Future<ClientHttpResponse?> extractData(ClientHttpResponse response,
      {Type? serializeType, specifiedType = FullType.unspecified}) {
    return Future.value(response);
  }
}

class VoidResponseExtractor implements ResponseExtractor<void> {
  @override
  Future<void> extractData(ClientHttpResponse response, {Type? serializeType, specifiedType = FullType.unspecified}) {
    return Future.value();
  }
}
