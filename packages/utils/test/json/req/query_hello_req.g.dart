// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_hello_req.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<QueryHelloReq> _$queryHelloReqSerializer =
    new _$QueryHelloReqSerializer();

class _$QueryHelloReqSerializer implements StructuredSerializer<QueryHelloReq> {
  @override
  final Iterable<Type> types = const [QueryHelloReq, _$QueryHelloReq];
  @override
  final String wireName = 'QueryHelloReq';

  @override
  Iterable<Object?> serialize(Serializers serializers, QueryHelloReq object,
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
    ];

    return result;
  }

  @override
  QueryHelloReq deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new QueryHelloReqBuilder();

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
      }
    }

    return result.build();
  }
}

class _$QueryHelloReq extends QueryHelloReq {
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

  factory _$QueryHelloReq([void Function(QueryHelloReqBuilder)? updates]) =>
      (new QueryHelloReqBuilder()..update(updates))._build();

  _$QueryHelloReq._(
      {required this.id,
      required this.date,
      required this.dateGmt,
      required this.type,
      required this.link})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'QueryHelloReq', 'id');
    BuiltValueNullFieldError.checkNotNull(date, r'QueryHelloReq', 'date');
    BuiltValueNullFieldError.checkNotNull(dateGmt, r'QueryHelloReq', 'dateGmt');
    BuiltValueNullFieldError.checkNotNull(type, r'QueryHelloReq', 'type');
    BuiltValueNullFieldError.checkNotNull(link, r'QueryHelloReq', 'link');
  }

  @override
  QueryHelloReq rebuild(void Function(QueryHelloReqBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  QueryHelloReqBuilder toBuilder() => new QueryHelloReqBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is QueryHelloReq &&
        id == other.id &&
        date == other.date &&
        dateGmt == other.dateGmt &&
        type == other.type &&
        link == other.link;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, dateGmt.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, link.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'QueryHelloReq')
          ..add('id', id)
          ..add('date', date)
          ..add('dateGmt', dateGmt)
          ..add('type', type)
          ..add('link', link))
        .toString();
  }
}

class QueryHelloReqBuilder
    implements Builder<QueryHelloReq, QueryHelloReqBuilder> {
  _$QueryHelloReq? _$v;

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

  QueryHelloReqBuilder();

  QueryHelloReqBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _date = $v.date;
      _dateGmt = $v.dateGmt;
      _type = $v.type;
      _link = $v.link;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(QueryHelloReq other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$QueryHelloReq;
  }

  @override
  void update(void Function(QueryHelloReqBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  QueryHelloReq build() => _build();

  _$QueryHelloReq _build() {
    final _$result = _$v ??
        new _$QueryHelloReq._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'QueryHelloReq', 'id'),
            date: BuiltValueNullFieldError.checkNotNull(
                date, r'QueryHelloReq', 'date'),
            dateGmt: BuiltValueNullFieldError.checkNotNull(
                dateGmt, r'QueryHelloReq', 'dateGmt'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'QueryHelloReq', 'type'),
            link: BuiltValueNullFieldError.checkNotNull(
                link, r'QueryHelloReq', 'link'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
