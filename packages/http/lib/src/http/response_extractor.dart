import 'package:built_value/serializer.dart';
import 'package:wind_http/src/client/client_http_response.dart';

/// Generic callback interface used by {@link RestTemplate}'s retrieval methods
/// Implementations of this interface perform the actual work of extracting data
/// from a {@link ClientHttpResponse}, but don't need to worry about exception
/// handling or closing resources.

/// <p>Used internally by the {@link RestTemplate}, but also useful for
/// application code. There is one available factory method, see
/// {@link RestTemplate#responseEntityExtractor(Type)}.
/// [RestTemplate]
abstract class ResponseExtractor<T> {
  /// Extract data from the given {@code [ClientHttpResponse]} and return it.
  Future<T?> extractData(ClientHttpResponse response,
      {Type serializeType, FullType specifiedType = FullType.unspecified});
}

/// Judge whether the business is successfully processed and capture the data results of business response
/// [responseBody]  the HTTP response data
/// [return] if request business handle success return business data [String] or [Map] or [List], else return [Future#error(json.decode(responseBody))]
typedef BusinessResponseExtractor = dynamic Function(dynamic responseBody);