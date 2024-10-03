import 'dart:convert';

import 'package:built_value/serializer.dart';
import 'package:wind_utils/wind_utils.dart';

/// 支持 json 序列化的对象
/// 继承该类的对象必须实现一个静态方法
/// static T formJson(String json)
abstract class JsonSerializableObject {

  static JSONSerializer? jsonSerializer;

  Map<String, dynamic> toMap({FullType specifiedType = FullType.unspecified}) {
    return jsonSerializer!.serializers.serialize(this, specifiedType: specifiedType) as Map<String, dynamic>;
  }

  String toJson({FullType specifiedType = FullType.unspecified}) {
    return json.encode(toMap(specifiedType: specifiedType));
  }
}
