import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:test/test.dart';
import 'package:wind_http/src/built/api_response.dart';
import 'package:wind_utils/wind_utils.dart';

import '../model/serializers.dart';
import '../model/user.dart';

void main() {
  final jsonSerializer = JSONSerializer(serializers);
  ApiResponse.setSerializer(jsonSerializer);
  group("api response serialize test", () {
    test('simple api response serialize', () {
      final ApiResponse<User> response = ApiResponse.formJson({
        "data": {
          "id": 1,
          "date": "2024-09-29",
          "dateGmt": "2024-09-22",
          "type": "none",
          "link": "https://www.baidu.com",
          "tags": [1, 2, 3, 5, 6, 7, 8]
        },
        "success": true,
        "errorCode": "0",
        "traceId": "19o23k1231241"
      }, FullType(User));

      final FullType responseFullType = FullType(ApiResponse, [
        FullType(BuiltList, [FullType(int)])
      ]);
      final listApiResponse = ApiResponse<BuiltList<int>>((b) => b
        ..data = BuiltList<int>([1, 2, 4])
        ..success = true
        ..errorCode = "0"
        ..traceId = "12313");
      final text = jsonSerializer.toJsonString(listApiResponse, specifiedType: responseFullType);
      expect(jsonSerializer.parseObject(text, specifiedType: responseFullType), listApiResponse);
    });
  });
}
