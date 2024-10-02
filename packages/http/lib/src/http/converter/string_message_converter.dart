import 'dart:io';

import 'package:built_value/serializer.dart';
import 'package:wind_http/src/http/converter/abstract_http_message_converter.dart';
import 'package:wind_http/src/http/http_input_message.dart';
import 'package:wind_http/src/http/http_output_message.dart';
import 'package:wind_http/src/util/encoding_utils.dart';

/// 字符串
class StringMessageConverter extends AbstractHttpMessageConverter<String> {
  StringMessageConverter([List<ContentType>? supportedMediaTypes])
      : super(supportedMediaTypes ?? [ContentType.html, ContentType.text]);

  @override
  Future<String> read<String>(HttpInputMessage inputMessage, ContentType mediaType,
      {Type? serializeType, FullType specifiedType = FullType.unspecified}) async {
    return getContentTypeEncoding(mediaType).decodeStream(inputMessage.body) as Future<String>;
  }

  @override
  Future<void> write(String data, ContentType mediaType, HttpOutputMessage outputMessage) {
    outputMessage.body.add(data.codeUnits);
    return Future.value();
  }
}
