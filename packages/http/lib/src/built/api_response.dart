import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:wind_utils/wind_utils.dart';

part 'api_response.g.dart';

abstract class ApiResponse<T> extends JsonSerializableObject implements Built<ApiResponse<T>, ApiResponseBuilder<T>> {
  static Serializer<ApiResponse> get serializer => _$apiResponseSerializer;

  static JSONSerializer? _serializer;

  ApiResponse._();

  factory ApiResponse([updates(ApiResponseBuilder<T> b)]) = _$ApiResponse<T>;

  @BuiltValueField(wireName: 'data')
  T? get data;

  @BuiltValueField(wireName: 'errorMessage')
  String? get errorMessage;

  @BuiltValueField(wireName: 'errorCode')
  String get errorCode;

  bool get success;

  String get traceId;

  static ApiResponse<T> formJson<T>(Map map, FullType specifiedType) {
    return _serializer!.parseObject(map, specifiedType: FullType(ApiResponse, [specifiedType])) as ApiResponse<T>;
  }

  static ApiResponse formJsonBySerializer(Map map) {
    return _serializer!.parseObject(map) as ApiResponse;
  }

  @override
  toMap({FullType specifiedType = FullType.unspecified}) {
    return _serializer!.serializers.serialize(this, specifiedType: specifiedType) as Map<String, dynamic>;
  }

  static void setSerializer(JSONSerializer serializer) {
    _serializer = serializer;
  }
}
