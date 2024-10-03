import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:wind_utils/wind_utils.dart';

import 'title.dart';

part 'hello.g.dart';

abstract class Hello extends JsonSerializableObject implements Built<Hello, HelloBuilder> {
  Hello._();

  factory Hello([updates(HelloBuilder b)]) = _$Hello;

  @BuiltValueField(wireName: 'id')
  int get id;

  @BuiltValueField(wireName: 'date')
  String get date;

  @BuiltValueField(wireName: 'date_gmt')
  String get dateGmt;

  @BuiltValueField(wireName: 'type')
  String get type;

  @BuiltValueField(wireName: 'link')
  String get link;

  @BuiltValueField(wireName: 'title')
  Title get title;

  @BuiltValueField(wireName: 'tags')
  BuiltList<int> get tags;

  static Serializer<Hello> get serializer => _$helloSerializer;

  static Hello? formJson(String json, {FullType specifiedType = FullType.unspecified}) {
    return JsonSerializableObject.jsonSerializer!.parseObject(json, specifiedType: specifiedType);
  }
}
