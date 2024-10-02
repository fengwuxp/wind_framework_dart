import 'dart:io';

import 'package:wind_http/src/http/converter/http_message_converter.dart';
import 'package:wind_http/src/http/http_output_message.dart';
import 'package:wind_http/src/util/encoding_utils.dart';

abstract class AbstractHttpMessageConverter<T> implements HttpMessageConverter<T> {
  /// 基础数据类型
  static const List<Type> baseTypes = [String, bool, num];

  final List<ContentType> supportedMediaTypes;

  AbstractHttpMessageConverter(this.supportedMediaTypes);

  @override
  bool canRead(ContentType mediaType, {Type? serializeType}) {
    return _matchContentType(mediaType);
  }

  @override
  bool canWrite(ContentType mediaType, {Type? serializeType}) {
    return _matchContentType(mediaType);
  }

  @override
  List<ContentType> getSupportedMediaTypes() {
    return this.supportedMediaTypes;
  }

  void writeBody(String? value, ContentType mediaType, HttpOutputMessage outputMessage) {
    if (value == null) {
      return;
    }
    outputMessage.body.add(getContentTypeEncoding(mediaType).encode(value));
  }

  bool _matchContentType(ContentType mediaType) {
    return this.supportedMediaTypes.any((item) {
      return item.value == mediaType.value;
    });
  }
}

abstract class AbstractGenericHttpMessageConverter<T> extends AbstractHttpMessageConverter<T>
    implements GenericHttpMessageConverter<T> {
  AbstractGenericHttpMessageConverter(super.supportedMediaTypes);
}
