import 'package:wind_http/src/client/client_http_response.dart';
import 'package:wind_http/src/http/http_output_message.dart';
import 'package:wind_http/src/http/http_request.dart';
import 'package:wind_http/src/http/http_request_context.dart';



///  Represents a client-side HTTP request.
abstract class ClientHttpRequest implements HttpRequest, HttpRequestContext, HttpOutputMessage {
  /// Execute this request, resulting in a {@link [ClientHttpResponse]} that can be read.
  /// @return the response result of the execution
  /// @throws IOException in case of I/O errors
  Future<ClientHttpResponse> send();
}
