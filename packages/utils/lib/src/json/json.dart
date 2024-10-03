import 'package:built_value/serializer.dart';
import 'package:wind_utils/wind_utils.dart';

final class JSON {
  static JSONSerializer? _serializer;

  /// parse json [String] or [Map] or [List] or [Set] to object
  /// [source] type [String] or  [Map] or [List] or [Set]
  /// [resultType]  结果数据类型
  /// [formJson]    自定义的 formJson 工厂方法
  /// [specifiedType]  FullType 存在泛型时需要
  /// 泛型支持需要 [SerializersBuilder.addBuilderFactory]
  static T? parseObject<T>(dynamic source,
      {Type? resultType, Function? formJson, FullType specifiedType = FullType.unspecified}) {
    if (_serializer == null) {
      throw ArgumentError('_serializer must not null');
    }
    return _serializer!.parseObject(source, resultType: resultType, formJson: formJson, specifiedType: specifiedType);
  }

  /// object to string
  /// [object] serialize object
  /// [specifiedType]
  static String? toJsonString<T>(object, {FullType specifiedType = FullType.unspecified}) {
    if (_serializer == null) {
      throw ArgumentError('_serializer must not null');
    }
    return _serializer!.toJsonString(object, specifiedType: specifiedType);
  }

  static void setSerializer(JSONSerializer serializer) {
    _serializer = serializer;
    JsonSerializableObject.jsonSerializer = serializer;
  }
}
