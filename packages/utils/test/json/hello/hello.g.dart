// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hello.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Hello> _$helloSerializer = new _$HelloSerializer();

class _$HelloSerializer implements StructuredSerializer<Hello> {
  @override
  final Iterable<Type> types = const [Hello, _$Hello];
  @override
  final String wireName = 'Hello';

  @override
  Iterable<Object?> serialize(Serializers serializers, Hello object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'date',
      serializers.serialize(object.date, specifiedType: const FullType(String)),
      'date_gmt',
      serializers.serialize(object.dateGmt,
          specifiedType: const FullType(String)),
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(String)),
      'link',
      serializers.serialize(object.link, specifiedType: const FullType(String)),
      'title',
      serializers.serialize(object.title, specifiedType: const FullType(Title)),
      'tags',
      serializers.serialize(object.tags,
          specifiedType:
              const FullType(BuiltList, const [const FullType(int)])),
    ];

    return result;
  }

  @override
  Hello deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new HelloBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'date':
          result.date = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'date_gmt':
          result.dateGmt = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'link':
          result.link = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'title':
          result.title.replace(serializers.deserialize(value,
              specifiedType: const FullType(Title))! as Title);
          break;
        case 'tags':
          result.tags.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(int)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$Hello extends Hello {
  @override
  final int id;
  @override
  final String date;
  @override
  final String dateGmt;
  @override
  final String type;
  @override
  final String link;
  @override
  final Title title;
  @override
  final BuiltList<int> tags;

  factory _$Hello([void Function(HelloBuilder)? updates]) =>
      (new HelloBuilder()..update(updates))._build();

  _$Hello._(
      {required this.id,
      required this.date,
      required this.dateGmt,
      required this.type,
      required this.link,
      required this.title,
      required this.tags})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'Hello', 'id');
    BuiltValueNullFieldError.checkNotNull(date, r'Hello', 'date');
    BuiltValueNullFieldError.checkNotNull(dateGmt, r'Hello', 'dateGmt');
    BuiltValueNullFieldError.checkNotNull(type, r'Hello', 'type');
    BuiltValueNullFieldError.checkNotNull(link, r'Hello', 'link');
    BuiltValueNullFieldError.checkNotNull(title, r'Hello', 'title');
    BuiltValueNullFieldError.checkNotNull(tags, r'Hello', 'tags');
  }

  @override
  Hello rebuild(void Function(HelloBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HelloBuilder toBuilder() => new HelloBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Hello &&
        id == other.id &&
        date == other.date &&
        dateGmt == other.dateGmt &&
        type == other.type &&
        link == other.link &&
        title == other.title &&
        tags == other.tags;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, dateGmt.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, link.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Hello')
          ..add('id', id)
          ..add('date', date)
          ..add('dateGmt', dateGmt)
          ..add('type', type)
          ..add('link', link)
          ..add('title', title)
          ..add('tags', tags))
        .toString();
  }
}

class HelloBuilder implements Builder<Hello, HelloBuilder> {
  _$Hello? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  String? _dateGmt;
  String? get dateGmt => _$this._dateGmt;
  set dateGmt(String? dateGmt) => _$this._dateGmt = dateGmt;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _link;
  String? get link => _$this._link;
  set link(String? link) => _$this._link = link;

  TitleBuilder? _title;
  TitleBuilder get title => _$this._title ??= new TitleBuilder();
  set title(TitleBuilder? title) => _$this._title = title;

  ListBuilder<int>? _tags;
  ListBuilder<int> get tags => _$this._tags ??= new ListBuilder<int>();
  set tags(ListBuilder<int>? tags) => _$this._tags = tags;

  HelloBuilder();

  HelloBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _date = $v.date;
      _dateGmt = $v.dateGmt;
      _type = $v.type;
      _link = $v.link;
      _title = $v.title.toBuilder();
      _tags = $v.tags.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Hello other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Hello;
  }

  @override
  void update(void Function(HelloBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Hello build() => _build();

  _$Hello _build() {
    _$Hello _$result;
    try {
      _$result = _$v ??
          new _$Hello._(
              id: BuiltValueNullFieldError.checkNotNull(id, r'Hello', 'id'),
              date:
                  BuiltValueNullFieldError.checkNotNull(date, r'Hello', 'date'),
              dateGmt: BuiltValueNullFieldError.checkNotNull(
                  dateGmt, r'Hello', 'dateGmt'),
              type:
                  BuiltValueNullFieldError.checkNotNull(type, r'Hello', 'type'),
              link:
                  BuiltValueNullFieldError.checkNotNull(link, r'Hello', 'link'),
              title: title.build(),
              tags: tags.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'title';
        title.build();
        _$failedField = 'tags';
        tags.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'Hello', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
