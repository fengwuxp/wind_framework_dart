import 'dart:io';

import 'package:built_value/serializer.dart';
import 'package:qs_dart/qs_dart.dart';
import 'package:logging/logging.dart';

import 'package:wind_http/src/http/converter/abstract_http_message_converter.dart';
import 'package:wind_http/src/http/enums/http_media_type.dart';
import 'package:wind_http/src/http/http_input_message.dart';
import 'package:wind_http/src/http/http_output_message.dart';

/// 用于写入和读取 Content-Type 为[HttpMediaType.FORM_DATA]的数据
class FormDataHttpMessageConverter extends AbstractHttpMessageConverter {
  static const String _TAG = "FormDataHttpMessageConverter";
  static final _log = Logger(_TAG);

  static final _formData = ContentType.parse(HttpMediaType.formData.mediaType);

  static final _multipartFormData = ContentType.parse(HttpMediaType.multipartFormData.mediaType);

  FormDataHttpMessageConverter() : super([_formData, _multipartFormData]);

  @override
  bool canRead(ContentType mediaType, {Type? serializeType}) {
    return false;
  }

  @override
  Future<E> read<E>(HttpInputMessage inputMessage, ContentType mediaType,
      {Type? serializeType, FullType specifiedType = FullType.unspecified}) {
    return Future.error("not support ready form data response");
  }

  @override
  Future<void> write(data, ContentType mediaType, HttpOutputMessage outputMessage) {
    if (data == null) {
      return Future.value();
    }
    if (mediaType.value == _formData.value) {
      _writeFormData(data, outputMessage);
    } else {
      _writeMultipartFormData(data, outputMessage);
    }
    return Future.value();
  }

  void _writeFormData(data, HttpOutputMessage outputMessage) {
    if (_log.isLoggable(Level.FINER)) {
      _log.finer("write form data $data");
    }
    String text = QS.encode(data);
    super.writeBody(text, _formData, outputMessage);
  }

  // TODO 处理文件上传
  void _writeMultipartFormData(data, HttpOutputMessage outputMessage) {}
}
