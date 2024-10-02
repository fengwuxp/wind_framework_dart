import 'dart:io';
import 'dart:typed_data';

import 'package:built_value/serializer.dart';
import 'package:wind_http/src/http/converter/abstract_http_message_converter.dart';
import 'package:wind_http/src/http/http_input_message.dart';
import 'package:wind_http/src/http/http_output_message.dart';

class ByteBufferMessageConverter extends AbstractHttpMessageConverter<ByteBuffer> {
  ByteBufferMessageConverter([List<ContentType>? supportedMediaTypes])
      : super(supportedMediaTypes ?? [ContentType.binary]);

  @override
  Future<ByteBuffer> read<ByteBuffer>(HttpInputMessage inputMessage, ContentType mediaType,
      {Type? serializeType, FullType specifiedType = FullType.unspecified}) async {
    List<int> bytes = await inputMessage.body.toList().then((values) => values.expand((i) => i).toList());
    return Future.value(Uint8List.fromList(bytes).buffer as ByteBuffer);
  }

  @override
  Future<void> write(ByteBuffer data, ContentType mediaType, HttpOutputMessage outputMessage) {
    outputMessage.body.add(data.asInt8List().toList());
    return Future.value();
  }
}
