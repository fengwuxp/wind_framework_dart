import 'dart:async';
import 'dart:io';

import 'package:built_value/serializer.dart';
import 'package:logging/logging.dart';
import 'package:wind_http/src/http/converter/abstract_http_message_converter.dart';
import 'package:wind_http/src/http/http_input_message.dart';
import 'package:wind_http/src/http/http_output_message.dart';
import 'package:wind_http/src/http/response_extractor.dart';
import 'package:wind_http/src/util/encoding_utils.dart';
import 'package:wind_utils/wind_utils.dart';

/// 基于built value 的http message converter
/// 用于写入和读取 Content-Type 为[ContentType.json]的数据
class JsonHttpMessageConverter extends AbstractGenericHttpMessageConverter {
  static const String _tag = "BuiltValueHttpMessageConverter";

  ///  兼容一些旧服务器响应
  @deprecated
  static final ContentType _textJson = ContentType("text", "json", charset: "utf-8");

  static final _log = Logger(_tag);

  final JSONSerializer jsonSerializer;

  final BusinessResponseExtractor _businessResponseExtractor;

  JsonHttpMessageConverter(this.jsonSerializer, BusinessResponseExtractor? businessResponseExtractor)
      : _businessResponseExtractor = businessResponseExtractor ?? noneBusinessResponseExtractor,
        super([ContentType.json, _textJson]);

  factory(JSONSerializer jsonSerializer, {BusinessResponseExtractor? businessResponseExtractor}) {
    return JsonHttpMessageConverter(jsonSerializer, businessResponseExtractor);
  }

  @override
  Future<E> read<E>(HttpInputMessage inputMessage, ContentType mediaType,
      {Type? serializeType, FullType specifiedType = FullType.unspecified}) {
    return getContentTypeEncoding(mediaType).decodeStream(inputMessage.body).then((responseBody) {
      if (_log.isLoggable(Level.FINER)) {
        _log.finer("read http response body ==> $responseBody");
      }
      return _businessResponseExtractor(responseBody).then((result) {
        return _resolveExtractorResult(result, specifiedType, serializeType);
      });
    });
  }

  _resolveExtractorResult(result, FullType specifiedType, Type? serializeType) {
    if (_isBaseType(specifiedType, serializeType) || result == null) {
      // 基础数据类型
      return result;
    }
    return jsonSerializer.parseObject(result, resultType: serializeType, specifiedType: specifiedType);
  }

  _isBaseType(FullType specifiedType, Type? serializeType) {
    final type = serializeType ?? specifiedType.root;
    if (type == null) {
      return true;
    }
    for (final baseType in AbstractHttpMessageConverter.baseTypes) {
      if (baseType == type) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<void> write(data, ContentType mediaType, HttpOutputMessage outputMessage) {
    final text = jsonSerializer.toJsonString(data);
    if (_log.isLoggable(Level.FINER)) {
      _log.finer("write data ==> $text");
    }
    super.writeBody(text, ContentType.json, outputMessage);
    return Future.value();
  }
}
