import 'dart:convert';

class ResponseEntity<T> {
  final int _statusCode;

  final Map<String, String> _headers;

  final T _body;

  final String _reasonPhrase;

  ResponseEntity(this._statusCode, this._headers, this._body, this._reasonPhrase); // http status code

  static ResponseEntity<T> of<T>(
    int statusCode,
    Map<String, String> headers,
    T body,
    String statusText,
  ) {
    return ResponseEntity(statusCode, headers, body, statusText);
  }

  int get statusCode => _statusCode;

  ///  http status text
  String get reasonPhrase => _reasonPhrase;

  T get body => _body;

  //  request is success
  bool get ok => this.statusCode >= 200 && this.statusCode < 300;

  // http response headers
  Map<String, String> get headers => _headers;
}

class StringResponseEntity extends ResponseEntity<String> {
  StringResponseEntity(super.status, super.headers, super.body, super.reasonPhrase);

  json() {
    return jsonDecode(body);
  }
}
