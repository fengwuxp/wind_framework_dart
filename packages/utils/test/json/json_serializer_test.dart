import 'dart:convert';

import 'package:test/test.dart';
import 'package:wind_utils/src/json/json_serializer.dart';
import 'package:wind_utils/src/json/json.dart';
import 'hello/hello.dart';
import 'serializers.dart';

void main() {
  group("simple json test", () {
    test('test json serialize', () {
      String jsonText = '''
 {
      "id": 157538,
      "date": "2017-07-21T10:30:34",
      "date_gmt": "2017-07-21T17:30:34",
      "type": "post",
      "link": "https://example.com",
      "title": {
          "rendered": "Json 2 dart built_value converter"
      },
      "tags": [
          1798,
          6298
      ]
    }
    ''';
      final jsonSerializer = JSONSerializer(serializers);
      JSON.setSerializer(jsonSerializer);
      final hello = serializers.deserializeWith(Hello.serializer, jsonDecode(jsonText));

      final result = jsonSerializer.parseObject(jsonText, resultType: Hello);
      expect(result, hello);
      expect(jsonSerializer.parseObject(json.decode(jsonText), resultType: Hello), hello);
      expect(hello?.toJson(), JSON.toJsonString(result));
    });
  });
}
