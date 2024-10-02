import 'package:http/http.dart';
import 'package:wind_utils/wind_utils.dart';

/// 文件表单对象
class MultipartFormData {
  /// 表单字段
  final Map<String, String> fields = {};

  final List<MultipartFile> files = [];

  /// 通过对象添加表单字段
  void addFields(JsonSerializableObject data) {
    data.toMap().forEach((k, v) {
      if (v != null) {
        fields[k] = "$v";
      }
    });
  }
}
