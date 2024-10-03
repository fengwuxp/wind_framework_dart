import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../../../lib/src/json/json_serializable_object.dart';

part 'query_hello_req.g.dart';

abstract class QueryHelloReq extends JsonSerializableObject implements Built<QueryHelloReq, QueryHelloReqBuilder> {
  static Serializer<QueryHelloReq> get serializer => _$queryHelloReqSerializer;

  QueryHelloReq._();

  factory QueryHelloReq([updates(QueryHelloReqBuilder b)]) = _$QueryHelloReq;

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
}
