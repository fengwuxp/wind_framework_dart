// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'title.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Title> _$titleSerializer = new _$TitleSerializer();

class _$TitleSerializer implements StructuredSerializer<Title> {
  @override
  final Iterable<Type> types = const [Title, _$Title];
  @override
  final String wireName = 'Title';

  @override
  Iterable<Object?> serialize(Serializers serializers, Title object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'rendered',
      serializers.serialize(object.rendered,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  Title deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TitleBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'rendered':
          result.rendered = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Title extends Title {
  @override
  final String rendered;

  factory _$Title([void Function(TitleBuilder)? updates]) =>
      (new TitleBuilder()..update(updates))._build();

  _$Title._({required this.rendered}) : super._() {
    BuiltValueNullFieldError.checkNotNull(rendered, r'Title', 'rendered');
  }

  @override
  Title rebuild(void Function(TitleBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TitleBuilder toBuilder() => new TitleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Title && rendered == other.rendered;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, rendered.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Title')..add('rendered', rendered))
        .toString();
  }
}

class TitleBuilder implements Builder<Title, TitleBuilder> {
  _$Title? _$v;

  String? _rendered;
  String? get rendered => _$this._rendered;
  set rendered(String? rendered) => _$this._rendered = rendered;

  TitleBuilder();

  TitleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rendered = $v.rendered;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Title other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Title;
  }

  @override
  void update(void Function(TitleBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Title build() => _build();

  _$Title _build() {
    final _$result = _$v ??
        new _$Title._(
            rendered: BuiltValueNullFieldError.checkNotNull(
                rendered, r'Title', 'rendered'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
