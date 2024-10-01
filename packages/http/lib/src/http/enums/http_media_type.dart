// http media type
enum HttpMediaType {
  // 表单
  formData("application/x-www-form-urlencoded"),

  // 文件表单
  multipartFormData("multipart/form-data"),

  //  json
  applicationJson("application/json"),

  // json utf-8
  applicationJsonUtf8("application/json;charset=UTF-8"),

  // 流
  applicationStream("application/octet-stream"),

  // tet
  text("text/plain"),

  // html
  html("text/html");

  const HttpMediaType(this.mediaType);

  final String mediaType;
}
