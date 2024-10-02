import 'package:wind_http/src/http/http_input_message.dart';

// The payload object used to make the HTTP request
abstract class ClientHttpResponse implements HttpInputMessage {
  // http status code
  int get statusCode;

  ///  http status text
  String get reasonPhrase;

  //  request is success
  bool get ok => statusCode >= 200 && statusCode < 300;
}
