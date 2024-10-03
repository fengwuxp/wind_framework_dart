// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ApiResponse<Object?>> _$apiResponseSerializer =
    new _$ApiResponseSerializer();

class _$ApiResponseSerializer
    implements StructuredSerializer<ApiResponse<Object?>> {
  @override
  final Iterable<Type> types = const [ApiResponse, _$ApiResponse];
  @override
  final String wireName = 'ApiResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, ApiResponse<Object?> object,
      {FullType specifiedType = FullType.unspecified}) {
    final isUnderspecified =
        specifiedType.isUnspecified || specifiedType.parameters.isEmpty;
    if (!isUnderspecified) serializers.expectBuilder(specifiedType);
    final parameterT =
        isUnderspecified ? FullType.object : specifiedType.parameters[0];

    final result = <Object?>[
      'errorCode',
      serializers.serialize(object.errorCode,
          specifiedType: const FullType(String)),
      'success',
      serializers.serialize(object.success,
          specifiedType: const FullType(bool)),
      'traceId',
      serializers.serialize(object.traceId,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.data;
    if (value != null) {
      result
        ..add('data')
        ..add(serializers.serialize(value, specifiedType: parameterT));
    }
    value = object.errorMessage;
    if (value != null) {
      result
        ..add('errorMessage')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  ApiResponse<Object?> deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final isUnderspecified =
        specifiedType.isUnspecified || specifiedType.parameters.isEmpty;
    if (!isUnderspecified) serializers.expectBuilder(specifiedType);
    final parameterT =
        isUnderspecified ? FullType.object : specifiedType.parameters[0];

    final result = isUnderspecified
        ? new ApiResponseBuilder<Object?>()
        : serializers.newBuilder(specifiedType) as ApiResponseBuilder<Object?>;

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'data':
          result.data =
              serializers.deserialize(value, specifiedType: parameterT);
          break;
        case 'errorMessage':
          result.errorMessage = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'errorCode':
          result.errorCode = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'success':
          result.success = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'traceId':
          result.traceId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ApiResponse<T> extends ApiResponse<T> {
  @override
  final T? data;
  @override
  final String? errorMessage;
  @override
  final String errorCode;
  @override
  final bool success;
  @override
  final String traceId;

  factory _$ApiResponse([void Function(ApiResponseBuilder<T>)? updates]) =>
      (new ApiResponseBuilder<T>()..update(updates))._build();

  _$ApiResponse._(
      {this.data,
      this.errorMessage,
      required this.errorCode,
      required this.success,
      required this.traceId})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        errorCode, r'ApiResponse', 'errorCode');
    BuiltValueNullFieldError.checkNotNull(success, r'ApiResponse', 'success');
    BuiltValueNullFieldError.checkNotNull(traceId, r'ApiResponse', 'traceId');
    if (T == dynamic) {
      throw new BuiltValueMissingGenericsError(r'ApiResponse', 'T');
    }
  }

  @override
  ApiResponse<T> rebuild(void Function(ApiResponseBuilder<T>) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiResponseBuilder<T> toBuilder() =>
      new ApiResponseBuilder<T>()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiResponse &&
        data == other.data &&
        errorMessage == other.errorMessage &&
        errorCode == other.errorCode &&
        success == other.success &&
        traceId == other.traceId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, errorCode.hashCode);
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jc(_$hash, traceId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiResponse')
          ..add('data', data)
          ..add('errorMessage', errorMessage)
          ..add('errorCode', errorCode)
          ..add('success', success)
          ..add('traceId', traceId))
        .toString();
  }
}

class ApiResponseBuilder<T>
    implements Builder<ApiResponse<T>, ApiResponseBuilder<T>> {
  _$ApiResponse<T>? _$v;

  T? _data;
  T? get data => _$this._data;
  set data(T? data) => _$this._data = data;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  String? _errorCode;
  String? get errorCode => _$this._errorCode;
  set errorCode(String? errorCode) => _$this._errorCode = errorCode;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  String? _traceId;
  String? get traceId => _$this._traceId;
  set traceId(String? traceId) => _$this._traceId = traceId;

  ApiResponseBuilder();

  ApiResponseBuilder<T> get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data;
      _errorMessage = $v.errorMessage;
      _errorCode = $v.errorCode;
      _success = $v.success;
      _traceId = $v.traceId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiResponse<T> other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ApiResponse<T>;
  }

  @override
  void update(void Function(ApiResponseBuilder<T>)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiResponse<T> build() => _build();

  _$ApiResponse<T> _build() {
    final _$result = _$v ??
        new _$ApiResponse<T>._(
            data: data,
            errorMessage: errorMessage,
            errorCode: BuiltValueNullFieldError.checkNotNull(
                errorCode, r'ApiResponse', 'errorCode'),
            success: BuiltValueNullFieldError.checkNotNull(
                success, r'ApiResponse', 'success'),
            traceId: BuiltValueNullFieldError.checkNotNull(
                traceId, r'ApiResponse', 'traceId'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
