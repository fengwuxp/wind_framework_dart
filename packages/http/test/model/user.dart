import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:wind_utils/wind_utils.dart';

import './serializers.dart';

part 'user.g.dart';

// 用户对象
abstract class User implements Built<User, UserBuilder>, JsonSerializableObject {
  User._();

  factory User([updates(UserBuilder b)]) = _$User;

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

  @BuiltValueField(wireName: 'tags')
  BuiltList<int> get tags;

  static Serializer<User> get serializer => _$userSerializer;

  static User? formJson(String json) {
    return serializers.deserializeWith(User.serializer, jsonDecode(json));
  }

  @override
  Map<String, dynamic> toMap() {
    return serializers.serializeWith(User.serializer, this) as Map<String, dynamic>;
  }

  @override
  String toJson() {
    return json.encode(toMap());
  }
}
