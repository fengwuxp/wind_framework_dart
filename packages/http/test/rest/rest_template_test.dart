import 'package:test/test.dart';
import 'package:wind_http/src/client/default_client_http_request_factory.dart';
import 'package:wind_http/src/http/converter/byte_buffer_message_converter.dart';
import 'package:wind_http/src/http/converter/form_data_http_message_converter.dart';
import 'package:wind_http/src/http/converter/http_message_converter.dart';
import 'package:wind_http/src/http/converter/string_message_converter.dart';
import 'package:wind_http/src/rest/rest_template.dart';

// TODO mock 响应
void main() {
  late RestTemplate restTemplate;
  setUp(() {
    List<HttpMessageConverter> converters = [
      ByteBufferMessageConverter(),
      StringMessageConverter(),
      FormDataHttpMessageConverter(),
      // JsonHttpMessageConverter(jsonSerializer)
    ];
    restTemplate = RestTemplate(DefaultClientHttpRequestFactory(converters, []), httpMessageConverters: converters,
        businessResponseExtractor: (responseBody) {
      return responseBody;
    });
  });

  group('RestTemplate Tests', () {
    test('getForObject returns expected result', () async {
      String text = await restTemplate.getForObject("https://www.baidu.com", String);
      expect(text.contains("www.baidu.com"), isTrue);
    });

    test('getForObject for image', () async {});
  });
}
