import 'dart:io';

import 'package:test/test.dart';
import 'package:wind_http/src/client/default_client_http_request_factory.dart';
import 'package:wind_http/src/http/converter/string_message_converter.dart';
import 'package:wind_http/src/rest/rest_template.dart';

void main() {
  late RestTemplate restTemplate;
  setUp(() {
    final converters = [
      StringMessageConverter([ContentType.text, ContentType.html])
    ];
    restTemplate = RestTemplate(DefaultClientHttpRequestFactory(converters, []), httpMessageConverters: converters);
  });

  group('RestTemplate Tests', () {
    test('getForObject returns expected result', () async {
      final text = await restTemplate.getForObject("https://www.baidu.com", String);
      print(text);
    });

    test('postForObject sends request and returns expected result', () async {});
  });
}
